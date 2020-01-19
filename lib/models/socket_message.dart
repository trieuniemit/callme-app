import 'dart:convert';

class SocketMessage {
  String action;
  Map<String, dynamic> data;

  SocketMessage(message) {
    try {
      Map mData = json.decode(message);
      action = mData["action"];
      data = Map<String, dynamic>.from(mData["data"]);
    } catch(_) {

    }
  }
  
  @override
  String toString() {
    return "SocketMessage {action: $action, data: $data}";
  }
}