import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:callme/language.dart';
import 'package:callme/screens/main/bloc/bloc.dart';
import 'package:callme/screens/main/bloc/main_bloc.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLg.of(context).trans('app_name')),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              MainBloc.of(context).add(SwitchLanguage('vi'));
            },
            child: Icon(Icons.language),
          ),
          body: Container(),
        );
      }
    );
  }

}