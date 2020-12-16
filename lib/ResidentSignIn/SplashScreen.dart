import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';

import 'package:residents/Constant/sharedPref.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/ResidentSignIn/signIn.dart';

import 'TabBarScreen.dart';
import 'accessListScreen.dart';
import 'emailVerification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  Future<UserData> _getUserData() async {
    print("getUserData -----------------");
    return await context.bloc<AuthBloc>().currentUser();
  }


  @override
  void initState() {
    _getUserData().then((fUser) {
      if(fUser!=null) {
        print("fuser length");
      //  print(fUser.accessList.length);
        if(!fUser.emailVerified){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EmailVerification()));
        }
        else if( fUser.accessList != null && fUser.accessList.length == 1 ) {
          global.mainId = fUser.accessList[0].id.toString();
          global.parentId = fUser.accessList[0].residentId.toString();
          global.flatNo = fUser.accessList[0].flatNo.toString();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TabBarScreen()));
        }
        else if ( fUser.accessList != null && fUser.accessList.length > 1){
          //shared Pref
          savelocalCode().toGetDate(residentId).then((value){
            print(value);
            if(value!=null)
            {
              global.mainId = value;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => accessList()));
            }
            else
            {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => accessList()));
            }

          });
        }
        else {
         global.mainId = fUser.accessList[0].id.toString();
         global.parentId = fUser.accessList[0].residentId.toString();
         global.flatNo = fUser.accessList[0].flatNo.toString();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => TabBarScreen()));
        }
      }
      else {
        print('Login Page');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            CircularProgressIndicator(),
                            Text(
                              "MY Den",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: UniversalVariables.background,
                                  fontWeight: FontWeight.w800),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }





}

