import 'dart:async';
import 'package:app.callme/models/socket_message.dart';
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
  MainState get initialState => MainState.init();

  static MainBloc of(context) {
    return Provider.of<MainBloc>(context, listen: false);
  }

  MainBloc(this.token) {
    socketConnection.connect(token);
    socketConnection.stream.listen(_mapSocketActions);
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
    } else if(event is CallReceived) {
      yield state.callRecieved(event.user, offerRecieved: event.offerRecieved);
    } else if (event is UpdateContact) {
      yield state.updateContact(event.user);
    } else if (event is CallToUser) {
      state.callToUser(event.user);
    }
  }

  void _mapSocketActions(SocketMessage message) {
    if(message.action != 'call_candidate') {
      print('WebSocket: action - ${message.action}');
    }
    switch(message.action) {
      case 'call_received':
        User from = User.fromMap(message.data["user"]);
        Map<String,dynamic> offerRecieved = message.data;
        offerRecieved.remove('from');
        this.add(CallReceived(from, offerRecieved: offerRecieved));
      break;
      case 'user_online':
        User user = User.fromMap(message.data["user"]);
        this.add(UpdateContact(user));
      break;
    }
  }

  Stream<MainState> _getContact() async* {
    yield MainState.init();
    
    Map<String, dynamic> res = await _contactRepository.getContact(token);
    if(res.containsKey('status') && res['status']) {
      List<User> users = List();
      for (var u in res['users']) {
        users.add(User.fromMap(u));
      }
      yield state.contactLoaded(users);
    }
  }

}
