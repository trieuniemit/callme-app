import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  List<Object> get props => [];
}

class ValidateForm extends LoginEvent {
  @override
  List<Object> get props => [];
}

class LoggedIn extends LoginEvent {
  final String token;

  const LoggedIn({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}

class LoginSuccess extends LoginEvent {}


class LoginFaild extends LoginEvent {}