import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/LocalService/AddAllLocalServices.dart';
import 'package:residents/LocalService/ServiceFullDetails.dart';
import 'package:residents/ModelClass/MaidModel.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;

class FullDetails extends StatefulWidget {
  final serviceName;

  const FullDetails({Key key, this.serviceName}) : super(key: key);

  @override
  _FullDetailsState createState() => _FullDetailsState();
}

class _FullDetailsState extends State<FullDetails> {
  List<AllService> serviceList = List<AllService>();

  bool showInsideService = false;
  bool changeSociety = false;

  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 15;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    getSocietyrServices(lastDocument);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getSocietyrServices(lastDocument);
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalVariables.background,
        title: Text(widget.serviceName),
      ),
      body: Stack(children: [
        Column(children: [

            SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
          ),


          Expanded(
            child: serviceList.length == 0
                ? Center(
                child: Text(
                  "No " + widget.serviceName + " have yet",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: UniversalVariables.background),
                ))
                : ListView.builder(
              controller: _scrollController,
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: GestureDetector(
                        onTap: () {
                          // Route route = CupertinoPageRoute(builder: (context) =>ShowFullDetails(
                          //   allService: serviceList[index],
                          // ));
                          // Navigator.push(context, route).then(onGoBack);
                        },
                        child: Card(
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54),
                                            borderRadius:
                                            BorderRadius.circular(
                                                50)),
                                        child: Container(
                                            height: 70,
                                            width: 70,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  50),
                                              child: CachedNetworkImage(
                                                placeholder:
                                                    (context, url) =>
                                                    Container(
                                                      child:
                                                      CircularProgressIndicator(
                                                        valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                            UniversalVariables
                                                                .background),
                                                      ),
                                                      width: 50.0,
                                                      height: 50.0,
                                                    ),
                                                imageUrl:
                                                serviceList[index]
                                                    .photoUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                serviceList[index].name,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                    FontWeight.w800),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 18,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.yellow,
                                              ),
                                              Text("5.0")
                                            ],
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      CircleAvatar(
                                        backgroundColor:
                                        UniversalVariables.background,
                                        minRadius: 30,
                                        child: serviceList[index]
                                            .passwordEnable ==
                                            true
                                            ? Text(
                                          "IN",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.w800,
                                              fontSize: 30,
                                              color: Colors.green),
                                        )
                                            : Text(
                                          "Out",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.w800,
                                              fontSize: 25,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        )));
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
      floatingActionButton:
      widget.serviceName == "Vendors" ? Container():


      FloatingActionButton.extended(
        backgroundColor: UniversalVariables.background,
        onPressed: () {
         navigateSecondPage();
        },
        icon: Icon(Icons.add),
        label: Text("Add " + widget.serviceName),
      ),
    );
  }



  getSocietyrServices(DocumentSnapshot _lastDocument) async {
    if (!hasMore) {
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
      serviceList.clear();
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
           .collection(widget.serviceName)
          .where("service", isEqualTo: widget.serviceName)
          .where('enable', isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection(widget.serviceName)
          .where("service", isEqualTo: widget.serviceName)
          .where('enable', isEqualTo: true)
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
          var service = AllService();
          service = AllService.fromJson(element.data);
          serviceList.add(service);
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }




  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    getSocietyrServices(null);
    setState(() {});
  }

  void navigateSecondPage() {
    Route route = CupertinoPageRoute(builder: (context) => AddAllLocalService(
      serviceName: widget.serviceName,
    ));
    Navigator.push(context, route).then(onGoBack);
  }
}
