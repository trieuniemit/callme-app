import 'package:app.callme/language.dart';
import 'package:app.callme/screens/register/bloc/register_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController phoneNumberCtrl = TextEditingController();
  final TextEditingController fullnameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPwdCtrl = TextEditingController();
    
  void _registerBtnPressed(context) {
    RegisterBloc.of(context).add(RegisterButtonPressed(
      phoneNumber: phoneNumberCtrl.text, 
      password: passwordCtrl.text, 
      confirmPassword: confirmPwdCtrl.text
    ));
  }
    
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        body: BlocBuilder<RegisterBloc, RegisterState>(
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
                      controller: phoneNumberCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: AppLg.of(context).trans('phone_number')
                      ),
                    ),
                    TextFormField(
                      controller: fullnameCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: AppLg.of(context).trans('fullname')
                      ),
                    ),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: AppLg.of(context).trans('password')
                      ),
                    ),
                    TextFormField(
                      controller: confirmPwdCtrl,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: AppLg.of(context).trans('confirm_password')
                      ),
                    ),
                    SizedBox(height: 15),
                    state is RegisterFailState ? Text(state.message, style: TextStyle(color: Colors.red)) : Container(),
                    SizedBox(height: 30),
                    CupertinoButton(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(70)),
                      onPressed: () => _registerBtnPressed(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.white),
                          SizedBox(width: 10),
                          Text(AppLg.of(context).trans('register'), style: TextStyle(color: Colors.white))
                        ]
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(AppLg.of(context).trans('already_have_account')),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(AppLg.of(context).trans('login'), style: TextStyle(color: Colors.blue)),
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
    );
  }
}