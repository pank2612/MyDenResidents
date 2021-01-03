

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:residents/MainScreen/MainScreen.dart';
import 'package:residents/ResidentSignIn/SplashScreen.dart';
import 'package:residents/VisitorsScreen/GetExpectedVisitors.dart';
import 'Constant/globalsVariable.dart' as globals;
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Bloc/ConnectivityBloc.dart';
import 'package:residents/Bloc/MainBloc.dart';
import 'package:residents/ResidentSignIn/signIn.dart';

import 'Constant/tokenGenerate.dart';

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
print("appsatarted");
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
 // final NavigationService _navigationService = locator<NavigationService>();


  @override
  void initState() {
  final GlobalKey<NavigatorState> navigationkey = GlobalKey(debugLabel: "GetExpectedVisitors");
    globals.connectivityBloc = ConnectivityBloc();
    globals.connectivityBloc.onInitial();
    super.initState();
    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //   });
    //
    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     messagehandle(message, navigationkey, context);
    //
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     messagehandle(message, navigationkey, context);
    //    // Navigator.push(context, MaterialPageRoute(builder: (context)=>GetExpectedVisitors()));
    //
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //
    //     messagehandle(message, navigationkey, context);
    //    // Navigator.push(context, MaterialPageRoute(builder: (context)=>GetExpectedVisitors()));
    //
    //   },
    // );
  }
  void messagehandle(msg,navigationkey,context){
    print(msg["data"]);
    print("aaddd");
    // switch (msg['data']['screen']){
    //   case "screen":
    //     Navigator.push(context, MaterialPageRoute(builder:
    //         (context)=>GetExpectedVisitors()));
    //     break;
    // }
  }

  showdialog(Map<String, dynamic> msg){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Visitor Name",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Expanded(child: Text(msg['data']['name'],textAlign: TextAlign.right,))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Invite On",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(msg['data']["name"]),
                ],
              ),

            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Accept'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text('Reject'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
  // void _serialiseAndNavigate(Map<String, dynamic> message) {
  //   var notificationData = message['data'];
  //   var view = notificationData['view'];
  //
  //   if (view != null) {
  //     // Navigate to the create post view
  //     if (view == 'create_post') {
  //       _navigationService.navigateTo(CreatePostViewRoute);
  //     }
  //   }
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
