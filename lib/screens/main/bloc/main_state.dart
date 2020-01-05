import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  final String language = 'en';

  @override
  List<Object> get props => [language];

  const MainState();
}

class InitialMainState extends MainState {
  @override
  List<Object> get props => [];
}

class SwitchLanguageState extends MainState {
  final String language;

  SwitchLanguageState(this.language);

  @override
  List<Object> get props => [language];
}

