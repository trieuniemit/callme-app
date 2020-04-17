import 'package:equatable/equatable.dart';

abstract class CallEvent extends Equatable {
  @override
  List<Object> get props => [];

  const CallEvent();
}

class CallEnded extends CallEvent {}

class CallAccepted extends CallEvent {}


class CallBusy extends CallEvent {}

class CallNotAvailable extends CallEvent {}