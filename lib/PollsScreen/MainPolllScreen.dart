import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/PollsModel.dart';

import 'Polls.dart';


class mainPollScreen extends StatefulWidget {
  @override
  _mainPollScreenState createState() => _mainPollScreenState();
}

class _mainPollScreenState extends State<mainPollScreen> {
  // int id = 1;
  // String VotingOption = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Polls> pollsList = List<Polls>();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument = null;
  DateTime getSelectedStartDate = DateTime.now();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    getGetDetails(lastDocument);
  }

  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Polls',
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: pollsList.length == 0
                        ? Center(
                            child: Text(
                            "There is no Polls today",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: UniversalVariables.background),
                          ))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: pollsList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: GestureDetector(onTap: (){

                                   // stopVotingAgain(pollsList[index].pollsId,);
                                    Route route = CupertinoPageRoute(builder: (context) =>PollsGiven(
                                     polls : pollsList[index],
                                    ));
                                    Navigator.push(context, route).then(onGoBack);
                                  },
                                  child:  Card(
                                      elevation: 10,
                                      color: UniversalVariables.ScaffoldColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "Poll Topic:   " +
                                                    pollsList[index].pollName,
                                                style: TextStyle(

                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),
                                              ),
                                            ),
                                            // optionList(
                                            //     pollsList[index].options,
                                            //     pollsList[index].pollsId,
                                            //     pollsList[index].pollName),
                                            // // optionList(pollsList[index]
                                            // //     .options),

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              " Last Date     " +
                                                  DateFormat(global.dateFormat)
                                                      .format(pollsList[index]
                                                      .startDate),
                                              style: TextStyle(

                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),
                                            ),
                                          ],
                                        ),
                                      )),
                                  )
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _floatingButton(),
    );
  }

  // Widget optionList(
  //   List data,
  //   var pollsId,
  //   var pollsTopic,
  // ) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 1.2,
  //     child: ListView.builder(
  //         physics: NeverScrollableScrollPhysics(),
  //         shrinkWrap: true,
  //         controller: _scrollController,
  //         itemCount: data.length,
  //         itemBuilder: (context, index) {
  //
  //
  //           return ListTile(
  //             title: Text(
  //                     data[index],
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.w800,
  //                     ),
  //                   ),
  //             leading: Radio(
  //                 value: data[index],
  //                 groupValue: id,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     VotingOption = data[index];
  //
  //                     print(VotingOption);
  //                   });
  //                 },
  //               activeColor: UniversalVariables.background,
  //             ),
  //           );
  //
  //
  //           //   InkWell(
  //           //   onTap: () {
  //           //     _showDialog(data[index], pollsId);
  //           //
  //           //     // voting(pollsId,pollsTopic,data[index]);
  //           //   },
  //           //   child: Container(
  //           //     margin: const EdgeInsets.only(top: 15),
  //           //     padding: const EdgeInsets.all(10),
  //           //     decoration: BoxDecoration(
  //           //         borderRadius: BorderRadius.circular(20),
  //           //         border: Border.all(color: UniversalVariables.background)),
  //           //     child: Text(
  //           //       data[index],
  //           //       style: TextStyle(
  //           //         fontSize: 20,
  //           //         fontWeight: FontWeight.w800,
  //           //       ),
  //           //     ),
  //           //   ),
  //           // );
  //         }),
  //   );
  // }

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
    print('No More Data');
    if (_lastDocument == null) {
      pollsList.clear();
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Polls")
          .where("enable", isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      print('No call data');
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Polls")
          .startAfterDocument(_lastDocument)
          .where("enable", isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    }


    if (querySnapshot.documents.length < documentLimit) {
      print("data finish");
      hasMore = false;
    }
    if (querySnapshot.documents.length != 0) {
      lastDocument =
          querySnapshot.documents[querySnapshot.documents.length - 1];
      print("final data");
      // querySnapshot.documents.
      //events.addAll(querySnapshot.documents);

      setState(() {
        querySnapshot.documents.forEach((element) {
          var polls = Polls();
          polls = Polls.fromJson(element.data);
          pollsList.add(polls);
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  voting(var pollsId, var options) {
    print("call to voting function");
    Firestore.instance
        .collection("Society")
        .document(global.mainId)
        .collection("Polls")
        .document(pollsId.toString())
        .collection("ResidentPolls")
        .document(global.parentId)
        .setData({"VoteAns": options});
  }

  // Future<void> _showDialog(
  //   var pollOptions,
  //   var pollsId,
  // ) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Poll'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text(
  //                 pollOptions,
  //                 style: TextStyle(color: UniversalVariables.background),
  //               )
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           RaisedButton(
  //             elevation: 10,
  //             color: UniversalVariables.background,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(18.0),
  //                 side: BorderSide(color: UniversalVariables.ScaffoldColor)),
  //             child: Text('No'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           RaisedButton(
  //             elevation: 10,
  //             color: UniversalVariables.background,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(18.0),
  //                 side: BorderSide(color: UniversalVariables.ScaffoldColor)),
  //             child: Text('Yes'),
  //             onPressed: () {
  //               stopVotingAgain(pollsId, pollOptions);
  //               Navigator.pop(context);
  //               //  voting(pollsId, pollOptions);
  //
  //               // if (stopVotingAgain(pollsId) != null) {
  //               //
  //               //   voting(pollsId, pollOptions);
  //               //   showScaffold("Thanks for Voting");
  //               //
  //               //   Navigator.pop(context);
  //               // } else {
  //               //   Navigator.pop(context);
  //               // print  (stopVotingAgain(pollsId));
  //               //   voting(pollsId, pollOptions);
  //               //   showScaffold("You Cant't vote again ");
  //               // }
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // stopVotingAgain(var pollsID, ) {
  //
  //
  //   Firestore.instance
  //       .collection("Society")
  //       .document(global.mainId)
  //       .collection("Polls")
  //       .document(pollsID.toString())
  //       .collection("ResidentPolls")
  //      // .document(global.parentId)
  //       .get(source: Source.server ).then((value) {
  //         value.data.forEach((key, value) {
  //           print(value);
  //           if (value == null) {
  //
  //                   showScaffold("Thanks for Voting");
  //                 } else {
  //                   showScaffold("You Cant't vote again ");
  //                 }
  //         });
  //   });
  //       // .then((value) => value.documents.forEach((element) {
  //       //       print(element["VoteAns"]);
  //       //       // if (element['VoteAns'] == null) {
  //       //       //   voting(pollsID, pollOptions);
  //       //       //   showScaffold("Thanks for Voting");
  //       //       // } else {
  //       //       //   showScaffold("You Cant't vote again ");
  //       //       // }
  //       //     }));
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
    getGetDetails(null);
    setState(() {});
  }

  void navigateSecondPage() {
    // Route route = CupertinoPageRoute(builder: (context) => addAmenity());
    // Navigator.push(context, route).then(onGoBack);
  }
}
