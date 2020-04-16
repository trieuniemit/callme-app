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
      
    } else if (event is LogOut) {

      yield *_loggedOut(appRepository, event);

    } else if(event is Authenticated) {

      yield AuthenticatedState(
        token: event.token,
        user: event.user
      );
      
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


Stream<AppState> _loggedOut(appRepository, LogOut event) async* {

  await appRepository.deleteToken();
  yield UnauthenticatedState();

}

