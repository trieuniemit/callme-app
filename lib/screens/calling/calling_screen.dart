import 'package:app.callme/language.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/calling/bloc/bloc.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:app.callme/services/webrtc/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class CallingSceen extends StatelessWidget {

  final MainBloc mainBloc;
  final bool isRequest;
  final Map<String, dynamic> offerRecieved;
  bool _showInfo = true;

  CallingSceen({this.offerRecieved, this.mainBloc, this.isRequest});

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

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocProvider<CallingBloc>(
        create: (context) => CallingBloc(
          mainBloc: mainBloc, 
          isRequest: isRequest, 
          offerRecieved: offerRecieved
        ),
        child:  Scaffold(
          body: BlocListener<CallingBloc, CallingState>(
            listener: (context, state) {
              if (state is CallNotAvailableState) {
                _onCallNotAvailable(context, 'call_not_available');
              } else if (state is CallTargetBusyState) {
                _onCallNotAvailable(context, 'call_target_busy');
              } else if (state is CallEndedState) {
                _onCallEnded(context);
              } else if (state is CallBusyState) {
                Navigator.of(context).pop();
              } else if(state is CallAcceptedState) {
                _showInfo = false;
              }
            },
            child: BlocBuilder<CallingBloc, CallingState>(
              condition: (oldState, newState) {
                return !(newState is CallEndedState);
              },
              builder: (context, state) {
                User callingUser = CallingBloc.of(context).mainBloc.state.callingUser;
                
                List<Widget> buttons = <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      if (isRequest && state is InitialCallingState) {
                        CallingBloc.of(context).add(CallBusy());
                      } else {
                        CallingBloc.of(context).add(CallEnded());
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
                      CallingBloc.of(context).add(CallAccepted());
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
                    !isRequest || state is CallAcceptedState? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      child: WebRTCVideoView(CallingBloc.of(context).mainRenderer),
                    ) : Container(),
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
                      ): Container(
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
                                child: new WebRTCVideoView(CallingBloc.of(context).secondRenderer),
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