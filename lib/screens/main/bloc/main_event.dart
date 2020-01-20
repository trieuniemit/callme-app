import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class GetContact extends MainEvent {}

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