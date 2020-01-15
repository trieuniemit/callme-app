import 'package:equatable/equatable.dart';

abstract class CallingEvent extends Equatable {
  @override
  List<Object> get props => [];
  const CallingEvent();
}

class CallRequest extends CallingEvent {
  
}

class CallNotAvailable extends CallingEvent {}

class CallTargetBusy extends CallingEvent {}