import 'package:app.callme/components/no_scroll_behavior.dart';
import 'package:app.callme/components/rounded_container.dart';
import 'package:app.callme/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Call Me'),
          elevation: 0.0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: RoundedContainer(
          child: Column(
            children: <Widget>[
              TabBar(
                tabs: <Widget>[
                  Tab(child: Text(AppLg.of(context).trans('history'))),
                  Tab(child: Text(AppLg.of(context).trans('contact')))
                ],
              ),
              Container(
                color: Colors.grey,
                height: 0.5,
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: NoScrollBehavior(),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: TabBarView(
                      children: <Widget>[
                        Text('Call Me'),
                        Text('Call Me')
                      ],
                    )
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }
}