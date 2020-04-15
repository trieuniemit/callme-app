import 'package:app.callme/bloc/app_bloc.dart';
import 'package:app.callme/components/loading.dart';
import 'package:app.callme/config/routes.dart';
import 'package:app.callme/language.dart';
import 'package:app.callme/screens/login/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController usernameCtrl = TextEditingController(text: '0395710844');
  final TextEditingController passwordCtrl = TextEditingController(text: '123456');

  void _signIn(context) async {
    LoginBloc.of(context).add(LoginButtonPressed(usernameCtrl.text, passwordCtrl.text));
  }
  
  void _openRegisterScreen(context) {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(AppBloc.of(context)),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
          } else if (state is LoginProcessState) {
            Loading(context).show(text: AppLg.of(context).trans('logging_in'));
          } else if (state is LoginFailState) {
            Navigator.of(context).pop();
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: AppLg.of(context).trans('phone_number')
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
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(AppLg.of(context).trans('dont_have_account')),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () => _openRegisterScreen(context),
                              child: Text(AppLg.of(context).trans('register'), style: TextStyle(color: Colors.blue)),
                            )
                          ],
                        )
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