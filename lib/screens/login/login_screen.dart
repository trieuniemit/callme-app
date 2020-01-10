import 'package:app.callme/bloc/app_bloc.dart';
import 'package:app.callme/bloc/app_event.dart';
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

  final TextEditingController usernameCtrl = TextEditingController(text: 'trieuniemit@gmail.com');
  final TextEditingController passwordCtrl = TextEditingController(text: '123456');

  void _signIn(context) async {
    LoginBloc.of(context).add(LoginButtonPressed(usernameCtrl.text, passwordCtrl.text));
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(context)
        ),
        BlocProvider<AppBloc>(
          create: (context) => AppBloc.of(context),
        )
      ],
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is AuthenticatedState || state is LoginSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
          }
        },
        child: Scaffold(
          body: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
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
                          controller: usernameCtrl,
                          decoration: InputDecoration(
                          hintText: AppLg.of(context).trans('username')
                        ),
                      ),
                      TextFormField(
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: AppLg.of(context).trans('password')
                        ),
                      ),
                      SizedBox(height: 15),
                      state is LoginFailState ? Text(state.message, style: TextStyle(color: Colors.red)) : Container(),
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
              );
            },
          )
        )
      )
    );
  }

}