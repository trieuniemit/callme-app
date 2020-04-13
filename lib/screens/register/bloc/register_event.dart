part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String phoneNumber;
  final String password;
  final String fullname;
  final String confirmPassword;
  
  RegisterButtonPressed({this.phoneNumber, this.password, this.confirmPassword, this.fullname});
  
  @override
  List<Object> get props => [phoneNumber, password, confirmPassword, fullname];
  
  
  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'fullname': fullname,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
