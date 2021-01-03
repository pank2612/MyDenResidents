import 'dart:async';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class notification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<notification> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  StreamSubscription iosSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     print(message["notification"]);
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: SingleChildScrollView(
    //           child: ListBody(
    //             children: [
    //               ListTile(
    //                 title: Text(message['notification']['title']),
    //                 subtitle: Text(message['notification']['body']),
    //               ),
    //               Row(children: [
    //                 Text(" Visitors name"),
    //                 Text(message['notification']['title'])
    //               ],)
    //             ],
    //           ),
    //         ),
    //
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Accept'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //           FlatButton(
    //             child: Text('Reject'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    //
    // );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                child: Text("Click"),
                onPressed: () {

                  sendNotification(key, "Your Visitor is on gate");
                },
              ),
              // Text("Message: $message")
            ]),
      ),
    );
  }



  static Future<void> sendNotification(receiver, msg) async {
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "notification": {
        "body": "Accept Ride Request",
        "title": "This is Ride Request",
       // "data": {}
      },
      "to": "$token"
    };

    final headers = {'content-type': 'application/json', 'Authorization': key};
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request Sent To Driver');
      } else {
        print('notification sending failed');

      }
    } catch (e) {
      print('exception $e');
    }
  }

// static Future<String> getToken(userId)async{
//
//   final Firestore _db = Firestore.instance;
//
//   var token;
//   await _db.collection('users')
//       .document(userId)
//       .collection('tokens').getDocuments().then((snapshot){
//     snapshot.documents.forEach((doc){
//       token = doc.documentID;
//     });
//   });
//
//   return token;
//
//
// }

}

var key =
    "key=AAAA7benEuU:APA91bE4pXVdtbXFYWyutC-cCxY76Gt30jDyR0og8iX8f6Jkbo0GLdc95kNusJrXjxPsVOvYsmaY4q7FbP2CH7lqWZtcUKJzUL5rA1oekx1WCo6IEoym4RcSELEt3y0LkiFciAQyvn3y";

var token =
    "ecdp0cPTTHmUL8sMAbAJ3y:APA91bG14spmr6PkNQVKbXqeJT1O1FTW5izehkwU6HUxyyrOUQHhoixHD-Ng8aOHlVd9HQ1A7gXU_3jnVh3ESTzVAusD7b1Ys_C_ApMhxe0OSM47aDjlldfg-5DIh-vijpxrAg7q6Tbv";
