import 'package:app.callme/language.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/services/webrtc/video_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'bloc/bloc.dart';

class CallReceiveScreen extends StatelessWidget {

  final Map<String, dynamic> offerRecieved;
  final User callingUser;

  CallReceiveScreen({this.offerRecieved, this.callingUser});

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocProvider<CallReceiveBloc>(
        create: (context) => CallReceiveBloc(callingUser: callingUser),
        child:  Scaffold(
          body: BlocListener<CallReceiveBloc, CallReceiveState>(
            listener: (context, state) {
              if (state is CallReceiveEndedState) {
                Navigator.of(context).pop();
              }
            },
            child: BlocBuilder<CallReceiveBloc, CallReceiveState>(
              condition: (oldState, newState) {
                return !(newState is CallReceiveEndedState);
              },
              builder: (context, state) {
                List<Widget> buttons = <Widget>[
                  CupertinoButton(
                    onPressed: () {
                      CallReceiveBloc.of(context).add(CallReceiveEnded());
                    },
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end),
                    )
                  ),
                  CupertinoButton(
                    onPressed: () {
                      CallReceiveBloc.of(context).add(CallReceiveAccepted());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      maxRadius: 25,
                      child: Icon(Icons.call),
                    )
                  )
                ];

                if(state is CallReceiveAcceptedState) {
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
                    state is CallReceiveAcceptedState ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black,
                      child: WebRTCVideoView(CallReceiveBloc.of(context).mainRenderer),
                    ) : Container(),
                    Container(
                    color: Colors.black.withOpacity(0.4),
                    child: !(state is CallReceiveAcceptedState) ? Center(
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
                              Text(AppLg.of(context).trans('calling'), style: TextStyle(fontSize: 18, color: Colors.white70))
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
                                child: new WebRTCVideoView(CallReceiveBloc.of(context).secondRenderer),
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