import 'package:app.callme/screens/login/login_screen.dart';
import 'package:app.callme/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:app.callme/screens/main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';

  static Route<dynamic> appRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splash: 
        return CupertinoPageRoute(builder:(context) => SplashScreen());
      case home: 
        return CupertinoPageRoute(builder:(context) => MainScreen());
      break;
      case login: 
        return CupertinoPageRoute(builder:(context) => LoginScreen());
      break;
    }
  }
}

