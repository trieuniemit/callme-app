import 'package:flutter_webrtc/rtc_ice_candidate.dart';
import 'package:flutter_webrtc/rtc_session_description.dart';

class RTCCandidate extends RTCIceCandidate {
  RTCCandidate(String candidate, String sdpMid, int sdpMlineIndex) : super(candidate, sdpMid, sdpMlineIndex);

  static RTCCandidate fromMap(Map<String, dynamic> candidate)  {
    return RTCCandidate(
      candidate['sdpMLineIndex'],
      candidate['sdpMid'],
      candidate['candidate'],
    );
  }
  
}