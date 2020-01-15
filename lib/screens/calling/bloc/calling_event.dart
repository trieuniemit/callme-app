import 'package:equatable/equatable.dart';

abstract class CallingEvent extends Equatable {
  @override
  List<Object> get props => [];
  const CallingEvent();
}

class CallNotAvailable extends CallingEvent {}

class CallTargetBusy extends CallingEvent {}

class CallEnded extends CallingEvent {
  final bool emitToTarget;

  CallEnded(this.emitToTarget);
  @override
  List<Object> get props => [emitToTarget];
}