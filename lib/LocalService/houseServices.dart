import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;
import 'package:residents/ModelClass/MaidModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/ModelClass/UserModel.dart';

import 'ServiceFullDetails.dart';
class HouseServices extends StatefulWidget {
  final houseService;

  const HouseServices({Key key, this.houseService}) : super(key: key);
  @override
  _HouseServicesState createState() => _HouseServicesState();
}

class _HouseServicesState extends State<HouseServices> {
  List<AllService> serviceList = List<AllService>();


  bool isLoading = false;




  @override
  void initState() {

    super.initState();

    gethouseService();
   // getSocietyrServices(lastDocument);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Stack(children: [
        Column(children: [

          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
          ),


          Expanded(
            child: serviceList.length == 0
                ? Center(
                child: Text(
                  "No " + widget.houseService + " have yet",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: UniversalVariables.background),
                ))
                : ListView.builder(
             // controller: _scrollController,
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: GestureDetector(
                        onTap: () {
                          Route route = CupertinoPageRoute(builder: (context) =>ShowFullDetails(
                            allService: serviceList[index],
                          ));
                          Navigator.push(context, route).then(onGoBack);
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
    );
  }

  gethouseService()  {

    QuerySnapshot querySnapshot;
    DocumentSnapshot lastDocument = null;
    Firestore.instance.collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection("HouseDevices")
        .where("houseId",isEqualTo: globals.parentId)
        .getDocuments().then((value) async {
         print(value.documents[0]["Maid"]);
         print(globals.parentId);
         serviceList.clear();
         querySnapshot = await Firestore.instance
             .collection(globals.SOCIETY)
             .document(globals.mainId)
             .collection(widget.houseService)
            // .where("service", isEqualTo: widget.houseService)
             .where("documentNumber", isEqualTo: value.documents[0]["Maid"])
             .where('enable', isEqualTo: true)
            // .where("houseId",isEqualTo: globals.parentId)
             .getDocuments();
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


    });
  }

  FutureOr onGoBack(dynamic value) {
    // hasMore = true;
    gethouseService();
    setState(() {});
  }
}
