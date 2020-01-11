import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/repositories/app_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  
  final AppRepository appRepository = AppRepository();

  AppBloc() {
    assert(appRepository != null);
  }

  static AppBloc of(context) {
    return Provider.of<AppBloc>(context, listen: false);
  }

  @override
  AppState get initialState => InitAppState();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppStarted) {

      yield *_appStarted(appRepository, event);
      
    } else if(event is LoginStart) {

      yield *_loginStart(appRepository, event);

    } else if (event is LogOut) {

      yield *_loggedOut(appRepository, event);

    }
  }
}


Stream<AppState> _appStarted(appRepository, AppStarted event) async* {

  Map<String, dynamic> localAuth = await appRepository.checkAuth();

  if (localAuth['status']) {
    yield AuthenticatedState(
      token: localAuth['token'],
      user: localAuth['user']
    );
  } else {
    yield UnauthenticatedState();
  }

}


Stream<AppState> _loginStart(appRepository, LoginStart event) async* {

  yield LoadingState();

  Map<String, dynamic> res = await appRepository.authenticate(
    password: event.password,
    username: event.username
  );

  if (res.containsKey('status') && res['status']) {

    User user =  User.fromMap(res['user']);

    await appRepository.saveToken(user, res['token']);

    yield AuthenticatedState(
      token: res['token'],
      user: user
    );

  } else {
    yield LoginFailState(res['message']);
  }
}


Stream<AppState> _loggedOut(appRepository, LogOut event) async* {

  await appRepository.deleteToken();
  yield UnauthenticatedState();

}

