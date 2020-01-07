import 'package:app.callme/bloc/app_state.dart';
import 'package:app.callme/config/routes.dart';
import 'package:app.callme/language.dart';
import 'package:app.callme/screens/login/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class LoginScreen extends StatelessWidget {

  void _signIn(context) async {
    
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
          }
        },
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.only(bottom: 50, left: 50, right: 50),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/flutter-logo.png',
                    width: 200,
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                      hintText: AppLg.of(context).trans('username')
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppLg.of(context).trans('password')
                    ),
                  ),
                  SizedBox(height: 30),
                  CupertinoButton(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(70)),
                    onPressed: () => _signIn(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.white),
                        SizedBox(width: 10),
                        Text(AppLg.of(context).trans('login'), style: TextStyle(color: Colors.white))
                      ]
                    ),
                  )
                ],
              )
            )
          )
        )
      )
    );
  }

}