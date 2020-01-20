import 'package:app.callme/services/webrtc/constant.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:meta/meta.dart';


class WebRTCService {

  var _peerConnections = new Map<String, RTCPeerConnection>();
  var _dataChannels = new Map<String, RTCDataChannel>();
  var _remoteCandidates = [];

  //final Function(Map<String, dynamic>) onSendMessage;
  final Function(Map<String, dynamic>) onCandidate;
  final Function(MediaStream) onAddLocalStream;
  final Function(MediaStream) onAddRemoteStream;

  MediaStream localStream;
  List<MediaStream> remoteStreams = List();

  WebRTCService({
    @required this.onAddLocalStream, 
    @required this.onCandidate,
    @required this.onAddRemoteStream
  });


  // close connection ...
  void close() {
    if (localStream != null) {
      localStream.dispose();
      localStream = null;
    }

    _peerConnections.forEach((key, pc) =>pc.close());
  }

  // switch camera
  void switchCamera() {
    if (localStream != null) {
      localStream.getVideoTracks()[0].switchCamera();
    }
  }

  // createStream
  Future<MediaStream> _createStream(media, bool useScreen) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    if (useScreen)
      return await navigator.getDisplayMedia(mediaConstraints);
    else
      return await navigator.getUserMedia(mediaConstraints);
  }


  Future<RTCPeerConnection>  _createPeerConnection(String sessionId, WebRTCMedia media, bool useScreen) async {
    if (media != WebRTCMedia.DATA) {
      localStream = await _createStream(media, useScreen);
      this.onAddLocalStream(localStream);
    }
    RTCPeerConnection pc = await createPeerConnection(iceServers, config);
    
    if (media != WebRTCMedia.DATA) {
      pc.addStream(localStream);
      pc.onIceCandidate = (candidate) {
        this.onCandidate({
          'candidate': {
            'sdpMLineIndex': candidate.sdpMlineIndex,
            'sdpMid': candidate.sdpMid,
            'candidate': candidate.candidate,
          },
          'session_id': sessionId,
        });
      };
    }

    pc.onIceConnectionState = (state) {};

    pc.onAddStream = (stream) {
      remoteStreams.add(stream);
      this.onAddRemoteStream(stream);
    };

    pc.onRemoveStream = (stream) {
      remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

    // pc.onDataChannel = (channel) {
    //   _addDataChannel(channel);
    // };

    print("WebRTC: Peer connection created==========");
    return pc;
  }

 
  // void _addDataChannel(RTCDataChannel channel) {
  //   channel.onDataChannelState = (e) {};
  //   _dataChannels[this.sessionId] = channel;
  // }


  void _createDataChannel(RTCPeerConnection pc, {label: 'fileTransfer'}) async {
    RTCDataChannelInit dataChannelDict = new RTCDataChannelInit();
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    // _addDataChannel(channel);
    print("Data Channel created: " + channel.toString());
  }

  /*
   * Create offer for current connect session
   */
  Future<Map<String, dynamic>> createOffer({@required String sessionId, @required WebRTCMedia media, @required bool useScreen}) async {
    print("WebRTC: Create offer============");
    RTCPeerConnection pc = await _createPeerConnection(sessionId, media, useScreen);
    
    _peerConnections[sessionId] = pc;

    if (media == WebRTCMedia.DATA) {
      _createDataChannel(pc);
    }

    try {
      RTCSessionDescription s = await pc.createOffer(media == WebRTCMedia.DATA ? dataChannelConst : mediaConst);
      pc.setLocalDescription(s);

      var sessionDesc = {
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': sessionId,
        //'media': media,
      };

      print("WebRTC: Session description Created==========");

      return sessionDesc;
    } catch (e) {
      print("Create offer error: " + e.toString());
      return {};
    }
  }

  /*
   * Create answer when received offer from request
   */
  Future<Map<String, dynamic>> createAnswer({@required String sessionId, @required WebRTCMedia media, 
    @required bool useScreen, @required RTCSessionDescription remoteDesc}) async {
    print("WebRTC: Create answer============");
    try {
      RTCPeerConnection pc = await _createPeerConnection(sessionId, media, useScreen);
      print("WebRTC: Answer desc=========");

      pc.setRemoteDescription(remoteDesc);
      
      RTCSessionDescription s = await pc.createAnswer(media == WebRTCMedia.DATA ? dataChannelConst : mediaConst);
      pc.setLocalDescription(s);

      if (this._remoteCandidates.length > 0) {
        _remoteCandidates.forEach((candidate) async {
          await pc.addCandidate(candidate);
        });
        _remoteCandidates.clear();
      }

      return {
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': sessionId,
      };
    } catch (e) {
      print("Error create answer========");
      print(e.toString());
    }
    return null;
  }

  void addCandidate(String sessionId, RTCIceCandidate candidate) async {
    var pc = _peerConnections[sessionId];
    if (pc != null) {
      await pc.addCandidate(candidate);
    } else {
      _remoteCandidates.add(candidate);
    }
  }
}