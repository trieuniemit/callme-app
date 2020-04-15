import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}


class AppStarted extends AppEvent {}


class Authenticated extends AppEvent {
  final User user;
  final String token;

  Authenticated({this.user, this.token});
  
  @override
  List<Object> get props => [token, user];
}

class LogOut extends AppEvent {}

