import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;
import 'package:residents/ModelClass/HouseModel.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/ModelClass/VendorsModel.dart';
import 'package:residents/ModelClass/visitorModel.dart';

import 'addExpected.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetExpectedVisitors extends StatefulWidget {
  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<GetExpectedVisitors> {
  List<Visitor> visitorsList = List<Visitor>();
  List<House> houseList = List<House>();
  UserData _userData = UserData();

  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getExpectedVisitors(lastDocument);
    _userData = context.bloc<AuthBloc>().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getExpectedVisitors(lastDocument);
      }
    });
    return Scaffold(
        body: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
            ),
            Expanded(
              child: visitorsList.length == 0
                  ? Center(
                      child: Text(
                      "No Expected visitors have yet",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: UniversalVariables.background),
                    ))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: visitorsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            visitorsList[index].visitorType + " + " + visitorsList[index].visitorNumber,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15),
                                          ),
                                          visitorsList[index].inviteBye == "Guard" && visitorsList[index].enable == true ?
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _showAcceptDialog(
                                                      visitorsList[index]);
                                                },
                                                child: Card(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            20)),
                                                    color: Colors.green,
                                                    elevation: 10,
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.all(5),
                                                      child: Text(
                                                        "Accept Visitor",
                                                        style: TextStyle(
                                                            color: UniversalVariables
                                                                .ScaffoldColor,
                                                            fontWeight:
                                                            FontWeight
                                                                .w800,
                                                            fontSize: 12),
                                                      ),
                                                    )),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _showDeletDialog(
                                                      visitorsList[index]);
                                                },
                                                child: Card(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            20)),
                                                    color: Colors.red[900],
                                                    elevation: 10,
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.all(5),
                                                      child: Text(
                                                        "Cancel Visitor",
                                                        style: TextStyle(
                                                            color: UniversalVariables
                                                                .ScaffoldColor,
                                                            fontWeight:
                                                            FontWeight
                                                                .w800,
                                                            fontSize: 12),
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ):
                                          visitorsList[index].enable == true
                                              ? InkWell(
                                                  onTap: () {
                                                    _showDeletDialog(
                                                        visitorsList[index]);
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                      color: Colors.red[900],
                                                      elevation: 10,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Cancel Visitor",
                                                          style: TextStyle(
                                                              color: UniversalVariables
                                                                  .ScaffoldColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 12),
                                                        ),
                                                      )),
                                                )
                                              : visitorsList[index].accept == true ?
                                          Card(
                                              color: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Accept By " +
                                                      visitorsList[index]
                                                          .deletName,
                                                  style: TextStyle(
                                                      color:
                                                      UniversalVariables
                                                          .ScaffoldColor,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 12),
                                                ),
                                              )):
                                          Card(
                                              color: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Cancel By " +
                                                      visitorsList[index]
                                                          .deletName,
                                                  style: TextStyle(
                                                      color:
                                                      UniversalVariables
                                                          .ScaffoldColor,
                                                      fontWeight:
                                                      FontWeight.w800,
                                                      fontSize: 12),
                                                ),
                                              ))
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          70)),
                                              height: 50,
                                              width: 50,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(70),
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: visitorsList[index]
                                                                  .accept ==
                                                              true
                                                          ? Image.asset(
                                                              "images/done.png",
                                                              fit: BoxFit.cover,
                                                            )
                                                          :  visitorsList[index]
                                                          .accept ==
                                                          false
                                                          ?
                                                      Image.asset(
                                                              "images/cancel.png",
                                                              fit: BoxFit.cover,
                                                            ):Image.asset(
                                                        "images/coming.png",
                                                        fit: BoxFit.cover,
                                                      )))),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Text(
                                                  visitorsList[index].name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Text(
                                                visitorsList[index]
                                                    .mobileNumber,
                                              ),
                                              visitorsList[index].allDay == null
                                                  ? Text(
                                                      'Your visitor is At Gate')
                                                  : Row(
                                                      children: [
                                                        Text('Coming at: '),
                                                        visitorsList[index]
                                                                    .allDay ==
                                                                false
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    visitorsList[
                                                                            index]
                                                                        .firstInviteTime,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                  Text(' to ',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w800)),
                                                                  Text(
                                                                    visitorsList[
                                                                            index]
                                                                        .secondInviteTime,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                " Any Time",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              )
                                                      ],
                                                    ),
                                              Text(
                                                DateFormat(globals.dateFormat)
                                                    .format(visitorsList[index]
                                                        .inviteDate),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      // Divider(
                                       //   color: Colors.black,
                                      // ),
                                      Text(visitorsList[index].token ?? ""),

                                      visitorsList[index].inviteBye == "Guard"
                                          ? Card(
                                              color: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                    "Without Invitation",
                                                    style: TextStyle(
                                                        color:
                                                            UniversalVariables
                                                                .ScaffoldColor,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 12)),
                                              ))
                                          :
                                          Card(
                                              color: Colors.grey,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      20)),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Text(
                                                  "Invite By " +
                                                      visitorsList[
                                                      index]
                                                          .inviteBye,
                                                  style: TextStyle(
                                                      color: UniversalVariables
                                                          .ScaffoldColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w800,
                                                      fontSize: 12),
                                                ),
                                              ))

                                    ],
                                  )),
                            ));
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
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddExpected()));
            navigateSecondPage();
          },
          child: Icon(Icons.add),
        ));
  }

  getExpectedVisitors(
    DocumentSnapshot _lastDocument,
  ) async {
    // print(houseId);
    print("jkjbk");
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
      visitorsList.clear();
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(globals.VISITORS)
          .where('houseId', isEqualTo: globals.parentId)
          .where("inviteDate",
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .orderBy("inviteDate", descending: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(globals.VISITORS)
          .where('houseId', isEqualTo: globals.parentId)
          .where("inviteDate",
              isGreaterThanOrEqualTo:
                  DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .orderBy("inviteDate", descending: true)
          .startAfterDocument(_lastDocument)
          .limit(documentLimit)
          .getDocuments();
    }
    if (querySnapshot.documents.length < documentLimit) {
      hasMore = false;
    }
    if (querySnapshot.documents.length != 0) {
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];

      setState(() {
        querySnapshot.documents.forEach((element) {
          var visitors = Visitor();
          visitors = Visitor.fromJson(element.data);
          visitorsList.add(visitors);
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }


  Future<void> _showAcceptDialog(Visitor visitor) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Are You sure want to  Accept this Visitors Entry",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: UniversalVariables.background,
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: UniversalVariables.background,
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  acceptVisitors(visitor);
                });
              },
            ),
          ],
        );
      },
    );
  }


  acceptVisitors(Visitor visitor) async {
    await Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(globals.VISITORS)
        .document(visitor.id)
        .setData({
      "accept": true,
      "enable": false,
      "deletName": _userData.name},
        merge: true).then((data) async {
      setState(() {
        isLoading = false;
      });
      getExpectedVisitors(null);

      Fluttertoast.showToast(msg: "Accept successfully");
      Navigator.pop(context);
    }).then(onGoBack);
  }




  Future<void> _showDeletDialog(Visitor visitor) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Are You sure want to  Delete this Visitors Entry",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: UniversalVariables.background,
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: UniversalVariables.background,
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  deleteVisitors(visitor);
                });
              },
            ),
          ],
        );
      },
    );
  }

  deleteVisitors(Visitor visitor) async {
    await Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection(globals.VISITORS)
        .document(visitor.id)
        .setData({
      "accept": false,
      "enable": false,
      "deletName": _userData.name},
            merge: true).then((data) async {
      setState(() {
        isLoading = false;
      });
      getExpectedVisitors(null);

      Fluttertoast.showToast(msg: "Delete successfully");
      Navigator.pop(context);
    }).then(onGoBack);
  }




  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    getExpectedVisitors(null);
  }

  void navigateSecondPage() {
    Route route = CupertinoPageRoute(builder: (context) => AddExpected());
    Navigator.push(context, route).then(onGoBack);
  }
}
