import 'dart:async';
import 'dart:convert';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/repositories/contact_repository.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class MainBloc extends Bloc<MainEvent, MainState> {

  final String token;
  final SocketConnection socketConnection = SocketConnection.getInstance();
  final ContactRepository _contactRepository = ContactRepository();
  
  @override
  MainState get initialState => InitialMainState();

  static MainBloc of(context) {
    return Provider.of<MainBloc>(context, listen: false);
  }

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

  @override
  Stream<MainState> mapEventToState( MainEvent event ) async* {
    if (event is GetContact) {
      yield* _getContact();
    } else if (event is CallTo) {
      yield* _callTo(event);
    } else if (event is CallNotAvailable) {
      await Future.delayed(Duration(seconds: 2));
      yield CallNotAvailableState();
    }
  }

  void _socketListener(data) {
    print("Data $data");
    Map<String, dynamic> dataMap = Map<String, dynamic>.from(data);

    switch(dataMap['action']) {
      case 'call_not_available': 
        this.add(CallNotAvailable());
      break;
    }
  }

  Stream<MainState> _getContact() async* {
    Map<String, dynamic> res = await _contactRepository.getContact(token);
    if(res.containsKey('status') && res['status']) {
      List<User> users = List();
      for (var u in res['users']) {
        users.add(User.fromMap(u));
      }

      yield GetContactSuccessState(users);
    }
  }

  Stream<MainState> _callTo(CallTo event) async * {
    socketConnection.emit('call_start', {'target': event.socketId});
 }


}
