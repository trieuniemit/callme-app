import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {

  final String username;
  final String password;

  LoginButtonPressed(this.username, this.password);

  @override
  List<Object> get props => [username, password];
}

class LoginFaild extends LoginEvent {
  final String message;

  LoginFaild(this.message);

  @override
  List<Object> get props => [message];
}

class InvalidForm extends LoginEvent {
  final String message;

  InvalidForm(this.message);

  @override
  List<Object> get props => [message];
}