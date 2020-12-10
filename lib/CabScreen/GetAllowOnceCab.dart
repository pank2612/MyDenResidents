import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/AllowOnceDelivery.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/pre_approve_delivery/addAllowOnce.dart';
class AllowOnceCab extends StatefulWidget {
  @override
  _AllowOnceCabState createState() => _AllowOnceCabState();
}

class _AllowOnceCabState extends State<AllowOnceCab> {
  List<AllowOnce> allowOnceList = List<AllowOnce>();
  DocumentSnapshot lastDocument = null;
  bool isLoading = false;
  @override
  void initState() {

   // _userData = context.bloc<AuthBloc>().getCurrentUser();
    getAllowOnce(lastDocument);
  //  getAllowFrequentlyCab(lastDocument);

    global.companycontroller.clear();
 //   selectedReportList = ["Select Day"];
  //  _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(children: [
        Column(children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: allowOnceList.length == 0
                ? Center(
              child: Text("No data"),
            )
                : ListView.builder(
              itemCount: allowOnceList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                  ),
                  child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  allowOnceList[index].time,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),

                                Text(
                                  DateFormat(global.dateFormat)
                                      .format(allowOnceList[index]
                                      .inviteDate),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12),
                                ),
                              ],),

                            Divider(),
                            Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                      color: UniversalVariables.background,
                                        borderRadius:
                                        BorderRadius.circular(70)),
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(70),
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(70),
                                                child: allowOnceList[index]
                                                    .companyName ==
                                                    "Uber"
                                                    ? Image.asset(
                                                    "images/uber.png",fit: BoxFit.cover,)
                                                    : Image.asset(
                                                    "images/ola.png",fit: BoxFit.fill,))))),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      allowOnceList[index].companyName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,fontSize: 30,fontStyle: FontStyle.italic),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      "VehicalNo: "+  allowOnceList[index].vehicalNo,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    allowOnceList[index].leavePackage == true ?
                                    Text("Leave Package at Gate"):Container(),
                                    Text("Coming in " +
                                        allowOnceList[index].hour),

                                  ],
                                ),

                              ],
                            )
                          ],
                        ),
                      )),
                );
              },
            ),
          ),
          isLoading
              ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(5),
            color: UniversalVariables.background,
            child: Text(
              'Loading......',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UniversalVariables.ScaffoldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Container()
        ]),
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: UniversalVariables.background,
          child: Icon(Icons.add),
          onPressed: () {
            navigateAllowPage();
          }),
    );
  }
  FutureOr onGoBack(dynamic value) {
    getAllowOnce(null);
  }
  void navigateAllowPage() {
    Route route = CupertinoPageRoute(builder: (context) => AddAllowOnce(
      name: "Cab",
    ));
    Navigator.push(context, route).then(onGoBack);
  }

  getAllowOnce(DocumentSnapshot _lastDocument) async {
    allowOnceList.clear();
    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      querySnapshot = await Firestore.instance
          .collection(global.SOCIETY)
          .document(global.mainId)
          .collection("Cab")
          .where("residentId", isEqualTo: global.parentId)
          .where("inviteDate",isGreaterThanOrEqualTo:  DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .where("enable", isEqualTo: true)
          .getDocuments();
      if (querySnapshot.documents.length != 0) {
        setState(() {
          querySnapshot.documents.forEach((element) {
            var allowOnce = AllowOnce();
            allowOnce = AllowOnce.fromJson(element.data);
            allowOnceList.add(allowOnce);
          });
        });
      }
    }
  }
}
