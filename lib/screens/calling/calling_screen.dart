import 'package:app.callme/language.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/calling/bloc/bloc.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class CallingSceen extends StatelessWidget {

  final MainBloc mainBloc;
  final User user;
  final bool isRequest;

  const CallingSceen({this.mainBloc, this.user, this.isRequest});

  void _onCallNotAvailable(context, String alertKey) {
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

  void _onCallEnded(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    String fullname = user.fullname;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocProvider<CallingBloc>(
        create: (context) => CallingBloc(mainBloc: mainBloc, user: user, isRequest: isRequest),
        child:  Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/calling_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: BlocListener<CallingBloc, CallingState>(
                listener: (context, state) {
                  if (state is CallNotAvailableState) {
                    _onCallNotAvailable(context, 'call_not_available');
                  } else if (state is CallTargetBusyState) {
                    _onCallNotAvailable(context, 'call_target_busy');
                  } else if (state is CallEndedState) {
                    _onCallEnded(context);
                  } else if (state is CallBusyState) {
                    Navigator.of(context).pop();
                  }
                },
                child: BlocBuilder<CallingBloc, CallingState>(
                  builder: (context, state) {
                    List<Widget> buttons = <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          if (isRequest && state is InitialCallingState) {
                            CallingBloc.of(context).add(CallBusy());
                          } else {
                            CallingBloc.of(context).add(CallEnded(true));
                          }
                        },
                        child: CircleAvatar(
                          maxRadius: 25,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.call_end),
                        )
                      ),
                      CupertinoButton(
                        onPressed: () {
                          CallingBloc.of(context).add(CallAccepted(true));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          maxRadius: 25,
                          child: Icon(Icons.call),
                        )
                      )
                    ];
                    if(!this.isRequest || state is CallAcceptedState) {
                      buttons.removeAt(1);
                    }
                    
                    return SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  child: Text(fullname[0], style: TextStyle(color: Colors.white, fontSize: 40)),
                                  maxRadius: 50,
                                ),
                                SizedBox(height: 10),
                                Text(fullname, style: TextStyle(fontSize: 23, color: Colors.white)),
                                SizedBox(height: 16),
                                StreamBuilder<String>(
                                  stream: CallingBloc.of(context).noticeStream,
                                  builder: (context, snap) {
                                    String outputStr = "";
                                    if (!snap.hasData) {
                                      String lgKey = !isRequest ? 'ringing' : 'calling';
                                      outputStr = AppLg.of(context).trans(lgKey);
                                    } else {
                                      outputStr = snap.data;
                                    }
                                    return Text(outputStr, style: TextStyle(fontSize: 18, color: Colors.white70));
                                  },

                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: buttons,
                            )
                          ],
                        )
                      )
                    );
                  }
                )
              )
            )
          )
        )
      )
    );
  }
}