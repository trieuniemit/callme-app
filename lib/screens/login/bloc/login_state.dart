import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/login/bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {}


class LoginSuccess extends LoginState {
  final User user;
  final String token;

  LoginSuccess({this.user, this.token});
  
  @override
  List<Object> get props => [token, user];
}


class LoginFailState extends LoginState {
  final String message;

  LoginFailState(this.message);
  
  @override
  List<Object> get props => [message];
}

class InvalidFormState extends LoginState {}