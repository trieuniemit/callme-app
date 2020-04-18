import 'package:equatable/equatable.dart';

abstract class CallState extends Equatable {
  @override
  List<Object> get props => [];
  
  const CallState();
}

class CallInitial extends CallState {}

class CallEndedState extends CallState {}

class CallAcceptedState extends CallState {}

class CallNotAvailableState extends CallState {}

class CallBusyState extends CallState {}