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
                                    Route route = CupertinoPageRoute(builder: (context) =>PollsGiven(
                                            polls : pollsList[index],
                                          ));
                                          Navigator.push(context, route).then(onGoBack);

                                   // stopVotingAgain(pollsList[index].pollsId,pollsList[index]);

                                   // stopVotingAgain(pollsList[index].pollsId,pollsList[index]);


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
    print( DateFormat("yyyy-MM-dd").parse(DateTime.now().toIso8601String()),);
    if (_lastDocument == null) {
      pollsList.clear();
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Polls")
          .where("enable", isEqualTo: true)
          .where("startDate",isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)).toIso8601String())

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
          .where("startDate",isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)).toIso8601String())

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

  // voting(var pollsId, var options) {
  //   print("call to voting function");
  //   Firestore.instance
  //       .collection("Society")
  //       .document(global.mainId)
  //       .collection("Polls")
  //       .document(pollsId.toString())
  //       .collection("ResidentPolls")
  //       .document(global.parentId)
  //       .setData({"VoteAns": options});
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
