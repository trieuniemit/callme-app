import 'dart:async';
import 'package:app.callme/bloc/app_bloc.dart';
import 'package:app.callme/models/socket_message.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:app.callme/services/webrtc/constant.dart';
import 'package:app.callme/services/webrtc/video_view.dart';
import 'package:app.callme/services/webrtc/webrtc_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/enums.dart';
import 'package:flutter_webrtc/rtc_ice_candidate.dart';
import 'package:flutter_webrtc/rtc_session_description.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import './bloc.dart';

class CallReceiveBloc extends Bloc<CallReceiveEvent, CallReceiveState> {
  
  String _sessionId;

  Map<String, dynamic> offerRecieved;

  StreamSubscription<SocketMessage> _socketSubscription;
  StreamController<String> _noticeCtl = StreamController();
  WebRTCService _webRTCService;

  SocketConnection get socketConn => SocketConnection.getInstance();
  User callingUser;

  RTCVideoRenderer secondRenderer = RTCVideoRenderer();
  RTCVideoRenderer mainRenderer = RTCVideoRenderer();


  static CallReceiveBloc of(context) {
    return Provider.of<CallReceiveBloc>(context, listen: false);
  }


  @override
  CallReceiveInitial get initialState => CallReceiveInitial();

  CallReceiveBloc({this.callingUser}) {
    _socketSubscription = socketConn.stream.listen(_socketListener);
    _initWebRTC();
    Wakelock.enable();
  }

  void _initWebRTC() async {
    this._webRTCService = WebRTCService(
      onAddLocalStream: (stream) {
        mainRenderer.srcObject = stream;
        print("LocalStream ID: " + stream.id);
        try {
        _webRTCService.switchCamera();
        } catch(_) {
          print('WebRTC: Error when switch camera=====');
        }
      },
      onAddRemoteStream: (stream) async {
        mainRenderer.srcObject = stream;
        secondRenderer.srcObject = _webRTCService.localStream;
        print("RemoteStream ID: " + stream.id);
      },
      onCandidate: (candidate) {
        socketConn.emit('call_candidate', {
          'target': callingUser.socketId, 
          'candidate' : candidate
        });
      },
      onStateChange: (state) {
        switch(state) {
          case RTCIceConnectionState.RTCIceConnectionStateConnected:
            
            break;
          case RTCIceConnectionState.RTCIceConnectionStateFailed:
            this.add(CallReceiveEnded());
            break;
          case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
            
            break;

          default:
        }
      }
    );

    await mainRenderer.initialize();
    await secondRenderer.initialize();
    
    if(offerRecieved != null) {
       _sessionId = offerRecieved['session_id'];
    }
  }

  @override
  Future<void> close() async {
    super.close();
    _socketSubscription.cancel();

    mainRenderer.srcObject = null;
    secondRenderer.srcObject = null;
    await mainRenderer.dispose();
    await secondRenderer.dispose();
    _webRTCService.close();
    
    Wakelock.disable();
  }

  @override
  Stream<CallReceiveState> mapEventToState(CallReceiveEvent event) async* {
    if (event is CallReceiveEnded) {
      socketConn.emit('call_end', {'target': callingUser.socketId});
      yield CallReceiveEndedState();
    } else if (event is CallReceiveAccepted) {

      if (event is CallReceiveAccepted) {
        RTCSessionDescription description = RTCSessionDescription(
          offerRecieved['description']['sdp'], 
          offerRecieved['description']['type']
        );
        Map<String, dynamic> anwser = await this._webRTCService.createAnswer(
          sessionId: _sessionId, 
          media: WebRTCMedia.VIDEO, 
          useScreen: false,
          remoteDesc: description
        );
        socketConn.emit('call_accepted', {'target': callingUser.socketId, ...anwser});
      }

      secondRenderer.mirror = !secondRenderer.mirror;
      mainRenderer.mirror = !mainRenderer.mirror;

      yield CallReceiveAcceptedState();
    }
  }

  void _socketListener(SocketMessage message) async {
    switch(message.action) {
      case 'call_end':
        this.add(CallReceiveEnded());
      break;

      case 'call_candidate':
        Map<String, dynamic> candidate = message.data['candidate'];
        RTCIceCandidate candidateObj = new RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex']
        );
        this._webRTCService.setRemoteCandidate(_sessionId, candidateObj);
      break;
      
    }
  }
}
