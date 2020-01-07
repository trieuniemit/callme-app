import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class InitialLoginState extends LoginState {
  @override
  List<Object> get props => [];
}


class LoginFaildState extends LoginState {
  final String message;

  LoginFaildState(this.message);

  @override
  List<Object> get props => [message];
}


// class LoginSuccess extends LoginState {
//   final User user;
//   final String token;

//   LoginSuccess(this.user, this.token);
  
// }