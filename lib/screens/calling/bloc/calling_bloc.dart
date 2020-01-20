import 'dart:async';
import 'package:app.callme/models/socket_message.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:app.callme/services/webrtc/constant.dart';
import 'package:app.callme/services/webrtc/webrtc_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/rtc_ice_candidate.dart';
import 'package:flutter_webrtc/rtc_session_description.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class CallingBloc extends Bloc<CallingEvent, CallingState> {
  
  final MainBloc mainBloc;
  final bool isRequest;
  final Map<String, dynamic> offerRecieved;

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

  CallingBloc({this.offerRecieved, this.isRequest = false, this.mainBloc}) {
    _socketSubscription = socketConn.stream.listen(_socketListener);
    // init renderer
    _initWebRTC();
  }

  void _initWebRTC() async {
    this._webRTCService = WebRTCService(
      onAddLocalStream: (stream) {
        localRenderer.srcObject = stream;
        print("LocalStream ID: " + stream.id);
      },
      onAddRemoteStream: (stream) {
        localRenderer.srcObject = stream;
        print("RemoteStream ID: " + stream.id);
      },
    );

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    if(!isRequest) {
      var _offerSend = await this._webRTCService.createOffer(
        sessionId: DateTime.now().millisecondsSinceEpoch.toString(),
        media: WebRTCMedia.VIDEO, useScreen: false
      );

      socketConn.emit('call_start', {'target': user.socketId, ..._offerSend});
    }
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
        String sessionId = offerRecieved['session_id'];

        RTCSessionDescription description = RTCSessionDescription(
          offerRecieved['description']['sdp'], 
          offerRecieved['description']['type']
        );
        Map<String, dynamic> anwser = await this._webRTCService.createAnswer(
          sessionId: sessionId, 
          media: WebRTCMedia.VIDEO, 
          useScreen: false,
          remoteDesc: description
        );
        socketConn.emit('call_accepted', {'target': user.socketId, ...anwser});
      }

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        Duration duration = Duration(seconds: timer.tick);
        String seconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
        String mins = duration.inMinutes.remainder(60).toString().padLeft(2,'0');
        String hours = duration.inHours.toString().padLeft(2,'0');
        if (!_noticeCtl.isClosed) {
          _noticeCtl.sink.add("$hours:$mins:$seconds");
        }
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
        String sessionId = message.data['session_id'];

        RTCSessionDescription description = RTCSessionDescription(
          message.data['description']['sdp'], 
          message.data['description']['type']
        );
        this._webRTCService.setRemoteDescription(sessionId, description);
        this.add(UserCallAccepted());

        List<Map<String, dynamic>> localCadidates = this._webRTCService.candidates;

        socketConn.emit('call_candidate', {'target': user.socketId, 'candidates' : localCadidates, 'session_id': sessionId, 'is_request': true});

      break;
      case 'call_candidate':
        String sessionId = message.data['session_id'];
        
        List listCandidates = message.data['candidates'];

        listCandidates.forEach((value) {
          RTCIceCandidate candidate = new RTCIceCandidate(
            value['candidate'],
            value['sdpMid'],
            value['sdpMLineIndex']
          );
          this._webRTCService.setRemoteCandidate(message.data['session_id'], candidate);
        });

        if (message.data.containsKey('is_request')) {
          List<Map<String, dynamic>> localCadidates = this._webRTCService.candidates;
          socketConn.emit('call_candidate', {'target': user.socketId, 'candidates' : localCadidates, 'session_id': sessionId});
        }
      break;
      
    }
  }

}
