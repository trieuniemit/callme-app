import 'dart:async';
import 'package:app.callme/models/socket_message.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:app.callme/services/webrtc/constant.dart';
import 'package:app.callme/services/webrtc/webrtc_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_ice_candidate.dart';
import 'package:flutter_webrtc/rtc_session_description.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class CallingBloc extends Bloc<CallingEvent, CallingState> {
  
  final MainBloc mainBloc;
  final bool isRequest;

  User get user => mainBloc.state.callingUser;

  StreamSubscription<SocketMessage> _socketSubscription;
  StreamController<String> _noticeCtl = StreamController();

  WebRTCService _webRTCService;

  Timer _timer;

  SocketConnection get socketConn => mainBloc.socketConnection;
  Stream<String> get noticeStream => _noticeCtl.stream;

  //Render
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();


  static CallingBloc of(context) {
    return Provider.of<CallingBloc>(context, listen: false);
  }


  @override
  CallingState get initialState => InitialCallingState();

  CallingBloc({this.isRequest = false, this.mainBloc}) {
    _socketSubscription = socketConn.stream.listen(_socketListener);

    if(!isRequest) {
      socketConn.emit('call_start', {'target': user.socketId});
    }
    // init renderer
    initRenderers();
  }

  void initRenderers() async {
    this._webRTCService = WebRTCService(
      onCandidate: (candidate) {
        //socketConn.emit('call_candidate', {'target': user.socketId, ...candidate});
      },
      onAddLocalStream: (stream) {
        //localRenderer.srcObject = stream;
        print("LocalStream ID: " + stream.id);
      },
      onAddRemoteStream: (stream) {
        localRenderer.srcObject = stream;
        print("RemoteStream ID: " + stream.id);
      },
    );

    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  @override
  Future<void> close() async {
    super.close();
    _socketSubscription.cancel();
    _noticeCtl.close();

    if (_timer != null) {
      _timer.cancel();
    }

    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    await localRenderer.dispose();
    await remoteRenderer.dispose();
  }

  @override
  Stream<CallingState> mapEventToState(CallingEvent event) async* {
    if (event is CallNotAvailable) {
      await Future.delayed(Duration(seconds: 2));
      yield CallNotAvailableState();

    } else if (event is CallTargetBusy) {
      await Future.delayed(Duration(seconds: 2));
      yield CallTargetBusyState();

    } else if (event is CallEnded || event is UserCallEnded) {
      if (event is CallEnded) {
        socketConn.emit('call_end', {'target': user.socketId});
      }
      yield CallEndedState();
      
    } else if (event is CallBusy) {
      socketConn.emit('call_busy', {'target': user.socketId});
      yield CallBusyState();

    } else if (event is CallAccepted  || event is UserCallAccepted) {

      if (event is CallAccepted) {
        String sessionId = user.socketId;
        socketConn.emit('call_accepted', {'target': user.socketId});
        
        this._webRTCService.createOffer(sessionId: sessionId, media: WebRTCMedia.VIDEO, useScreen: false).then((offer) {
          socketConn.emit('call_offer', {'target': user.socketId, ...offer});
        });
      } else {
        // create answer for webrtc
        //socketConn.emit('call_accepted', {'target': user.socketId});
      }

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        Duration duration = Duration(seconds: timer.tick);
        String seconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
        String mins = duration.inMinutes.remainder(60).toString().padLeft(2,'0');
        String hours = duration.inHours.toString().padLeft(2,'0');
        _noticeCtl.sink.add("$hours:$mins:$seconds");
      });
      
      yield CallAcceptedState();

    }
  }

  void _socketListener(SocketMessage message) async {
    switch(message.action) {
      case 'call_not_available': 
        this.add(CallNotAvailable());
      break;
      case 'call_busy':
        this.add(CallTargetBusy());
      break;
      case 'call_end':
        this.add(UserCallEnded());
      break;
      case 'call_accepted':
        this.add(UserCallAccepted());
      break;
      case 'call_candidate':
        Map<String,dynamic> candidateMap = message.data['candidate'];

        RTCIceCandidate candidate = new RTCIceCandidate(
          candidateMap['candidate'],
          candidateMap['sdpMid'],
          candidateMap['sdpMLineIndex']
        );

        this._webRTCService.addCandidate(message.data['session_id'], candidate);
        
      break;
      case 'call_offer':
         RTCSessionDescription description = RTCSessionDescription(
          mainBloc.state.webRTCDesc['sdp'], 
          mainBloc.state.webRTCDesc['type']
        );
        Map<String, dynamic> answerData = await this._webRTCService.createAnswer(
          sessionId: user.socketId, 
          media: WebRTCMedia.VIDEO, 
          useScreen: false,
          remoteDesc: description
        );

        socketConn.emit('call_answer', {'target': user.socketId, ...answerData});
      break;
    }
  }

}
