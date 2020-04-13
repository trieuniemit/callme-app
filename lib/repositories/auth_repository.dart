import 'package:app.callme/config/constants.dart';
import 'package:app.callme/services/api_service.dart';
import 'package:meta/meta.dart';

class AuthRepository {
  
  Future<Map<String, dynamic>> authenticate({ @required String username, @required String password }) async {
    
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
  
    
  Future<Map<String, dynamic>> register({ @required String phoneNumber, @required String fullname, @required String password }) async {
    
    await Future.delayed(Duration(seconds: 1));

    Map res = await ApiService.request(
      method: Request.POST,
      path: Constants.REGISTER,
      params: {
        "password": password,
        "fullname": fullname,
        "username": phoneNumber
      }
    );
    
    return Map<String, dynamic>.from(res);
  }
  
}