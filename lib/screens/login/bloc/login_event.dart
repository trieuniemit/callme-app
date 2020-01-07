import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {}

class LoginSuccess extends LoginEvent {}

class LoginFaild extends LoginEvent {}