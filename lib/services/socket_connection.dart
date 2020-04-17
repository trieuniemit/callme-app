import 'dart:async';
import 'dart:convert';
import 'package:app.callme/config/constants.dart';
import 'package:app.callme/models/socket_message.dart';
import 'package:connectivity/connectivity.dart';
import 'package:web_socket_channel/io.dart';

typedef ListenFuntion = Function(Map message);

class SocketConnection {

  IOWebSocketChannel _channel;

  int _reconnectCount = 5;

  StreamController<SocketMessage> _socketStreamController = StreamController.broadcast();
  Stream<SocketMessage> get stream => _socketStreamController.stream;
  
  //create singleton
  static final SocketConnection _singleton = new SocketConnection._internal();
  SocketConnection._internal();
  static SocketConnection getInstance() => _singleton;

  void connect(String token) {
    _channel = IOWebSocketChannel.connect(Constants.SOCKET_URL);
    register(token);
  }

  void register(String token) async {
    print('WS - Conecting... ----------------------------');

    if(token == null || token.isEmpty) return;

    this.emit('register', {
      "token": token
    });
    
    print('WS - Conected! -----------------------------');

    _channel.stream.listen(
      (dynamic message) {
        _socketStreamController.add(SocketMessage(message));
      },
      onDone: () async {
        print('WS - was closed--------------------');
        var connectivityResult = await (Connectivity().checkConnectivity());
        
        if (connectivityResult == ConnectivityResult.mobile || 
          connectivityResult == ConnectivityResult.wifi) {
          print('WS - trying to reconnect after 5s-------');
          
          // _reconnectCount --;
          // if(_reconnectCount <= 0) {
          //   _reconnectCount = 5;
          //   return;
          // }

          Future.delayed(Duration(seconds: 5), () {
            SocketConnection.getInstance().connect(token);
          });
           
        } else {
          print('WS - no internet to reconnect-------');
        }
      },
      onError: (error) {
        print('WS - error $error-------');
      }
    );

  }

  void emit(String action, Map data) {
    Map sinkData = {
      "action": action,
      "data": data
    };
    print('===WebSocket: Emit: $action');
    _channel.sink.add(json.encode(sinkData));
  }

  void close() {
    _channel.sink.close();
  }

}