

import 'dart:async';
import 'dart:io';



import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:residents/ActivityScreen/MainActivityScreen.dart';
import 'package:residents/AlertScreen/AlertMainScreen.dart';

import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/EventsScreen/EventsMainScreen.dart';
import 'package:residents/LocalService/LocalServiceScreen.dart';
import 'package:residents/LocalService/ServiceDetails.dart';
import 'package:residents/MainScreen/MainScreen.dart';
import 'package:residents/NoticeScreen/NoticesScreen.dart';
import 'package:residents/Settings/Settings.dart';
import 'package:residents/VisitorsScreen/GetExpectedVisitors.dart';
import 'package:residents/VisitorsScreen/VisitorsMainScreen.dart';

import '../notification.dart';


//SharedPreferences prefs;
class TabBarScreen extends StatefulWidget {
  final society;

  const TabBarScreen({Key key, this.society}) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<TabBarScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  PageController pageController;
  final pages = [MainScreen(),Activity(),MainScreen(),PreapproveNotification(),notification()];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription iosSubscription;





  @override
  void initState() {


    super.initState();
    pageController = PageController();
   // final GlobalKey<NavigatorState> navigationkey = GlobalKey(debugLabel: "_showDialog");
    if (Platform.isIOS) {
      iosSubscription = _firebaseMessaging.onIosSettingsRegistered.listen((data) {
      });

      _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
    }
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // messagehandle(message, navigationkey, context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {Navigator.of(context).pop();
                }
              ),
            ],
          ),
        );

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        messagehandle(message,  context,);


      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        messagehandle(message, context,);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>GetExpectedVisitors()));

      },
    );
  }

  void messagehandle(msg,context,){
    print(msg["data"]);
    print("aaddd");

    switch (msg['data']['screen']){
      case "_showDialog":
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=> Visitors()));
        break;
      case "FullDetails":
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=> LocalService()));
        break;
      case "Events":
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=> EventsScreen()));
        break;
      case "Notices":
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=> NoticesScreen()));
        break;
      case "AlertsScreen":
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=> newAlert()));
        break;
    }
  }
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }





  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: UniversalVariables.background,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 120.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, 0);
                      },
                      child: Row(

                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.cancel,
                              //  color: primaryColor,
                            ),
                            margin: EdgeInsets.only(right: 10.0),
                          ),
                          Text(
                            'No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),

                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, 1);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.check_circle,
                              //  color: primaryColor,
                            ),
                            margin: EdgeInsets.only(right: 10.0),
                          ),
                          Text(
                            'YES',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    return

      Scaffold(
        body: WillPopScope(
            onWillPop: onBackPress,
            child: pages[_page]),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.home, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("Home",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.watch_later, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("Activity",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add, size: 30,color: UniversalVariables.ScaffoldColor,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.settings, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("Setting",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Icon(Icons.cloud_done, size: 20,color: UniversalVariables.ScaffoldColor,),
                    Text("MyDen",style: TextStyle(color: UniversalVariables.ScaffoldColor,fontSize: 10),)
                  ]),
            ),

          ],
          color: UniversalVariables.background,
          buttonBackgroundColor: UniversalVariables.background,
          backgroundColor: UniversalVariables.ScaffoldColor,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {

              _page = index;

            });
          },
        ),

      );
  }
  _showDialog()  {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Your  ",
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}