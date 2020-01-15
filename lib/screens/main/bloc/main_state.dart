import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState();
  @override
  List<Object> get props => [];
}

class InitialMainState extends MainState {

}


class GetDataSuccessState extends MainState {
  final List<User> contact;
  final bool hasCall;
  final List<User> histories;

  GetDataSuccessState({this.contact, this.histories, this.hasCall = false});
  @override
  List<Object> get props => [this.histories, this.contact, hasCall];

  GetDataSuccessState copyWith({ 
    List<User> contact, 
    bool hasCall,
    List<User> histories}
  ) {
    return GetDataSuccessState(
      contact: contact == null ? this.contact : contact,
      histories: histories == null ? this.histories : histories,
      hasCall: hasCall == null ? this.hasCall : hasCall,
    );
  }

  GetDataSuccessState callRequest() {
    return this.copyWith(
      hasCall: true
    );
  }

}
