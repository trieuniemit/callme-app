import 'package:equatable/equatable.dart';

abstract class CallingEvent extends Equatable {
  @override
  List<Object> get props => [];
  const CallingEvent();
}

class CallNotAvailable extends CallingEvent {}

class CallTargetBusy extends CallingEvent {}

class CallBusy extends CallingEvent {}

class CallAccepted extends CallingEvent {}

class CallEnded extends CallingEvent {}

class UserCallAccepted extends CallingEvent {}

class UserCallEnded extends CallingEvent {}