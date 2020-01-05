import 'package:app.callme/screens/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:app.callme/screens/main/main_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';

  static Route<dynamic> appRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home: 
        return CupertinoPageRoute(builder:(context) => MainScreen());
      break;
      case login: 
        return CupertinoPageRoute(builder:(context) => LoginScreen());
      break;
      default: 
        return null;
    }
  }
}

