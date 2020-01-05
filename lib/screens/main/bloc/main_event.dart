import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class SwitchLanguage extends MainEvent {
  final String languageCode;

  SwitchLanguage(this.languageCode);

  @override
  List<Object> get props => [languageCode];

}