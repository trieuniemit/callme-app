import 'package:app.callme/services/webrtc/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:meta/meta.dart';


class WebRTCService {

  var _peerConnections = new Map<String, RTCPeerConnection>();
  var _dataChannels = new Map<String, RTCDataChannel>();
  
  List<RTCIceCandidate> _remoteCandidates = [];
  List<RTCIceCandidate> _localCandidates = [];

  List<RTCIceCandidate> get localCandidates =>  _localCandidates;
  List<RTCIceCandidate> get remoteCandidates =>  _remoteCandidates;

  //final Function(Map<String, dynamic>) onSendMessage;
  final Function(MediaStream) onAddLocalStream;
  final Function(MediaStream) onAddRemoteStream;
  final Function(RTCIceConnectionState) onStateChange;

  MediaStream localStream;
  List<MediaStream> remoteStreams = List();

  WebRTCService({
    @required this.onAddLocalStream, 
    @required this.onAddRemoteStream,
    @required this.onStateChange
  });


  // close connection ...
  void close() {
    if (localStream != null) {
      localStream.dispose();
      localStream = null;
    }

    remoteStreams.clear();

    _peerConnections.forEach((key, pc) => pc.close());
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
          'minWidth': '640',
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'environment', // user
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
        print('==WebRTC: New Candidate: ${candidate.toMap()}');
        _localCandidates.add(candidate);
      };
    }

    pc.onIceConnectionState = (RTCIceConnectionState  state) {
      print("IceConnection State: ${state.toString()}");
      this.onStateChange(state);
    };

    pc.onAddStream = (stream) {
      remoteStreams.add(stream);
      this.onAddRemoteStream(stream);
    };

    pc.onRemoveStream = (stream) {
      remoteStreams.removeWhere((it) {
        return (it.id == stream.id);
      });
    };

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
      _peerConnections[sessionId] = pc;

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
    print("WebRTC: Created answer============");

    RTCPeerConnection pc = await _createPeerConnection(sessionId, media, useScreen);

    if (media == WebRTCMedia.DATA) {
      _createDataChannel(pc);
    }

    pc.setRemoteDescription(remoteDesc);

    try {
      RTCSessionDescription s = await pc.createAnswer(media == WebRTCMedia.DATA ? dataChannelConst : mediaConst);
      pc.setLocalDescription(s);
      
      _peerConnections[sessionId] = pc;

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

  void setRemoteDescription(String sessionId, RTCSessionDescription description) async {
    var pc = _peerConnections[sessionId];
    if (pc != null) {
      print("WebRTC: Set remote description=======");
      await pc.setRemoteDescription(description);
    } else {
      print("WebRTC: Can't cet remote description. Connection not found=======");
    }
  }

  void setRemoteCandidate(String sessionId, RTCIceCandidate remoteCandidate) async {
    var pc = _peerConnections[sessionId];
    if (pc != null) {
      await pc.addCandidate(remoteCandidate);
    } else {
      _remoteCandidates.add(remoteCandidate);
    }
  }

}