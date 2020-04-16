import 'dart:async';
import 'package:app.callme/bloc/app_bloc.dart';
import 'package:app.callme/bloc/app_event.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/repositories/auth_repository.dart';
import 'package:app.callme/validators/login_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  AuthRepository _authRepository = AuthRepository();
  AppBloc _appBloc;

  LoginBloc(this._appBloc);

  @override
  LoginState get initialState => InitialLoginState();

  static LoginBloc of(context) {
    return Provider.of<LoginBloc>(context, listen: false);
  }

  @override
  Stream<LoginState> mapEventToState( LoginEvent event) async* {

      if (event is LoginButtonPressed) {
        
        if (! LoginValidator.username(event.username) || !LoginValidator.password(event.password)) { 
          yield InvalidFormState();
        } else {
          yield * _loginStart(event);
        }

      } else if (event is LoginFailed) {
        
        yield LoginFailState(event.message);

      } else if (event is LoginButtonPressed) {
        
      }

  }

  Stream<LoginState> _loginStart(LoginButtonPressed event) async* {

    yield LoginProcessState();

    Map<String, dynamic> res = await _authRepository.authenticate(
      password: event.password,
      username: event.username
    );

    if (res.containsKey('status') && res['status']) {

      User user =  User.fromMap(res['user']);
      String token = res['token'];
      await _appBloc.appRepository.saveToken(user, res['token']);

      _appBloc.add(Authenticated(user: user, token: token));
      yield LoginSuccessState();

    } else {
      yield LoginFailState(res['message']);
    }
  }

}
