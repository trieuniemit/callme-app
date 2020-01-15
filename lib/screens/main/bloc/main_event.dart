import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class GetContact extends MainEvent {}

class CallReceived extends MainEvent {
  final User user;

  CallReceived(this.user);
  @override
  List<Object> get props => [user];
}