import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/EventsModel.dart';

import 'EventHistory.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventsScreen> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  List<Event> eventList = List<Event>();
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 5;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();



  bool isExpanded = false;
  final formKey = GlobalKey<FormState>();


  DateTime getSelectedStartDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context, DateTime firstDate,
      DateTime lastDate, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null)
      setState(() {
        isLoading = true;
        String formatDate = new DateFormat(global.dateFormat).format(picked);
        getSelectedStartDate = picked;
        _startDateController.value = TextEditingValue(text: formatDate);
      });
  }

  Future<Null> _selectEndDate(BuildContext context, DateTime firstDate,
      DateTime lastDate, DateTime selectedDate) async {
    print(selectedDate);

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: getSelectedStartDate,
        lastDate: lastDate);
    if (picked != null)
      setState(() {
        isLoading = true;
        String formatDate = new DateFormat(global.dateFormat).format(picked);
        _endDateController.value = TextEditingValue(text: formatDate);
      });
  }



  @override
  void initState() {

    getEventDetails(lastDocument);

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
        getEventDetails(lastDocument);
      }
    });
    print("build widget  two call");
    return Scaffold(
      appBar: AppBar(
        title: Text('Events',style: TextStyle(color: UniversalVariables.ScaffoldColor),),
        backgroundColor: UniversalVariables.background,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.history,size: 30,),
              onPressed: (){
                _eventHistory();
              })

        ],
      ),
      body: Stack(children: [

        Column(children: [
          SizedBox(
            height: 10,
          ),

          Expanded(
            child: eventList.length == 0
                ? Center(child: Text("No Data"))
                : ListView.builder(
              controller: _scrollController,
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: GestureDetector(
                        onTap: () {

                        },
                        child: Card(
                          // width: MediaQuery.of(context).size.width,
                          child: ExpansionTile(
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/2,
                                  child: Text(
                                    eventList[index].eventName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,

                                    ),overflow: TextOverflow.ellipsis,maxLines: 1,
                                  ),
                                ),
                              ]),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        "Venue - " +
                                            eventList[index].venue,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "Entry - " +
                                            eventList[index].eventFee,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ]),
                                    Text(
                                      "Date - " +
                                          DateFormat(global.dateFormat)
                                              .format(eventList[index]
                                              .startDate),
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "endDate - " +
                                          DateFormat(global.dateFormat)
                                              .format(eventList[index]
                                              .endDate),
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "Timing - " +
                                          eventList[index].eventTiming,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      eventList[index].description,
                                      style: TextStyle(
                                          fontSize: 15,fontWeight: FontWeight.w800
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanding) =>
                                setState(
                                        () => this.isExpanded = expanding),
                          ),
                        )
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
        ]),
      ]),

    );
  }

  getEventDetails(DocumentSnapshot _lastDocument) async {
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
      eventList.clear();
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Events")
          .orderBy("startDate")
          .where("startDate",
          isGreaterThanOrEqualTo:
          DateTime.now().subtract(Duration(days: 1)).toIso8601String())
          .where("enable", isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(global.mainId)
          .collection("Events")
          .orderBy("startDate")
          .where("startDate",
          isGreaterThanOrEqualTo:
          DateTime.now().subtract(Duration(days: 1)).toIso8601String())
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
          var event = Event();
          event = Event.fromJson(element.data);
          eventList.add(event);
        });
      });
    }

    print("load more data");
    print(eventList.length);
    setState(() {
      isLoading = false;
    });
  }



  Future<void> _eventHistory() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "First Date",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: InkWell(
                            onTap: () => _selectDate(
                                context,
                                DateTime.now().subtract(Duration(days: 365)),
                                DateTime.now().subtract(Duration(days: 1)),
                                DateTime.now().subtract(Duration(days: 31))),
                            child: IgnorePointer(
                              child: constantTextField().InputField(
                                  "Start Date",
                                  "20 - 12 - 2020",
                                  validationKey.date,
                                  _startDateController,
                                  true,
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.calendar_today),
                                  ),
                                  1,1,
                                  TextInputType.emailAddress,false
                                //Icon(Icons.calendar_today)

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Last Date",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: InkWell(
                            onTap: () {
                              if (isLoading == true) {
                                _selectEndDate(
                                    context,
                                    DateTime.now().subtract(Duration(days: 365)),
                                    DateTime.now(),
                                    DateTime.now());
                              }
                            },
                            child: IgnorePointer(
                              child: constantTextField().InputField(
                                  "End Date",
                                  "20 - 12 - 2020",
                                  validationKey.date,
                                  _endDateController,
                                  true,
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.calendar_today),
                                  ),
                                  1,1,
                                  TextInputType.emailAddress,false),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Yes'),
              onPressed: () {
                updateInformation();
              },
            ),
          ],
        );
      },
    );
  }

  updateInformation() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => EventHistory(
                  startDate: _startDateController.text,
                  endDate: _endDateController.text,
                )));
      });
    }
  }






  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    print("On call back");
    getEventDetails(null);

    setState(() {});
  }


}
