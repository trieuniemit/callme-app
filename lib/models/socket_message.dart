import 'dart:convert';

class SocketMessage {
  String action;
  Map<String, dynamic> data;

  SocketMessage(message) {
    Map mData = json.decode(message);
    action = mData["action"];
    data = Map<String, dynamic>.from(mData["data"]);
  }
  
  @override
  String toString() {
    return "SocketMessage {action: $action, data: $data}";
  }
}