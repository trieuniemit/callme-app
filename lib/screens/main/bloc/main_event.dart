import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class GetContact extends MainEvent {}

class CallTo extends MainEvent {
  final String socketId;

  CallTo(this.socketId);
  @override
  List<Object> get props => [socketId];
}

class CallNotAvailable extends MainEvent {}