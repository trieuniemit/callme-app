import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:callme/config/routes.dart';
import 'package:callme/config/colors.dart';
import 'package:callme/bloc_delegate.dart';
import 'package:callme/screens/main/bloc/bloc.dart';
import 'language.dart';
import 'screens/main/bloc/main_bloc.dart';

void main() {
  BlocSupervisor.delegate = AppBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
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
            theme: ThemeData(
              backgroundColor: AppColors.containerBg,
              primarySwatch: Colors.blue,
            ),
            initialRoute: AppRoutes.home,  //set default route
            onGenerateRoute: AppRoutes.appRoutes, // init list routes
          );
        },
      )
    );
  }
}
