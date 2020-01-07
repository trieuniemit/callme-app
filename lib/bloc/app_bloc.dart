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
    return Provider.of<AppBloc>(context);
  }

  @override
  AppState get initialState => InitAppState();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await appRepository.hasToken();

      if (hasToken) {
        yield AuthenticatedState();
      } else {
        yield UnauthenticatedState();
      }
      
    } else if (event is LoggedIn) {
      yield LoadingState();
      await appRepository.persistToken(event.token);
      yield AuthenticatedState();

    } else if (event is LoggedOut) {
      yield LoadingState();
      await appRepository.deleteToken();
      yield UnauthenticatedState();
    }
  }
}
