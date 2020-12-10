

import 'package:flutter/material.dart';
import 'package:residents/MainScreen/MainScreen.dart';
import 'package:residents/ResidentSignIn/SplashScreen.dart';
import 'Constant/globalsVariable.dart' as globals;
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Bloc/ConnectivityBloc.dart';
import 'package:residents/Bloc/MainBloc.dart';
import 'package:residents/ResidentSignIn/signIn.dart';

//test

// testing111
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print('bloc: ${bloc.runtimeType}, event: $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print('cubit: ${cubit.runtimeType}, change: $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('bloc: ${bloc.runtimeType}, transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print('cubit: ${cubit.runtimeType}, error: $error');
    super.onError(cubit, error, stackTrace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //BlocSupervisor().delegate = SimpleBlocDelegate();
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(

      MultiBlocProvider(
          providers: MainBloc.allBlocs(),
          child:
          new MyApp()
      )
  ));
}


class MyApp extends StatefulWidget {

  static setCustomeTheme(BuildContext context, int index) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme(index);
  }

  @override
  State<StatefulWidget> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    globals.connectivityBloc = ConnectivityBloc();
    globals.connectivityBloc.onInitial();

    super.initState();
  }

  void setCustomeTheme(int index) {
    setState(() {
      globals.colorsIndex = index;
      globals.primaryColorString = globals.colors[globals.colorsIndex];
      globals.secondaryColorString = globals.primaryColorString;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: globals.isLight ? Brightness.dark : Brightness.light,
    ));
    return Container(
     // color: AllCoustomTheme.getThemeData().primaryColor,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: globals.appName,
         // theme: AllCoustomTheme.getThemeData(),
          // routes: routes,
          home: SplashScreen()
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }

}
