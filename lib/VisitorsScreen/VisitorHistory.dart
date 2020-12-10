import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/visitorModel.dart';

class VisitorHistory extends StatefulWidget {
  final startDate;
  final endDate;

  const VisitorHistory({Key key, this.startDate, this.endDate})
      : super(key: key);

  @override
  _EventHistoryState createState() => _EventHistoryState();
}

class _EventHistoryState extends State<VisitorHistory> {
  List<Visitor> visitorsList = List<Visitor>();
  bool hasMore = true;
  bool isExpanded = false;

  @override
  void initState() {
    print(DateFormat(global.dateFormat)
        .parse(widget.startDate)
        .toIso8601String());
    print(
        DateFormat(global.dateFormat).parse(widget.endDate).toIso8601String());

    getVisitorsDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Visitors History',
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
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
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
                                        visitorsList[index].visitorType,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15),
                                      ),
                                      visitorsList[index].enable == true
                                          ? InkWell(
                                        onTap: () {
                                          // _showDeletDialog(
                                          //     visitorsList[index]);
                                        },
                                        child: Card(
                                            shape:
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    20)),
                                            color: UniversalVariables
                                                .background,
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
                                          :Container()
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
                                                      .enable ==
                                                      true
                                                      ? Image.asset(
                                                    "images/done.png",
                                                    fit: BoxFit.cover,
                                                  )
                                                      : Image.asset(
                                                    "images/cancel.png",
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
                                              visitorsList[index]
                                                  .name,
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
                                          Row(
                                            children: [
                                              Text('Coming at: '),
                                              visitorsList[index].allDay ==
                                                  false
                                                  ? Row(
                                                children: [
                                                  Text(
                                                    visitorsList[
                                                    index]
                                                        .firstInviteTime,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .w800),
                                                  ),
                                                  Text(' to ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w800)),
                                                  Text(
                                                    visitorsList[
                                                    index]
                                                        .secondInviteTime,
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .w800),
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
                                            DateFormat(global.dateFormat)
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      visitorsList[index].enable == true
                                          ? Container()
                                          : Card(
                                          color: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  20)),

                                          child: Padding(
                                            padding:
                                            EdgeInsets.all(5),
                                            child: Text(
                                              "Cancel By " +
                                                  visitorsList[index]
                                                      .ownerName,
                                              style: TextStyle(
                                                  color: UniversalVariables
                                                      .ScaffoldColor,
                                                  fontWeight:
                                                  FontWeight.w800,
                                                  fontSize: 12),
                                            ),
                                          ))
                                    ],
                                  )
                                ],
                              )),
                        ));
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  getVisitorsDetails() async {
    print("Data");
    QuerySnapshot querySnapshot;
    querySnapshot = await Firestore.instance
        .collection(global.SOCIETY)
        .document(global.mainId)
        .collection(global.VISITORS)
        .where('houseId', isEqualTo: global.parentId)
        .where("inviteDate",
            isGreaterThanOrEqualTo: DateFormat(global.dateFormat)
                .parse(widget.startDate)
                .toIso8601String())
        .where("inviteDate",
            isLessThanOrEqualTo: DateFormat(global.dateFormat)
                .parse(widget.endDate)
                .toIso8601String())
        .getDocuments();

    if (querySnapshot.documents.length != 0) {
      setState(() {
        print("data");
        querySnapshot.documents.forEach((element) {
          var visitors = Visitor();
          visitors = Visitor.fromJson(element.data);
          visitorsList.add(visitors);
        });
      });
    }
  }
}
