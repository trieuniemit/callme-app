import 'dart:core';

import 'package:app.callme/models/user_model.dart';

class CallHistory {
  int id;
  User user;
  DateTime dateTime;
  int length;
  
  CallHistory({this.id, this.user, this.length, this.dateTime});
  
  static CallHistory fromMap(Map<String, dynamic> map) {
    return CallHistory(
      id: map.containsKey('id') ? map['id'] : -1,
      user: map.containsKey('user') ? User.fromMap(map['user']) : null,
      length: map.containsKey('length') ? map['length'] : -1,
      dateTime: map.containsKey('date_time') ? DateTime.parse(map['date_time']) : DateTime.now()
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'date_time': dateTime,
      'length': length
    };
  }
}