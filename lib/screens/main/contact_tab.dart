import 'package:app.callme/components/easy_listview.dart';
import 'package:app.callme/config/routes.dart';
import 'package:app.callme/models/user_model.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ContactTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state.loading) {
          return Center(
            child:  CupertinoActivityIndicator(
              radius: 20
            ),
          );
        }

        List<User> contact = state.contact;
        return EasyListView(
          itemCount: contact.length,
          itemBuilder: (context, index) {
            String name = contact[index].fullname;
            return CupertinoButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.calling,
                  arguments: {
                    'bloc': MainBloc.of(context),
                    'is_request': false,
                    'user': contact[index]
                  }
                );
              },
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
                    Icon(Icons.person, size: 14),
                    SizedBox(width: 5),
                    Text(contact[index].username)
                  ],
                ),
                trailing: Icon(Icons.call, color: Colors.blue),
              )
            );
          },
        );
      },
    );
  }

}