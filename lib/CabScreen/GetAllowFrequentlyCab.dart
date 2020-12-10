import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/AllowFrequently.dart';
import 'package:residents/pre_approve_delivery/addFrequently.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
class GetFrequentlyCab extends StatefulWidget {
  @override
  _GetFrequentlyCabState createState() => _GetFrequentlyCabState();
}

class _GetFrequentlyCabState extends State<GetFrequentlyCab> {
  List<AllowFrequentlyModel> allowFrequentlyList = List<AllowFrequentlyModel>();
  DocumentSnapshot lastDocument = null;
  bool isLoading = false;
  @override
  void initState() {
    getAllowFrequentlyCab(lastDocument);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Stack(children: [

        Column(children: [
          SizedBox(
            height: 10,
          ),

          Expanded(
            child: allowFrequentlyList.length == 0
                ? Center(
              child: Text("No data"),
            )
                : ListView.builder(

              itemCount: allowFrequentlyList.length,
              itemBuilder: (context, index) {
                return Padding(

                    padding: const EdgeInsets.only(left: 12, right: 12,),
                    child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                Column(
                                 // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: UniversalVariables.background,
                                            borderRadius: BorderRadius.circular(70)),
                                        height: 70,
                                        width: 70,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(70),
                                            child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(70),
                                                    child: allowFrequentlyList[index]
                                                        .vehicalName ==
                                                        "Uber"
                                                        ? Image.asset(
                                                        "images/uber.png",fit: BoxFit.cover,)
                                                        : Image.asset(
                                                        "images/ola.png",fit: BoxFit.fill,))

                                            )

                                        )),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Timing: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(height: 5,),
                                   Column(
                                     children: [
                                       Text(
                                         allowFrequentlyList[index].startTime ,
                                         style: TextStyle(
                                             fontWeight: FontWeight.w800),
                                       ),
                                       Text(
                                         " to ",
                                         style: TextStyle(
                                             fontWeight: FontWeight.w800),
                                       ),
                                       Text(
                                         allowFrequentlyList[index].endTime,
                                         style: TextStyle(
                                             fontWeight: FontWeight.w800),
                                       ),
                                     ],
                                   )


                                  ],
                                ),
                                    SizedBox(
                                      width: 20,
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allowFrequentlyList[index].vehicalName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,fontSize: 30,fontStyle: FontStyle.italic),
                                        ),
                                        SizedBox(height: 8,),
                                       Container(
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(15),
                                           color: Colors.grey,
                                         ),

                                         width: MediaQuery.of(context).size.width/1.9,
                                         child:  Padding(padding: EdgeInsets.all(5),
                                         child: Text(
                                           allowFrequentlyList[index].days,
                                           style: TextStyle(
                                               fontWeight: FontWeight.w800),
                                         ),
                                         )
                                       ),
                                        SizedBox(height: 8,),
                                        Text(
                                          "VehicalNo: "+  allowFrequentlyList[index].vehicalNo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          allowFrequentlyList[index].validity,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,fontSize: 18,fontStyle: FontStyle.italic),
                                        ),
                                        // allowFrequentlyList[index].leavePackage == true ?
                                        // Text("Leave Package at Gate"):Container(),
                                        // SizedBox(height: 5,),
                                        // Text("Coming in " +
                                        //     allowFrequentlyList[index].hour),
                                        // SizedBox(height: 5,),
                                        // Text(allowFrequentlyList[index].startTime,
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.w800),),
                                        // Text(allowFrequentlyList[index].endTime


                                      //  )
                                      ],
                                    )
                                  ],
                                ),

                              ]  ),
                        )));
              },
            ),
          ),
          isLoading
              ? Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
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
        onPressed: () {
          navigateFreqwentlyPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }
  FutureOr onGoBack(dynamic value) {
    getAllowFrequentlyCab(null);
  }
  void navigateFreqwentlyPage() {
    Route route = CupertinoPageRoute(builder: (context) => AddFrequentlyAll(
      name: "AllowFrequentlyCab",
    ));
    Navigator.push(context, route).then(onGoBack);
  }

  getAllowFrequentlyCab( DocumentSnapshot _lastDocument) async {
    QuerySnapshot querySnapshot;
    if(_lastDocument == null){
      allowFrequentlyList.clear();
      querySnapshot = await
      Firestore.instance.collection(global.SOCIETY).document(global.mainId)
          .collection("AllowFrequentlyCab")
          .where("userId", isEqualTo: global.parentId)
          .where("enable", isEqualTo: true)
          .getDocuments();
      if (querySnapshot.documents.length != 0) {
        setState(() {
          querySnapshot.documents.forEach((element) {
            var allowFrequently = AllowFrequentlyModel();
            allowFrequently = AllowFrequentlyModel.fromJson(element.data);
            allowFrequentlyList.add(allowFrequently);
          });
        });
      }}
  }
}
