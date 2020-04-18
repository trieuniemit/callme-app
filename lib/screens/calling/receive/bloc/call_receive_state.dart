import 'package:equatable/equatable.dart';

abstract class CallReceiveState extends Equatable {
  @override
  List<Object> get props => [];
  
  const CallReceiveState();
}

class CallReceiveInitial extends CallReceiveState {}

class CallReceiveEndedState extends CallReceiveState {}

class CallReceiveAcceptedState extends CallReceiveState {}