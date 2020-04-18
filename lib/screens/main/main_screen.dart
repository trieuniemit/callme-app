import 'package:app.callme/bloc/bloc.dart';
import 'package:app.callme/components/no_scroll_behavior.dart';
import 'package:app.callme/components/rounded_container.dart';
import 'package:app.callme/config/routes.dart';
import 'package:app.callme/language.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'contact_tab.dart';
import 'history_tab.dart';

class MainScreen extends StatelessWidget {

  void _onCallReceive(context, user, offerRecieved) {
    print("Call received.");
    Navigator.of(context).pushNamed(AppRoutes.callReceive,
      arguments: {'user': user}
    );
  }

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    return DefaultTabController(
      length: 2,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, appState) {
          return BlocProvider<MainBloc>(
            create: (context) => MainBloc(appState is AuthenticatedState ? appState.token : ''),
            child:  BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return BlocListener<MainBloc, MainState>(
                  listener: (context, state) {
                    if ( state.callingUser != null) {
                      _onCallReceive(context, state.callingUser, state.offerRecieved);
                    }
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text('Call Me'),
                      elevation: 0.0,
                      actions: _buildActions(context, appState),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.add, color: Colors.white),
                    ),
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
                              child: TabBarView(
                                children: <Widget>[
                                  HistoryTab(),
                                  ContactTab()
                                ],
                              )
                            )
                          )
                        ],
                      ),
                    )
                  )
                );
            }
            )  
          );
        },
      )
    );
  }


  List<Widget> _buildActions(context, state) {
    String nickname = state is AuthenticatedState ? state.user.fullname : '<Nickname>';

    return <Widget>[
      Container(
        alignment: Alignment.centerRight,
        child: Row(
          children: [
            Text(nickname, style: TextStyle(fontSize: 18)),
            SizedBox(width: 10),
            CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images/empty-avatar.jpg'),
            ),
            PopupMenuButton<MenuItemChoice>(
              onSelected: (MenuItemChoice menuItemChoice) {
                switch (menuItemChoice.key) {
                  case 'refresh':
                    MainBloc.of(context).add(GetContact());
                  break;
                  case 'logout':
                    AppBloc.of(context).add(LogOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
                  break;
                }
              },
              itemBuilder: (BuildContext context) {
                return <MenuItemChoice>[
                  MenuItemChoice(
                    title: AppLg.of(context).trans('refresh'), 
                    key: 'refresh', 
                    icon: Icon(Icons.refresh, color: Colors.black)
                  ),
                  MenuItemChoice(
                    title: AppLg.of(context).trans('logout'), 
                    key: 'logout', 
                    icon: Icon(Icons.power_settings_new, color: Colors.black)
                  )
                ].map((MenuItemChoice menuItemChoice) {
                  return PopupMenuItem<MenuItemChoice>(
                    value: menuItemChoice,
                    child: Row(
                      children: <Widget>[
                        menuItemChoice.icon,
                        SizedBox(width: 15),
                        Text(menuItemChoice.title),
                      ]
                    ),
                  );
                }).toList();
              },
            )
          ],
        )
      ),
    ];
  }
}


//app bar menu
class MenuItemChoice {
  const MenuItemChoice({this.icon,this.title, this.key});
  final String key;
  final String title;
  final Icon icon;
}