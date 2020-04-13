import 'dart:async';
import 'package:app.callme/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthRepository _authRepository = AuthRepository();

  @override
  RegisterState get initialState => RegisterInitial();
  
  static RegisterBloc of(context) {
    return BlocProvider.of<RegisterBloc>(context);
  }


  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if(event is RegisterButtonPressed) {
      Map<String, dynamic> res = await _authRepository.register(fullname: event.fullname, phoneNumber: event.phoneNumber, password: event.password);
    }
  }
}
