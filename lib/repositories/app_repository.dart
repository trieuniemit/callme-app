import 'dart:convert';
import 'package:app.callme/config/constants.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/services/api_service.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppRepository {

  Future<Map<String, dynamic>> authenticate({ 
    @required String username, 
    @required String password }) 
  async {
    
    await Future.delayed(Duration(seconds: 1));

    Map res = await ApiService.request(
      method: Request.POST,
      path: Constants.LOGIN,
      params: {
        "password": password,
        "username": username
      }
    );
    
    return Map<String, dynamic>.from(res);
  }
  
  

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }


  Future<void> saveToken(User user, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await  prefs.setString('user', json.encode(user.toMap()));

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