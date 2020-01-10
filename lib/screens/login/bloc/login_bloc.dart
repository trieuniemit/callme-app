import 'dart:async';
import 'package:app.callme/bloc/bloc.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/repositories/auth_repository.dart';
import 'package:app.callme/validators/login_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final BuildContext context;
  
  final AuthRepository authRepository = AuthRepository();

  LoginBloc(this.context);

  @override
  LoginState get initialState => InitialLoginState();

  static LoginBloc of(context) {
    return Provider.of<LoginBloc>(context, listen: false);
  }

  @override
  Stream<LoginState> mapEventToState( LoginEvent event) async* {

      if (event is LoginButtonPressed) {
        
        if (! LoginValidator.username(event.username) 
          || !LoginValidator.password(event.password)) {
            yield InvalidFormState();
        } else {
          Map<String, dynamic> res = await authRepository.authenticate(
            password: event.password,
            username: event.username
          );

          if (res.containsKey('status') && res['status']) {
            
            yield  LoginSuccess();

            AppBloc.of(context).add(LoggedIn(
              token: res['token'],
              user: User.fromMap(res['user'])
            ));

          } else {
            yield LoginFailState(res['message']);
          }
        }

      }

  }

}
