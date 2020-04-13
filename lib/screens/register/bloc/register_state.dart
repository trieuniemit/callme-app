part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  @override
  List<Object> get props => [];
  const RegisterState();
}

class RegisterInitial extends RegisterState { }

class RegisterSuccessState extends RegisterState { }

class RegisterProcessState extends RegisterState { }

class RegisterFailState extends RegisterState {
  
  final String message;
  RegisterFailState(this.message);
  
  @override
  List<Object> get props => [message];
}

class ValidateFailState extends RegisterState {
  
  final String message;
  ValidateFailState(this.message);
  
  @override
  List<Object> get props => [message];
}
