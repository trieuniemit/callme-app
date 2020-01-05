import 'package:flutter/cupertino.dart';
import 'package:callme/screens/main/main_screen.dart';

class AppRoutes {
  static const String home = '/';

  static Route<dynamic> appRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home: 
        return CupertinoPageRoute(builder:(context) => MainScreen());
      break;
      default: 
        return null;
    }
  }
}

