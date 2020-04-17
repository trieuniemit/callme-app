enum WebRTCMedia {VIDEO, AUDIO, DATA}

// setup iceServers
Map<String, dynamic> iceServers = {
  'iceServers': [
    {
      'url': 'stun:stun.l.google.com:19302',
      // 'username': 'change_to_real_user',
      // 'credential': 'change_to_real_secret'
    },
    {
      'url': 'turn:149.28.137.246',
      'username': 'webrtc',
      'credential': r"$*DfDbH?X>&yEZ5E"
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
