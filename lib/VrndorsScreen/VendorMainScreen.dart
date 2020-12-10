
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;
import 'package:residents/ModelClass/VendorsModel.dart';



class VendorsScreen extends StatefulWidget {
  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  List<Vendor> vendorsList = List<Vendor>();

  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument = null;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getVendorDetails(lastDocument);
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
        getVendorDetails(lastDocument);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendors',style: TextStyle(color: UniversalVariables.ScaffoldColor),),
        backgroundColor: UniversalVariables.background,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
          children: [

            Column(children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
              ),
              Expanded(
                child: vendorsList.length == 0
                    ?Center(
                    child: Text(
                      "No vendors have arrived yet",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: UniversalVariables.background),
                    ))
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: vendorsList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: Card(
                          elevation: 10,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                      Text(
                                        vendorsList[index].vendor,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                  Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black54),
                                            borderRadius:
                                            BorderRadius.circular(15)),
                                        child: Container(
                                            height: 110,
                                            width: 100,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
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
                                                      padding: EdgeInsets.only(
                                                          left: 15,
                                                          top: 20,
                                                          right: 15,
                                                          bottom: 20),
                                                    ),
                                                imageUrl:
                                                vendorsList[index].photoUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vendorsList[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800),
                                          ),
                                          Text(
                                            vendorsList[index].mobileNumber,
                                          ),
                                          Text(
                                            vendorsList[index].enterTime,
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              )
                          ),
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
            ]),]
      ),
      floatingActionButton: _floatingButton(),
    );
  }

  getVendorDetails(DocumentSnapshot _lastDocument) async {
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
      vendorsList.clear();
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(globals.mainId)
          .collection("Vendors")
          .orderBy("enterTime")
          .where('enable',isEqualTo: true)
          .limit(documentLimit)
          .getDocuments();
    } else {
      querySnapshot = await Firestore.instance
          .collection('Society')
          .document(globals.mainId)
          .collection("Vendors")
          .orderBy("enterTime")
          .where('enable',isEqualTo: true)
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
          var notice = Vendor();
          notice = Vendor.fromJson(element.data);
          vendorsList.add(notice);
        });
      });
    }

    print("load more data");
    setState(() {
      isLoading = false;
    });
  }

  Widget _floatingButton(){
    if(globals.appType == "Residents"){
      return Container();
    }else{
      return   FloatingActionButton(
        onPressed: () {
          navigateSecondPage();
        },
        child: Icon(Icons.add),
      );
    }
  }

  FutureOr onGoBack(dynamic value) {
    hasMore = true;
    getVendorDetails(null);
    setState(() {});
  }

  void navigateSecondPage() {
    // Route route = CupertinoPageRoute(builder: (context) => addAmenity());
    // Navigator.push(context, route).then(onGoBack);
  }
}
