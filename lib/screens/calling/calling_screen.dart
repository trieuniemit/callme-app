import 'package:app.callme/language.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class CallingSceen extends StatelessWidget {

  final MainBloc mainBloc;
  final User user;
  const CallingSceen({this.mainBloc, this.user});

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    String fullname = user.fullname;
    mainBloc.add(CallTo(user.socketId));

    return BlocListener(
      bloc: mainBloc,
      listener: (context, state) {
        if (state is CallNotAvailableState) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(AppLg.of(context).trans('call_not_vvailable')),
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
      },
      child: BlocBuilder(
        bloc: mainBloc,
        builder: (context, state) {
          return  Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/calling_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: SafeArea(
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
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: () {},
                              child: CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.call_end),
                              )
                            ),
                            CupertinoButton(
                              onPressed: () {},
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                maxRadius: 25,
                                child: Icon(Icons.call),
                              )
                            )
                          ],
                        )
                      ],
                    )
                  )
                )
              )
            ),
          );
        }
      )
    );
  }

}