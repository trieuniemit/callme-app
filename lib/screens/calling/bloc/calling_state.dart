import 'package:equatable/equatable.dart';

abstract class CallingState extends Equatable {
  @override
  List<Object> get props => [];
  const CallingState();
}

class InitialCallingState extends CallingState {}

class CallNotAvailableState extends CallingState {}
