import 'dart:async';
import 'dart:convert';
import 'package:app.callme/config/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:web_socket_channel/io.dart';

typedef ListenFuntion = Function(Map message);

class SocketConnection {

  IOWebSocketChannel _channel;

  int _reconnectCount = 5;

  StreamController _socketStreamController = new StreamController.broadcast();
  Stream get stream => _socketStreamController.stream;
  
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

    var data = {
      "action": "register",
      "data": {
        "token": token
      }
    };

    _channel.sink.add(json.encode(data));
    print('WS - Conected! -----------------------------');

    _channel.stream.listen(
      (dynamic message) {
        print('WS: received data------------------------');
        _socketStreamController.add(json.decode(message));
        //channel.sink.close();
        //print('WS: ${message.toString()} \n-------------------------------'); 
      },
      onDone: () async {
        print('WS - was closed--------------------');
        var connectivityResult = await (Connectivity().checkConnectivity());
        
        if (connectivityResult == ConnectivityResult.mobile || 
          connectivityResult == ConnectivityResult.wifi) {
          print('WS - trying to reconnect after 5s-------');
          
          _reconnectCount --;
          if(_reconnectCount <= 0) {
            _reconnectCount = 5;
            return;
          }

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
      "type": data
    };
    _channel.sink.add(json.encode(sinkData));
    print(sinkData.toString());
  }

  void close() {
    _channel.sink.close();
  }

}