import 'dart:async';
import 'package:angel_validate/angel_validate.dart';
import 'package:app.callme/bloc/app_bloc.dart';
import 'package:app.callme/bloc/app_event.dart';
import 'package:app.callme/bloc/app_state.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  
  AuthRepository _authRepository = AuthRepository();
  AppBloc _appBloc;
  
  RegisterBloc(this._appBloc);

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
      var validate = Validator({
        'phoneNumber': isNonEmptyString,
        'password': isNonEmptyString,
        'confirmPassword': isNonEmptyString,
        'fullname': isNonEmptyString
      }, customErrorMessages: {
        'phoneNumber': 'register_validate.phoneNumber',
        'confirmPassword': 'register_validate.confirm_password',
        'fullname': 'register_validate.fullname',
        'password': 'register_validate.password',
      }).check(event.toMap());

      if(validate.errors.isNotEmpty) {
        yield ValidateFailState(validate.errors.first);
        return;
      }
      
      yield RegisterProcessState();
      
      Map<String, dynamic> res = await _authRepository.register(
        fullname: event.fullname, 
        phoneNumber: event.phoneNumber, 
        password: event.password
      );

      if (res.containsKey('status') && res['status']) {
        User user =  User.fromMap(res['user']);
        String token = res['token'];
        
        await _appBloc.appRepository.saveToken(user, token);
        
        //save token
        _appBloc.add(Authenticated(user: user, token: token));
        
        yield RegisterSuccessState();
      } else {
        yield RegisterFailState(res['message']);
      }
    }
  }
}
