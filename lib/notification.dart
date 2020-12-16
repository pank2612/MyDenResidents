import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
class notification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<notification> {
  final String serverToken = '<Server-Token>';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  void getMessage(){
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          setState(() => _message = message["notification"]["title"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Message: $_message"),
                OutlineButton(
                  child: Text("Register My Device"),
                  onPressed: () {
                    sendAndRetrieveMessage();
                  },
                ),
                // Text("Message: $message")
              ]),
        ),
      ),
    );
  }
  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$ddd',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': ttt,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

}
 var ddd = "AAAA7benEuU:APA91bE4pXVdtbXFYWyutC-cCxY76Gt30jDyR0og8iX8f6Jkbo0GLdc95kNusJrXjxPsVOvYsmaY4q7FbP2CH7lqWZtcUKJzUL5rA1oekx1WCo6IEoym4RcSELEt3y0LkiFciAQyvn3y";

var ttt = "e9taYVRMRyasunSsOT9ulI:APA91bGnx0v8DoGRkAy-ZVCa_3yCj4-ztMzupGiTFMdD0o6YsPML9GvJUwR-FH_OTFn_wxEX2iINs5BsFKbXmxNFIsXbApL8NBPlvHIvyiRp9-ujIVKM1a7piJVrYUlD0CVejQRZuVgN";