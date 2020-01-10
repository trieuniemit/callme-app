import 'package:app.callme/validators/regexs.dart';

class LoginValidator {
  
  static bool username(String username) {
    return Regexs.username.hasMatch(username);
  }

  static bool password(String password) {
    return Regexs.password.hasMatch(password);
  }

}