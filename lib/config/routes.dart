import 'package:app.callme/screens/calling/receive/call_receive_screen.dart';
import 'package:app.callme/screens/calling/start/call_screen.dart';
import 'package:app.callme/screens/login/login_screen.dart';
import 'package:app.callme/screens/register/register_screen.dart';
import 'package:app.callme/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:app.callme/screens/main/main_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String callStart = '/call_start';
  static const String callReceive = '/call_receive';

  static Route<dynamic> appRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splash: 
        return _routeConfig(SplashScreen());
      case login: 
        return _routeConfig(LoginScreen());
      case register: 
        return _routeConfig(RegisterScreen());
      case callReceive: 
        Map args = settings.arguments;
        return _routeConfig(CallReceiveScreen(
          callingUser: args['user']
        ));
      break;
      case callStart: 
        Map args = settings.arguments;
        return _routeConfig(CallScreen(
          callingUser: args['user']
        ));
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

