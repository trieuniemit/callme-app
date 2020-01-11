import 'dart:async';
import 'package:app.callme/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading {
  BuildContext context;
  static Loading of(BuildContext context) {
    return Loading(context);
  }

  Loading(this.context);

  void show({String text, Color bgColor = Colors.white, Color textColor = Colors.blue}) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            Completer<bool> completer = Completer();
            completer.complete(false);
            return completer.future;
          },
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10.0)
                ),
                width: 200.0,
                height: 150.0,
                alignment: AlignmentDirectional.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: CupertinoActivityIndicator(
                          radius: 26
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25.0),
                      child: Center(
                        child: Text(
                          text == null ? AppLg.of(context).trans('loading') : text,
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          )
        );
      }
    );
  }

  void hide() {
    Navigator.of(context).pop(false);
  }
}