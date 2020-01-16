import 'package:equatable/equatable.dart';

abstract class CallingEvent extends Equatable {
  @override
  List<Object> get props => [];
  const CallingEvent();
}

class CallNotAvailable extends CallingEvent {}

class CallTargetBusy extends CallingEvent {}

class CallAccepted extends CallingEvent {
  final bool emit;
  CallAccepted(this.emit);
  @override
  List<Object> get props => [emit];
}

class CallEnded extends CallingEvent {
  final bool emit;

  CallEnded(this.emit);
  @override
  List<Object> get props => [emit];
}