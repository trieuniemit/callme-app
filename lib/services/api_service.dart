import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:app.callme/config/constants.dart';

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);


class Model {
  static String cookies = '';
  Map<String, String> defaultHeaders = {"Content-Type": "application/json"};

  Future<Map> callApi({ String method = 'GET', String path = '', Map<String, dynamic> params, Map<String, String> apiHeaders}) async {
    
    String url = Constants.API_URL + path;
    Client client = new Client();
    if(apiHeaders == null) 
      apiHeaders = new Map<String, String>();
    //add default header

    apiHeaders.addAll(defaultHeaders);
    //add cookie
    apiHeaders.addAll({"cookie": cookies});

    method = method.toLowerCase();

    var uriResponse;
    debugPrint('${method.toUpperCase()} to: $url\n------------------------------------------------');
    debugPrint('body: '+params.toString());
    //print('user token: ${Store.userToken}');    

    try {
      
      switch(method) {
        //post method
        case 'post': 
          uriResponse = await client.post(url, 
            body: json.encode(params), 
            headers: apiHeaders
          ).timeout(Duration(seconds: 15));

        break;

        //get method
        case 'get': 
          uriResponse = await client.get(url,
            headers: apiHeaders,
          ).timeout(Duration(seconds: 15));

        break;

        //put method
        case 'put':
          uriResponse = await client.put(url, 
            body: json.encode(params), 
            headers: apiHeaders
          ).timeout(Duration(seconds: 15));
        break;

          //put method
        case 'delete':
          uriResponse = await client.delete(url, 
            headers: apiHeaders
          ).timeout(Duration(seconds: 15));
        break;
      }

    } catch(e) {
      client.close();
      //check has internet
      var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile || 
        connectivityResult == ConnectivityResult.wifi) {
          print('Error: Server!');
          return {"status": false, "key": "server_error", "message": "Server error!"};
      }
      
      print('Error: Network!');
      return {"status": false, "key": "network_error", "message": "Network error!"};
    }
    
    client.close();
    
    debugPrint('Response: ${utf8.decode(uriResponse.bodyBytes)} \n---------------------------------\n');
    print('${method.toUpperCase()} to API: Success!==========');
    return json.decode(utf8.decode(uriResponse.bodyBytes));
  }


  void uploadFile({String filePath,  Function(dynamic) onSuccess,Function(dynamic) onError, String fileName, bool removable = true}) async {    
      File file = File(filePath);

      var stream = new ByteStream(DelegatingStream.typed(file.openRead()));

      var length = await file.length();

      String urlUpload = "<Upload URL>";

      if(!removable) {
        urlUpload = urlUpload.replaceFirst('true', 'false');
      }
      print('Upload: Start upload to: $urlUpload');
    

      var uri = Uri.parse(urlUpload);

      List<String> mimeType = lookupMimeType(filePath).split('/');
      print('Mime Type: '+mimeType.toString());


      var request = new MultipartRequest("POST", uri);
      var multipartFile = new MultipartFile(
        'file', stream, length, 
        filename: fileName!=null?fileName:basename(file.path),
        contentType: MediaType(mimeType.first, mimeType.last)
      );
      
      request.files.add(multipartFile);      


      try {
        var response = await request.send();
        response.stream.transform(utf8.decoder).listen((data) {
          print('Upload response: ' + data.toString());
          onSuccess(data);
        });

        print('=====Upload sucess!');
        
      } catch(err) {
        print('=====Upload to server error: $err');
        onError(err);
      }
  }


   Future<String> downloadFile(String fileName, {String savePath,
     Function(int receivedBytes, int totalBytes) onDownloadProgress}) async {


    final httpClient = new HttpClient();
    String downloadUrl = "<Download URl>".replaceFirst('{FILENAME}', fileName);

    final request = await httpClient.getUrl(Uri.parse(downloadUrl));
    request.headers.add(HttpHeaders.contentTypeHeader, "application/octet-stream");

    var httpResponse = await request.close();

    int byteCount = 0;
    int totalBytes = httpResponse.contentLength;


    //open new file
    File file = new File(savePath);
    var raf = file.openSync(mode: FileMode.write);

    Completer completer = new Completer<String>();

    httpResponse.listen(
      (data) {
        byteCount += data.length;

        raf.writeFromSync(data);

        if (onDownloadProgress != null) {
          onDownloadProgress(byteCount, totalBytes);
        }
      },
      onDone: () {
        raf.closeSync();
        completer.complete(file.path);
      },
      onError: (e) {
        raf.closeSync();
        file.deleteSync();
        completer.completeError(e);
      },
      cancelOnError: true,
    );

    return completer.future;
  }
}