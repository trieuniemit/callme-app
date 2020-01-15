import 'package:app.callme/screens/calling/calling_screen.dart';
import 'package:app.callme/screens/login/login_screen.dart';
import 'package:app.callme/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:app.callme/screens/main/main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String calling = '/calling';

  static Route<dynamic> appRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splash: 
        return _routeConfig(SplashScreen());
      case login: 
        return _routeConfig(LoginScreen());
      case calling: 
        Map args = settings.arguments;
        return _routeConfig(CallingSceen(
          mainBloc: args['bloc'], 
          user: args['user'], 
          isRequest: args['is_request'])
        );
      break;
      case home: 
      default: 
        return _routeConfig(MainScreen());
    }
  }

  static Route<dynamic> _routeConfig(Widget screen) {
    return CupertinoPageRoute(builder:(context) => screen);
  }
}

