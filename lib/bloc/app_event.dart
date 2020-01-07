import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}


class AppStarted extends AppEvent {}


class LoggedIn extends AppEvent {
  final String token;

  const LoggedIn({this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => 'LoggedIn { token: $token }';
}


class LoggedOut extends AppEvent {}