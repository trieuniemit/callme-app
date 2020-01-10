import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}


class AppStarted extends AppEvent {}


class LoggedIn extends AppEvent {
  final String token;
  final User user;

  const LoggedIn({this.token, this.user});

  @override
  List<Object> get props => [token, user];

  @override
  String toString() => 'LoggedIn { token: $token }';
}


class LoggedOut extends AppEvent {}