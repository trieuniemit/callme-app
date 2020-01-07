import 'package:app.callme/bloc/app_bloc.dart';
import 'package:app.callme/bloc/app_event.dart';
import 'package:app.callme/bloc/app_state.dart';
import 'package:app.callme/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBloc.of(context).add(AppStarted());

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AuthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false);
        } else if (state is UnauthenticatedState) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/images/flutter-logo.png',
            width: 200,
          ),
        ),
      )
    );
  }
}