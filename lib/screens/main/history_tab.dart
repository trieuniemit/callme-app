import 'package:app.callme/components/easy_listview.dart';
import 'package:app.callme/language.dart';
import 'package:app.callme/models/call_history.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState> (
      builder: (context, state) {
        
        if(state.historyLoading) {
          return Center(
            child:  CupertinoActivityIndicator(
              radius: 20
            ),
          );
        } else if (state.history.length == 0) {
          return Center(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.history, color: Colors.blue, size: 50),
                SizedBox(height: 5),
                Text(AppLg.of(context).trans('empty_history'), style: TextStyle(fontSize: 16))
              ],
            ),
          );
        }

        return EasyListView(
          itemCount: state.history.length,
          itemBuilder: (context, index) {
            CallHistory item = state.history[index];

            Duration duration = Duration(seconds: item.length);
            print(item.toMap());

            String durationStr = duration.inHours.toString().padLeft(2, '0') + ":" + duration.inMinutes.toString().padLeft(2, '0') + 
                ":" + duration.inSeconds.toString().padLeft(2, '0');

            return CupertinoButton(
              onPressed: () {},
              padding: EdgeInsets.all(0),
              child: ListTile(
                dense: false,
                leading: CircleAvatar(
                  maxRadius: 26,
                  child: Text(item.user.fullname[0], style: TextStyle(fontSize: 20)),
                ),
                title: Text(item.user.fullname),
                subtitle: Row(
                  children: <Widget>[
                    item.type == CallType.call ? Icon(Icons.call_made, size: 14) : Icon(Icons.call_received, size: 14, color: Colors.green),
                    SizedBox(width: 5),
                    Text(DateFormat('hh:mm - dd/mm/yyyy').format(item.dateTime), style: TextStyle(fontSize: 13))
                  ],
                ),
                trailing: Text(durationStr),
              )
            );
          },
        );
      }
    );
  }

}