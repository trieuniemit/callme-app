import 'package:app.callme/language.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/services/webrtc/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'bloc/bloc.dart';

class CallScreen extends StatelessWidget {

  final Map<String, dynamic> offerRecieved;
  final User callingUser;

  CallScreen({this.offerRecieved, this.callingUser});

  void _onCallNotAvailableOrBusy(context, String alertKey) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(AppLg.of(context).trans(alertKey)),
          title: Text(AppLg.of(context).trans('error')),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocProvider<CallBloc>(
        create: (context) => CallBloc(callingUser: callingUser),
        child:  Scaffold(
          body: BlocListener<CallBloc, CallState>(
            listener: (context, state) {
              if (state is CallEndedState) {
                Navigator.of(context).pop();
              } else if (state is CallNotAvailableState) {
                _onCallNotAvailableOrBusy(context, 'call_not_available');
              } else if (state is CallBusyState) {
                _onCallNotAvailableOrBusy(context, 'call_target_busy');
              }
            },
            child: BlocBuilder<CallBloc, CallState>(
              condition: (oldState, newState) {
                return !(newState is CallEndedState);
              },
              builder: (context, state) {
                List<Widget> buttons = <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      CallBloc.of(context).add(CallEnded());
                    },
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end),
                    )
                  ),
                ];

                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/calling_bg.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      child: WebRTCVideoView(CallBloc.of(context).mainRenderer),
                    ),
                    Container(
                    color: Colors.black.withOpacity(0.4),
                    child: !(state is CallAcceptedState) ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                child: Text(callingUser.fullname[0], style: TextStyle(color: Colors.white, fontSize: 40)),
                                maxRadius: 50,
                              ),
                              SizedBox(height: 10),
                              Text(callingUser.fullname, style: TextStyle(fontSize: 23, color: Colors.white)),
                              SizedBox(height: 16),
                              Text(AppLg.of(context).trans('ringing'), style: TextStyle(fontSize: 18, color: Colors.white70))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: buttons,
                          )
                        ],
                        )
                      ) : Container(
                        padding: EdgeInsets.only(bottom: 40, top: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.only(right: 20, top: 20),
                              child: Container(
                                margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                width: 100,
                                height: 130,
                                child: new WebRTCVideoView(CallBloc.of(context).secondRenderer),
                                decoration: new BoxDecoration(color: Colors.black54),
                              )
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: buttons,
                            )
                          ]
                        )
                      ),
                    )
                  ]
                );
              }
            )
          )
        )
      )
    );
  }
}