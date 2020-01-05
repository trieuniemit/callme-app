import 'package:bloc/bloc.dart';
import 'package:app.callme/config/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app.callme/config/routes.dart';
import 'package:app.callme/bloc_delegate.dart';
import 'package:app.callme/screens/main/bloc/bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'language.dart';
import 'screens/main/bloc/main_bloc.dart';

void main() {
  BlocSupervisor.delegate = AppBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.blue);

    return BlocProvider<MainBloc>(
      create: (BuildContext context) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        condition: (currentState, commingState) {
          return commingState is SwitchLanguageState;
        },
        builder: (context, state) {
          return MaterialApp(
            title: 'CallMe',
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: AppLg.getLocales, 
            localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {  
              if (locale == null) {
                print("Language locale is null!!. Set support to first!");
                return supportedLocales.first;
              }

              for (Locale supportedLocale in supportedLocales) {  
                if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {  
                  return supportedLocale;  
                }
              }
              return supportedLocales.first;  
            },
            locale: Locale(state.language),
            theme: lightTheme,
            initialRoute: AppRoutes.login,  //set default route
            onGenerateRoute: AppRoutes.appRoutes, // init list routes
          );
        },
      )
    );
  }
}
