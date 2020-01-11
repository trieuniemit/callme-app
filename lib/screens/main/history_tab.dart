import 'package:app.callme/components/easy_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyListView(
      itemCount: 100,
      itemBuilder: (context, item) {
        String name = 'Fullname';
        return CupertinoButton(
          onPressed: () {},
          padding: EdgeInsets.all(0),
          child: ListTile(
            dense: false,
            leading: CircleAvatar(
              maxRadius: 26,
              child: Text(name[0], style: TextStyle(fontSize: 20)),
            ),
            title: Text(name),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.call, size: 14),
                SizedBox(width: 5),
                Text('00:05:59')
              ],
            ),
            trailing: Text('15:01', style: TextStyle(fontSize: 13)),
          )
        );
      },
    );
  }

}