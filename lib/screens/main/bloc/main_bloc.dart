import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => InitialMainState();

  static MainBloc of(context) {
    return BlocProvider.of<MainBloc>(context);
  }

  @override
  Stream<MainState> mapEventToState( MainEvent event ) async* {
    if(event is SwitchLanguage) {
      yield SwitchLanguageState(event.languageCode);
    }
  }
}
