import 'dart:async';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class CallingBloc extends Bloc<CallingEvent, CallingState> {
  
  final MainBloc mainBloc;
  final User target;

  SocketConnection get socketConn => mainBloc.socketConnection;

  @override
  CallingState get initialState => InitialCallingState();

  CallingBloc({this.mainBloc, this.target}) {
    socketConn.stream.listen(_socketListener);
    socketConn.emit('call_start', {'target': target.socketId});
  }
 

  @override
  Stream<CallingState> mapEventToState(CallingEvent event) async* {
    if (event is CallNotAvailable) {
      await Future.delayed(Duration(seconds: 2));
      yield CallNotAvailableState();
    }
  }


  void _socketListener(data) {
    Map<String, dynamic> dataMap = Map<String, dynamic>.from(data);

    switch(dataMap['action']) {
      case 'call_not_available': 
        this.add(CallNotAvailable());
      break;
    }
  }

}
