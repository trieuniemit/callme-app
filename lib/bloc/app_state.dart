import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';


abstract class AppState extends Equatable {
    final String language = 'en';

  @override
  List<Object> get props => [language];
}

class InitAppState extends AppState {}


class AuthenticatedState extends AppState {
  final User user;
  final String token;

  AuthenticatedState({this.user, this.token});
  
  @override
  List<Object> get props => [token, user];

  @override 
  String toString() {
    return "AuthenticatedState {user: ${user.toMap()}, token: $token}";
  }
}

class UnauthenticatedState extends AppState {}

class LoadingState extends AppState {}

class SwitchLanguageState extends AppState {

  final String langue;
  SwitchLanguageState(this.langue);

  @override
  List<Object> get props => [language];

}