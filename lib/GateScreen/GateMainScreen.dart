import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/GateModel.dart';

class GatesScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<GatesScreen> {
  List<Gate> gateList = List<Gate>();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 7;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();
  DateTime getSelectedStartDate = DateTime.now();

  @override
  void initState() {
    getGetDetails(lastDocument);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      print("build widget call");
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        print("load data");
        getGetDetails(lastDocument);
      }
    });
    print("build widget  two call");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Society Gates',
          style: TextStyle(color: UniversalVariables.ScaffoldColor),
        ),
        backgroundColor: UniversalVariables.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(children: [
        Column(children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: gateList.length == 0
                ? Center(
                    child: Text("No data"),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: gateList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // _showFullDetailsDialog(noticeList[index]);
                          },
                          child: Stack(children: [


                            Column(children: [
                              SizedBox(
                                height: 5,
                              ),
                              Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                  height: 40,
                                                  width: 40,
                                                  child: gateList[index]
                                                              .gateOpen ==
                                                          "Close"
                                                      ? Image.asset(
                                                          "images/gateClose.png")
                                                      : Image.asset(
                                                          "images/gateOpen.png")),
                                              Text(
                                                gateList[index].gateOpen,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                gateList[index].gateNo,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                gateList[index].gateOperation,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 20,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                      // Row(children: [
                                      //   Text(
                                      //     "Gate No. ",
                                      //     style: TextStyle(
                                      //         fontSize: 15,
                                      //         color: UniversalVariables.background,fontWeight: FontWeight.w800
                                      //     ),),
                                      //   Text(
                                      //     gateList[index].gateNo,
                                      //     style: TextStyle(
                                      //         fontWeight: FontWeight.w800,
                                      //         fontSize: 15,
                                      //         color: UniversalVariables.background),
                                      //   ),
                                      // ]),
                                      // SizedBox(height: 10,),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      //   children: [
                                      //     Text(gateList[index].gateOperation,style: TextStyle(color:UniversalVariables.background,fontWeight: FontWeight.w800,fontSize: 20),),
                                      //     Text(gateList[index].gateOpen,style: TextStyle(color:UniversalVariables.background,fontWeight: FontWeight.w800,fontSize: 20),)
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ]),
                        ),
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
      floatingActionButton: _floatingButton(),
    );
  }

  getGetDetails(DocumentSnapshot _lastDocument) async {
    if (!hasMore) {
      print('No More Data');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      gateList.clear();
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Gate")
          .orderBy("gateNo", descending: true)
          .where("enable", isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Gate")
          .orderBy("gateNo", descending: true)
          .where("enable", isEqualTo: true)
          .startAfterDocument(_lastDocument)
          .limit(documentLimit)
          .getDocuments();
    }
    print("Society data");

    if (querySnapshot.documents.length < documentLimit) {
      print("data finish");
      hasMore = false;
    }
    if (querySnapshot.documents.length != 0) {
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];
      print("final data");

      setState(() {
        querySnapshot.documents.forEach((element) {
          var gate = Gate();
          gate = Gate.fromJson(element.data);
          gateList.add(gate);
        });
      });
    }

    print("load more data");
    print(gateList.length);
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> _showDeletDialog(Gate gate) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // title: Text('AlertDialog Title'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 "Are You sure want to Delete this Event",
  //                 style: TextStyle(color: UniversalVariables.background),
  //               )
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           RaisedButton(
  //             child: Text('No'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           RaisedButton(
  //             child: Text('Yes'),
  //             onPressed: () {
  //               deleteGate(gate);
  //               deleteActivationCode(gate);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // deleteGate(Gate gate) async {
  //   await Firestore.instance
  //       .collection('Society')
  //       .document(global.societyId)
  //
  //       .collection("Gate")
  //
  //       .document(gate.gateId)
  //       .updateData({
  //     "enable": false,
  //   }).then((data) async {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     setState(() {
  //       gateList.remove(gate);
  //     });
  //     Fluttertoast.showToast(msg: "Delete successfully");
  //     Navigator.pop(context);
  //   }).catchError((err) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(msg: err.toString());
  //   });
  // }
  //
  // deleteActivationCode(Gate gate) async {
  //   await Firestore.instance
  //       .collection('ActivationCode')
  //       .document(gate.gateId)
  //       .updateData({
  //     "enable": false,
  //   });
  // }

  Widget _floatingButton() {
    if (global.appType == "Residents") {
      return Container();
    } else {
      return FloatingActionButton(
        onPressed: () {
          navigateSecondPage();
        },
        child: Icon(Icons.add),
      );
    }
  }

  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    print("On call back");
    getGetDetails(null);

    setState(() {});
  }

  void navigateSecondPage() {
    // Route route = CupertinoPageRoute(builder: (context) => addGate());
    // Navigator.push(context, route).then(onGoBack);
  }
}
