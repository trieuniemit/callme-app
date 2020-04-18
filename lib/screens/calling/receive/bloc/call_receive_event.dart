import 'package:equatable/equatable.dart';

abstract class CallReceiveEvent extends Equatable {
  @override
  List<Object> get props => [];

  const CallReceiveEvent();
}

class CallReceiveEnded extends CallReceiveEvent {}

class CallReceiveAccepted extends CallReceiveEvent {}