

import 'dart:async';
import 'dart:io';
//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:residents/ResidentSignIn/SplashScreen.dart';
import 'package:residents/VisitorsScreen/GetExpectedVisitors.dart';
import 'Constant/globalsVariable.dart' as globals;
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Bloc/ConnectivityBloc.dart';
import 'package:residents/Bloc/MainBloc.dart';


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
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;


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
    //  color: AllCoustomTheme.getThemeData().primaryColor,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: globals.appName,
        //  theme: AllCoustomTheme.getThemeData(),
          // routes: routes,
          home: SplashScreen()
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }


//
// var routes = <String, WidgetBuilder>{
//   Routes.SPLASH: (BuildContext context) => new SplashScreen(),
//  Routes.LOGIN: (BuildContext context) => new LoginPage(),
//   Routes.HOME: (BuildContext context) => new HomeScreen(),
// };
}




// class SimpleBlocObserver extends BlocObserver {
//   @override
//   void onEvent(Bloc bloc, Object event) {
//     print('bloc: ${bloc.runtimeType}, event: $event');
//     super.onEvent(bloc, event);
//   }
//
//   @override
//   void onChange(Cubit cubit, Change change) {
//     print('cubit: ${cubit.runtimeType}, change: $change');
//     super.onChange(cubit, change);
//   }
//
//   @override
//   void onTransition(Bloc bloc, Transition transition) {
//     print('bloc: ${bloc.runtimeType}, transition: $transition');
//     super.onTransition(bloc, transition);
//   }
//
//   @override
//   void onError(Cubit cubit, Object error, StackTrace stackTrace) {
//     print('cubit: ${cubit.runtimeType}, error: $error');
//     super.onError(cubit, error, stackTrace);
//   }
// }
//
// void main() {
// print("appsatarted");
//   WidgetsFlutterBinding.ensureInitialized();
//   //BlocSupervisor().delegate = SimpleBlocDelegate();
//   Bloc.observer = SimpleBlocObserver();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(
//
//       MultiBlocProvider(
//           providers: MainBloc.allBlocs(),
//           child:
//           new MyApp()
//       )
//   ));
// }
//
//
// class MyApp extends StatefulWidget {
//
//   static setCustomeTheme(BuildContext context, int index) {
//     final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
//     state.setCustomeTheme(index);
//   }
//
//   @override
//   State<StatefulWidget> createState() => _MyAppState();
// }
//
//
// class _MyAppState extends State<MyApp> {
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//   StreamSubscription iosSubscription;
//  // final NavigationService _navigationService = locator<NavigationService>();
//
//
//   @override
//   void initState() {
//
//     globals.connectivityBloc = ConnectivityBloc();
//     globals.connectivityBloc.onInitial();
//     super.initState();
//
//   }
//
//   void setCustomeTheme(int index) {
//     setState(() {
//       globals.colorsIndex = index;
//       globals.primaryColorString = globals.colors[globals.colorsIndex];
//       globals.secondaryColorString = globals.primaryColorString;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//       statusBarBrightness: globals.isLight ? Brightness.dark : Brightness.light,
//     ));
//     return Container(
//      // color: AllCoustomTheme.getThemeData().primaryColor,
//       child: MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: globals.appName,
//          // theme: AllCoustomTheme.getThemeData(),
//           // routes: routes,
//           home: SplashScreen()
//       ),
//     );
//   }
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
// }



// void initializeApp() async{
//   AwesomeNotifications().initialize(
//       null, // this makes you use your default icon, if you haven't one
//       [
//         NotificationChannel(
//             channelKey: 'basic_channel',
//             channelName: 'Basic notifications',
//             channelDescription: 'Notification channel for basic tests',
//             defaultColor: Colors.blueAccent,
//             ledColor: Colors.white
//         )
//       ]
//   );
// }
//
// void main(){
//   WidgetsFlutterBinding.ensureInitialized();
//   initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       title: 'Awesome Notification',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.deepPurple,
//         // This makes the visual density adapt to the platform that you run
//         // the app on. For desktop platforms, the controls will be smaller and
//         // closer together (more dense) than on mobile platforms.
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//
//       // This will initialize the route system to use names defined inside "routes" file
//       initialRoute: PAGE_HOME,
//       routes: materialRoutes,
//
//     );
//   }
// }