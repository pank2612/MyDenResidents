import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/CabScreen/GetAllowFrequentlyCab.dart';
import 'package:residents/CabScreen/GetAllowOnceCab.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/Constant/globalsVariable.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/ModelClass/AllowFrequently.dart';
import 'package:residents/ModelClass/AllowOnceDelivery.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/VisitorsScreen/try.dart';
import 'package:residents/pre_approve_delivery/addAllowOnce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/pre_approve_delivery/addFrequently.dart';

import 'AddAllowOnce.dart';



class CabTabBar extends StatefulWidget {
  @override
  _AllowOnceDeliveryState createState() => _AllowOnceDeliveryState();
}

class _AllowOnceDeliveryState extends State<CabTabBar>
    with SingleTickerProviderStateMixin {
  //List<AllowOnce> allowOnceList = List<AllowOnce>();
 // List<AllowFrequentlyModel> allowFrequentlyList = List<AllowFrequentlyModel>();
 // DocumentSnapshot lastDocument = null;
 // UserData _userData = UserData();

  TabController _tabController;
  bool isLoading = false;
  bool leavePackageAtGate = false;

  @override
  void initState() {

  //  _userData = context.bloc<AuthBloc>().getCurrentUser();
  //  getAllowOnce(lastDocument);
 //   getAllowFrequentlyCab(lastDocument);

    global.companycontroller.clear();
    selectedReportList = ["Select Day"];
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text("Pre Approve Cab"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: [
              Tab(
                child: Text(
                  "Allow Once",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  "Allow Frequently",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
        ),
        body: TabBarView(
          children: [
            AllowOnceCab(),
            GetFrequentlyCab()
          ],
          controller: _tabController,
        ));
  }


  // Widget allowFrequentlyCab (){
  //   return Scaffold(
  //     body:
  //     Stack(children: [
  //
  //       Column(children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //
  //         Expanded(
  //           child: allowFrequentlyList.length == 0
  //               ? Center(
  //             child: Text("No data"),
  //           )
  //               : ListView.builder(
  //
  //             itemCount: allowFrequentlyList.length,
  //             itemBuilder: (context, index) {
  //               return Padding(
  //
  //                   padding: const EdgeInsets.only(left: 12, right: 12,),
  //                   child: Card(
  //                       child: Padding(
  //                         padding: EdgeInsets.all(15),
  //                         child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text(
  //                                     allowFrequentlyList[index].startTime,
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.w800, fontSize: 20),
  //                                   ),
  //                                   RaisedButton(
  //                                       shape:
  //                                       RoundedRectangleBorder(
  //                                           borderRadius:
  //                                           BorderRadius
  //                                               .circular(
  //                                               20)),
  //
  //                                       child: Padding(
  //                                         padding:
  //                                         EdgeInsets.all(5),
  //                                         child: Text(
  //                                           "Order By " + _userData.name,
  //                                           // visitorsList[index]
  //                                           //     .ownerName,
  //                                           style: TextStyle(
  //                                               color: UniversalVariables
  //                                                   .ScaffoldColor,
  //                                               fontWeight:
  //                                               FontWeight.w800,
  //                                               fontSize: 15),
  //                                         ),
  //                                       ))
  //                                 ],
  //                               ),
  //                               Divider(),
  //                               Row(
  //                                 children: [
  //                                   Container(
  //                                       decoration:
  //                                       BoxDecoration(
  //                                           borderRadius: BorderRadius.circular(70)),
  //                                       height: 70,
  //                                       width: 70,
  //                                       child: ClipRRect(
  //                                           borderRadius: BorderRadius.circular(70),
  //                                           child: Padding(
  //                                               padding: EdgeInsets.all(5),
  //                                               child: ClipRRect(
  //                                                   borderRadius:
  //                                                   BorderRadius.circular(70),
  //                                                   child: allowOnceList[index]
  //                                                       .companyName ==
  //                                                       "Uber"
  //                                                       ? Image.asset(
  //                                                       "images/uber.png")
  //                                                       : Image.asset(
  //                                                       "images/ola.png"))
  //
  //                                           )
  //
  //                                       )),
  //                                   SizedBox(
  //                                     width: 10,
  //                                   ),
  //                                   Column(
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: [
  //                                       Text(
  //                                         allowOnceList[index].id,
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.w800),
  //                                       ),
  //                                       SizedBox(height: 5,),
  //                                       Text(
  //                                         "VehicalNo: "+  allowOnceList[index].vehicalNo,
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.w800),
  //                                       ),
  //                                       SizedBox(height: 5,),
  //                                       allowOnceList[index].leavePackage == true ?
  //                                       Text("Leave Package at Gate"):Container(),
  //                                       SizedBox(height: 5,),
  //                                       Text("Coming in " +
  //                                           allowOnceList[index].hour),
  //                                       SizedBox(height: 5,),
  //                                       Text(allowFrequentlyList[index].startTime,
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.w800),),
  //                                       Text(allowFrequentlyList[index].endTime
  //
  //
  //                                       )
  //                                     ],
  //                                   )
  //                                 ],
  //                               ),
  //
  //                             ]  ),
  //                       )));
  //             },
  //           ),
  //         ),
  //         isLoading
  //             ? Container(
  //           width: MediaQuery
  //               .of(context)
  //               .size
  //               .width,
  //           padding: EdgeInsets.all(5),
  //           color: UniversalVariables.background,
  //           child: Text(
  //             'Loading......',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               color: UniversalVariables.ScaffoldColor,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         )
  //             : Container()
  //       ]),
  //     ]),
  //     floatingActionButton: FloatingActionButton(
  //       backgroundColor: UniversalVariables.background,
  //       onPressed: () {
  //         navigateFreqwentlyPage();
  //       },
  //       child: Icon(Icons.add),
  //     ),
  //   );
  //
  // }
  //

  //
  // void navigateAllowPage() {
  //   Route route = CupertinoPageRoute(builder: (context) => AddAllowOnce(
  //     name: "Cab",
  //   ));
  //   Navigator.push(context, route).then(onGoBack);
  // }

  // void navigateFreqwentlyPage() {
  //   Route route = CupertinoPageRoute(builder: (context) => AddFrequently(
  //     name: "AllowFrequentlyCab",
  //   ));
  //   Navigator.push(context, route).then(onGoBack);
  // }




  // getAllowOnce(DocumentSnapshot _lastDocument) async {
  //   allowOnceList.clear();
  //   QuerySnapshot querySnapshot;
  //   if (_lastDocument == null) {
  //     querySnapshot = await Firestore.instance
  //         .collection(global.SOCIETY)
  //         .document(global.mainId)
  //         .collection("Cab")
  //         .where("residentId", isEqualTo: global.parentId)
  //         .where("inviteDate",isGreaterThanOrEqualTo:  DateTime.now().subtract(Duration(days: 1)).toIso8601String())
  //         .where("enable", isEqualTo: true)
  //         .getDocuments();
  //     if (querySnapshot.documents.length != 0) {
  //       setState(() {
  //         querySnapshot.documents.forEach((element) {
  //           var allowOnce = AllowOnce();
  //           allowOnce = AllowOnce.fromJson(element.data);
  //           allowOnceList.add(allowOnce);
  //         });
  //       });
  //     }
  //   }
  // }

  // getAllowFrequentlyCab( DocumentSnapshot _lastDocument) async {
  //   QuerySnapshot querySnapshot;
  //   if(_lastDocument == null){
  //     allowFrequentlyList.clear();
  //     querySnapshot = await
  //     Firestore.instance.collection(global.SOCIETY).document(global.mainId)
  //         .collection("AllowFrequentlyCab")
  //         .where("userId", isEqualTo: global.parentId)
  //         .where("enable", isEqualTo: true)
  //         .getDocuments();
  //     if (querySnapshot.documents.length != 0) {
  //       setState(() {
  //         querySnapshot.documents.forEach((element) {
  //           var allowFrequently = AllowFrequentlyModel();
  //           allowFrequently = AllowFrequentlyModel.fromJson(element.data);
  //           allowFrequentlyList.add(allowFrequently);
  //         });
  //       });
  //     }}
  // }





}
