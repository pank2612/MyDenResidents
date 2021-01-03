import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;
import 'package:residents/Constant/sharedPref.dart';

import 'TabBarScreen.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;


class accessList extends StatefulWidget {
  @override
  _accessListState createState() => _accessListState();
}

class _accessListState extends State<accessList> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(children: [
            // Positioned(
            //   bottom: 60,
            //   left: -MediaQuery.of(context).size.width * .4,
            //   child: BezierContainerTwo(),
            // ),
            // Positioned(
            //   top: -MediaQuery.of(context).size.height * .15,
            //   right: -MediaQuery.of(context).size.width * .4,
            //   child: BezierContainer(),
            // ),
            Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: MediaQuery.of(context).size.width / 4,
                  bottom: MediaQuery.of(context).size.width / 4,
                ),
                child:
                BlocBuilder<AuthBloc, AuthBlocState>(builder: (context, state) {
                  return ListView.builder(
                      itemCount: state.userData.accessList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              globals.mainId = state.userData.accessList[index].id.toString();
                              globals.parentId = state.userData.accessList[index].residentId.toString();
                              savelocalCode().toSaveStringValue(residentHouseId,
                                  state.userData.accessList[index].residentId.toString());
                              savelocalCode().toSaveStringValue(residentId,
                                  state.userData.accessList[index].id.toString());
                              _tokenRegister(state.userData.uid,state.userData.accessList[index].id.toString(), state.userData.accessList[index].residentId.toString());
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TabBarScreen()));
                            },
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Container(
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(state.userData.accessList[index].id),
                                    )),
                              ],
                            )
                        );
                      });
                }



                )

            )
          ]),
        )

    );
  }

  _tokenRegister(String uid,String societyId,String parentId) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      Firestore.instance.collection(global.SOCIETY).document(societyId)
          .collection("HouseDevices").document(uid)
          .setData({
        "enable":true,
        "token": token,
        "houseId":global.parentId
      },merge: true);


    });
  }
}
