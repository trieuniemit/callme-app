import 'dart:async';
import 'package:app.callme/validators/login_validator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {



  @override
  LoginState get initialState => InitialLoginState();

  static LoginBloc of(context) {
    return Provider.of<LoginBloc>(context, listen: false);
  }

  @override
  Stream<LoginState> mapEventToState( LoginEvent event) async* {

      if (event is LoginButtonPressed) {
        
        if (! LoginValidator.username(event.username) 
          || !LoginValidator.password(event.password)) {
            yield InvalidFormState();
        } else {
          yield ValidFormState();
        }

      } else if (event is LoginFailed) {
        yield LoginScreenFailState(event.message);
      }

  }

}
