import 'package:equatable/equatable.dart';

abstract class CallingState extends Equatable {
  @override
  List<Object> get props => [];
  const CallingState();
}

class InitialCallingState extends CallingState {}

class CallNotAvailableState extends CallingState {}

class CallTargetBusyState extends CallingState {}

class CallEndedState extends CallingState {}

class CallAcceptedState extends CallingState {}

class CallBusyState extends CallingState {}