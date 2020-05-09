enum WebRTCMedia {VIDEO, AUDIO, DATA}

// setup iceServers
Map<String, dynamic> iceServers = {
  'iceServers': [
    {
      'url': 'stun:stun.l.google.com:19302'
    },
    {
      "url": "stun:stun1.l.google.com:19302"
    },
    {
      "url": "stun:stun2.l.google.com:19302"
    },
    {
      "url": "stun:stun3.l.google.com:19302"
    },
    {
      "url": "stun:stun4.l.google.com:19302"
    },
    {
      "url": "stun:stun01.sipphone.com"
    },
    {
      "url": "stun:stun.ekiga.net"
    },
    {
      'url': 'turn:149.28.137.246',
      'username': 'webrtc',
      'credential': r"$*DfDbH?X>&yEZ5E"
    },
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
