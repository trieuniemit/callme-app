import 'package:app.callme/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();

  @override
  List<Object> get props => [];
}

class InitialMainState extends MainState {}


class GetContactSuccessState extends MainState {
  final List<User> contact;

  GetContactSuccessState(this.contact);
  @override
  List<Object> get props => [contact];
}
