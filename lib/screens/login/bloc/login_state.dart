import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {}


class InvalidFormState extends LoginState {}

class ValidFormState extends LoginState {}

class LoginScreenFailState extends LoginState {
  final String message;

  LoginScreenFailState(this.message);

  @override
  List<Object> get props => [message];
}