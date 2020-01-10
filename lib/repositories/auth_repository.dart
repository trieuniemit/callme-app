import 'package:app.callme/config/constants.dart';
import 'package:app.callme/services/api_service.dart';
import 'package:meta/meta.dart';

class AuthRepository {
  
    Future<Map<String, dynamic>> authenticate({ @required String username, @required String password }) async {  

      return await ApiService.request(
        method: ApiService.POST,
        path: Constants.LOGIN,
        params: {
          "password": password,
          "email": username
        }
      );
    
    }
}