import 'dart:async';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/repositories/contact_repository.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  final String token;
  final SocketConnection socketConnection = SocketConnection.getInstance();
  final ContactRepository _contactRepository = ContactRepository();
  
  @override
  MainState get initialState => InitialMainState();


  MainBloc(this.token) {
    socketConnection.connect(token);
    socketConnection.stream.listen(_socketListener);
    this.add(GetContact());
  }

  @override
  Future<void> close() async {
    super.close();
    socketConnection.close();
  }

  void _socketListener(data) {
    print("Data $data");
  }

  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is GetContact) {
       Map<String, dynamic> res = await _contactRepository.getContact(token);
      if(res.containsKey('status') && res['status']) {
        List<User> users = List();
        for (var u in res['users']) {
          users.add(User.fromMap(u));
        }

        yield GetContactSuccessState(users);
      }
    }
  }
}
