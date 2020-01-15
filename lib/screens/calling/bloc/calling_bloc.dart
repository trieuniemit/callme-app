import 'dart:async';
import 'package:app.callme/models/socket_message.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:app.callme/services/socket_connection.dart';
import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import './bloc.dart';

class CallingBloc extends Bloc<CallingEvent, CallingState> {
  
  final MainBloc mainBloc;
  final User user;
  final bool isRequest;
  StreamSubscription<SocketMessage> streamSubscription;

  SocketConnection get socketConn => mainBloc.socketConnection;

  static CallingBloc of(context) {
    return Provider.of<CallingBloc>(context, listen: false);
  }

  @override
  CallingState get initialState => InitialCallingState();

  CallingBloc({this.isRequest = false, this.mainBloc, this.user}) {
    streamSubscription = socketConn.stream.listen(_socketListener);
    
    if (!isRequest) {
      socketConn.emit('call_start', {'target': user.socketId});
    }
  }

  @override
  Future<void> close() async {
    super.close();
    streamSubscription.cancel();
  }

  @override
  Stream<CallingState> mapEventToState(CallingEvent event) async* {
    if (event is CallNotAvailable) {
      await Future.delayed(Duration(seconds: 2));
      yield CallNotAvailableState();
    } else if (event is CallTargetBusy) {
      await Future.delayed(Duration(seconds: 2));
      yield CallTargetBusyState();
    } else if (event is CallEnded) {
      if (event.emitToTarget) {
        socketConn.emit('call_end', {'target': user.socketId});
      }
      yield CallEndedState();
    }
  }

  void _socketListener(SocketMessage message) {
    switch(message.action) {
      case 'call_not_available': 
        this.add(CallNotAvailable());
      break;
      case 'call_busy':
        this.add(CallTargetBusy());
      break;
      case 'call_end':
        this.add(CallEnded(false));
      break;
    }
  }

}
