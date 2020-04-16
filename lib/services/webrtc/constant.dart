import 'package:flutter_webrtc/rtc_session_description.dart';

enum WebRTCMedia {VIDEO, AUDIO, DATA}

// setup iceServers
Map<String, dynamic> iceServers = {
  'iceServers': [
    {
      //'url': 'stun.l.google.com:19302',
      // 'username': 'change_to_real_user',
      // 'credential': 'change_to_real_secret'
    }
  ]
};

// config
final Map<String, dynamic> config = {
  'mandatory': {},
  'optional': [
    {'DtlsSrtpKeyAgreement': true},
  ],
};

// constraints
final Map<String, dynamic> mediaConst = {
  'mandatory': {
    'OfferToReceiveAudio': true,
    'OfferToReceiveVideo': true,
  },
  'optional': [],
};

final Map<String, dynamic> dataChannelConst = {
  'mandatory': {
    'OfferToReceiveAudio': false,
    'OfferToReceiveVideo': false,
  },
  'optional': [],
};
