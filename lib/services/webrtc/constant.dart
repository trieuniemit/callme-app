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
    // {
    //   'url': 'turn:157.230.34.76',
    //   'username': 'admin',
    //   'credential': "admin123"
    // }
    {
      'url': 'turn:numb.viagenie.ca',
      'credential': 'muazkh',
      'username': 'webrtc@live.com'
    },
    {
        'url': 'turn:192.158.29.39:3478?transport=udp',
        'credential': 'JZEOEt2V3Qb0y27GRntt2u2PAYA=',
        'username': '28224511:1379330808'
    },
    {
        'url': 'turn:192.158.29.39:3478?transport=tcp',
        'credential': 'JZEOEt2V3Qb0y27GRntt2u2PAYA=',
        'username': '28224511:1379330808'
    },
    {
        'url': 'turn:turn.bistri.com:80',
        'credential': 'homeo',
        'username': 'homeo'
    },
    {
        'url': 'turn:turn.anyfirewall.com:443?transport=tcp',
        'credential': 'webrtc',
        'username': 'webrtc'
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
