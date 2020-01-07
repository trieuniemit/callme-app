import 'package:equatable/equatable.dart';


abstract class AppState extends Equatable {
    final String language = 'en';

  @override
  List<Object> get props => [language];
}

class InitAppState extends AppState {}

class AuthenticatedState extends AppState {}

class UnauthenticatedState extends AppState {}

class LoadingState extends AppState {}

class SwitchLanguageState extends AppState {

  final String langue;
  SwitchLanguageState(this.langue);

  @override
  List<Object> get props => [language];

}