import 'dart:convert';

import 'package:app.callme/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRepository {
  
  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<Map<String, dynamic>> checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String token = prefs.getString('token');
      Map userMap = Map<String, dynamic>.from(json.decode(prefs.getString('user')));

      return {
        "status": true,
        "user":  User.fromMap(userMap),
        "token": token
      };
    } catch (_) {
      return {
        "status": false
      };
    }

  }
}