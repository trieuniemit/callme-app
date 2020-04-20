import 'dart:async';
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

class CallBloc extends Bloc<CallEvent, CallState> {
  
  String _sessionId;
  Map<String, dynamic> _offerCreated;

  StreamSubscription<SocketMessage> _socketSubscription;
  WebRTCService _webRTCService;

  SocketConnection get socketConn => SocketConnection.getInstance();
  User callingUser;

  RTCVideoRenderer secondRenderer = RTCVideoRenderer();
  RTCVideoRenderer mainRenderer = RTCVideoRenderer();

  int callLength = 0;
  Timer _timer;

  static CallBloc of(context) {
    return Provider.of<CallBloc>(context, listen: false);
  }

  @override
  CallInitial get initialState => CallInitial();

  CallBloc({this.callingUser}) {
    _socketSubscription = socketConn.stream.listen(_socketListener);
    _initWebRTC();
    Wakelock.enable();

    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
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
      onStateChange: (state) {
        switch(state) {
          case RTCIceConnectionState.RTCIceConnectionStateConnected:
            
            break;
          case RTCIceConnectionState.RTCIceConnectionStateFailed:
            this.add(CallEnded());
            _timer = Timer.periodic(Duration(seconds: 1), (length) {
              callLength++;
            });
            break;
          case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
            
            break;

          default:
        }
      }
    );

    await mainRenderer.initialize();
    await secondRenderer.initialize();
    mainRenderer.mirror = true;
    secondRenderer.mirror = true;
    
    // created offer
    _offerCreated = await this._webRTCService.createOffer(
      sessionId: _sessionId,
      media: WebRTCMedia.VIDEO, 
      useScreen: false
    );

    // send request
    socketConn.emit('call_start', {'target': callingUser.socketId});
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
    _timer.cancel();
  }

  @override
  Stream<CallState> mapEventToState(CallEvent event) async* {
    if (event is CallEnded) {
      socketConn.emit('call_end', {'target': callingUser.socketId});
      yield CallEndedState();
    } else if (event is CallAccepted) {
      
      print('==WebRTC: Send offer');
      socketConn.emit('call_offer', {
        'target': callingUser.socketId, 
        'offer' : _offerCreated
      });

      yield CallAcceptedState();

    } else if (event is CallNotAvailable) {
      
      await Future.delayed(Duration(seconds: 2));
      yield CallNotAvailableState();

    } else if (event is CallBusy) {
      yield CallBusyState();
    } 
  }

  void _socketListener(SocketMessage message) async {
    switch(message.action) {
      case 'call_end':
        this.add(CallEnded());
      break;

      case 'call_candidate':
        List candidates = message.data['candidate'];
        candidates.forEach((can) {
          RTCIceCandidate candidateObj = new RTCIceCandidate(
            can['candidate'],
            can['sdpMid'],
            can['sdpMLineIndex']
          );
          this._webRTCService.setRemoteCandidate(_sessionId, candidateObj);
        });
      break;

      case 'call_offer':
        _setRemoteDescription(message);
      break;

      case 'call_accepted':
        this.add(CallAccepted());
      break;

      case 'call_busy':
        this.add(CallBusy());
      break;

      case 'call_not_available':
        this.add(CallNotAvailable());
      break;
      
    }
  }

  void _sendLocalCandidates() {
    var localCandidates = [];
    _webRTCService.localCandidates.forEach((c) {
      localCandidates.add({
        'sdpMLineIndex': c.sdpMlineIndex,
        'sdpMid': c.sdpMid,
        'candidate': c.candidate,
      });
    });
    socketConn.emit('call_candidate', {
      'target': callingUser.socketId, 
      'candidate' : localCandidates
    });
    print('==WebRTC: Send candidate');
  }

  void _setRemoteDescription(SocketMessage message) {
    print('==WebRTC: Receive offer');
    
    Map offer = message.data['offer'];

    RTCSessionDescription description = RTCSessionDescription(
      offer['description']['sdp'], 
      offer['description']['type']
    );
    
    this._webRTCService.setRemoteDescription(_sessionId, description);

    print('==WebRTC: Set remote desc');
    _sendLocalCandidates();
  }
}
