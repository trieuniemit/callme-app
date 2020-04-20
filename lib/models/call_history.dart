import 'dart:convert';
import 'dart:core';

import 'package:app.callme/models/user_model.dart';
import 'package:intl/intl.dart';

class CallType {
  static int receive = 2;
  static int call = 1;
}

class CallHistory {
  int id;
  User user;
  DateTime dateTime;
  int length;
  int type;
  
  CallHistory({this.id, this.user, this.length, this.dateTime, this.type});
  
  static CallHistory fromMap(Map<String, dynamic> map) {
    return CallHistory(
      id: map.containsKey('id') ? map['id'] : 1,
      type: map.containsKey('type') ? map['type'] : 0,
      user: map.containsKey('user') ? User.fromMap(json.decode(map['user'])) : User(),
      length: map.containsKey('length') ? map['length'] : -1,
      dateTime: map.containsKey('date_time') ? DateTime.parse(map['date_time']) : DateTime.now()
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'user': json.encode(user.toMap()),
      'date_time': DateFormat("yyyy-MM-dd hh:mm:ss").format(dateTime),
      'length': length
    };
  }
}