import 'package:app.callme/models/call_history.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class GetData extends MainEvent {
  final bool refresh;

  GetData({this.refresh = true});

  @override
  List<Object> get props => [refresh];
}

class CallReceived extends MainEvent {
  final User user;
  final Map<String, dynamic> offerRecieved;

  CallReceived(this.user, {this.offerRecieved});
  @override
  List<Object> get props => [user, offerRecieved];
}

class CallToUser extends MainEvent {
  final User user;

  CallToUser(this.user);
  @override
  List<Object> get props => [user];
}

class UpdateContact extends MainEvent {
  final User user;

  UpdateContact(this.user);
  @override
  List<Object> get props => [user];
}

class AddHistory extends MainEvent {
  final CallHistory history;

  AddHistory(this.history);
  @override
  List<Object> get props => [history];
}