import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/AllowFrequently.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/pre_approve_delivery/addFrequently.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:flutter_bloc/flutter_bloc.dart';

class AllowFrequentily extends StatefulWidget {
  @override
  _AllowFrequentilState createState() => _AllowFrequentilState();
}

class _AllowFrequentilState extends State<AllowFrequentily> {
  bool isLoading = false;
  List<AllowFrequentlyModel> allowFrequentlyList = List<AllowFrequentlyModel>();
  DocumentSnapshot lastDocument = null;


  @override
  void initState() {

    getAllowOnce(lastDocument);

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
                              children: [
                                Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                           // color: UniversalVariables.background,
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
                                                        .logo ==
                                                        null
                                                        ? Image.network(
                                                        "https://icon-library.com/images/person-image-icon/person-image-icon-6.jpg")
                                                        : Image.network(
                                                      allowFrequentlyList[index]
                                                          .logo,
                                                      fit: BoxFit.cover,
                                                    )
                                                )

                                            )

                                        )),
                                    SizedBox(height: 5,),
                                    Text(
                                      "Timing: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(height: 2,),
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
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allowFrequentlyList[index].companyName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,fontStyle: FontStyle.italic,fontSize: 30,),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        allowFrequentlyList[index].validity,style: TextStyle(fontWeight: FontWeight.w800,fontStyle: FontStyle.italic,fontSize: 20),),
                                    SizedBox(
                                      height: 5,
                                    ),

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
         navigateSecondPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }


  getAllowOnce( DocumentSnapshot _lastDocument) async {
    QuerySnapshot querySnapshot;
    if(_lastDocument == null){
      allowFrequentlyList.clear();
    querySnapshot = await
    Firestore.instance.collection(global.SOCIETY).document(global.mainId)
        .collection("AllowFrequentlyDelivery")
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
  FutureOr onGoBack(dynamic value) {

    print("On call back");
    print(" kjhkjsdhfgkjsgh $value");
    getAllowOnce(null);
    setState(() {

    });
  }

  void navigateSecondPage() {
    Route route = CupertinoPageRoute(builder: (context) => AddFrequentlyAll(
      name: "AllowFrequentlyDelivery",
    ));
    Navigator.push(context, route).then(onGoBack);
  }

}
