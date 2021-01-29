import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/HouseModel.dart';
import 'package:residents/ModelClass/MaidModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;
import 'package:residents/ModelClass/UserModel.dart';

class ShowFullDetails extends StatefulWidget {
  final AllService allService;

  const ShowFullDetails({Key key, this.allService}) : super(key: key);

  @override
  _ShowFullDetailsState createState() => _ShowFullDetailsState();
}

class _ShowFullDetailsState extends State<ShowFullDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // UserData _userData = UserData();
  List<House> houseList = List<House>();
  DocumentSnapshot lastDocument = null;

  // List<String> flatrNumberList = [];

  @override
  void initState() {
    //  _userData = context.bloc<AuthBloc>().getCurrentUser();
    super.initState();
    houseService();
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
          title: Text(widget.allService.service + " Profile"),
          backgroundColor: UniversalVariables.background,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  Container(
                    height: 60,
                    color: UniversalVariables.background,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                  height: 90,
                                  width: 90,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(70.0)),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.allService.photoUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.allService.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                widget.allService.mobileNumber,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.phone,
                                          color:
                                              UniversalVariables.ScaffoldColor,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: UniversalVariables.background,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.share,
                                          color:
                                              UniversalVariables.ScaffoldColor,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        ),
                                        Text(
                                          "5.0",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "1 Rating",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    )
                                  ],
                                ),
                                OutlineButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {},
                                  child: Text("VIEW ALL"),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.watch_later,
                                      size: 60,
                                      color: Colors.lightBlueAccent,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black87,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                                color: UniversalVariables
                                                    .ScaffoldColor),
                                          ),
                                        )),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Very Punctual",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800
                                            // color: UniversalVariables.ScaffoldColor
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.perm_contact_calendar,
                                      size: 60,
                                      color: Colors.green,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black87,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                                color: UniversalVariables
                                                    .ScaffoldColor),
                                          ),
                                        )),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Quite Regular",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,

                                          // color: UniversalVariables.ScaffoldColor
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard,
                                      size: 60,
                                      color: Colors.redAccent,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black87,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                                color: UniversalVariables
                                                    .ScaffoldColor),
                                          ),
                                        )),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Exceptional",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800
                                            // color: UniversalVariables.ScaffoldColor
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.person_pin,
                                      size: 60,
                                      color: Colors.yellow,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.black87,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            "0",
                                            style: TextStyle(
                                                color: UniversalVariables
                                                    .ScaffoldColor),
                                          ),
                                        )),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Great Attitude",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800
                                            // color: UniversalVariables.ScaffoldColor
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.home),
                                Text(
                                  "  WORKS IN HOUSES",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                )
                              ],
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: houseList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.grey[300]),
                                              child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text("Flat Number " +
                                                    houseList[index]
                                                        .flatNumber),
                                              ))
                                        ],
                                      );
                                    }))
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
            Positioned(
              left: 40,
              right: 40,
              bottom: 60,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: UniversalVariables.background,
                  onPressed: () {
                    addServiceToNotification();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "+ Add to Household",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: UniversalVariables.ScaffoldColor,
                          fontSize: 20),
                    ),
                  )),
            )
          ],
        ));
  }

  addServiceToNotification() {
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection("Houses")
        .document(globals.parentId)
        .setData({
      "LocalService": FieldValue.arrayUnion([
        {
          "id": widget.allService.documentNumber,
          "enable": true,
          "service": widget.allService.service
        }
      ])
    }, merge: true);
    addHouseIdInLocalService();
    showScaffold(widget.allService.service + " is added");

  }


  addHouseIdInLocalService(){
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection("LocalServices")
        .document(widget.allService.documentNumber,)
        .setData({
      "HouseId": FieldValue.arrayUnion([
        {
          "id": globals.parentId,
          "enable": true,

        }
      ])
    }, merge: true);
  }



  houseService() {
    QuerySnapshot querySnapshot;
    Firestore.instance
        .collection(globals.SOCIETY)
        .document(globals.mainId)
        .collection("HouseDevices")
        .where("enable", isEqualTo: true)
        .where("Maid", isEqualTo: widget.allService.documentNumber)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) async {
        print(element['houseId']);
        querySnapshot = await Firestore.instance
            .collection(globals.SOCIETY)
            .document(globals.mainId)
            .collection("Houses")
            .where("enable", isEqualTo: true)
            .where("houseId", isEqualTo: element['houseId'])
            .getDocuments();
        if (querySnapshot.documents.length != 0) {
          lastDocument =
              querySnapshot.documents[querySnapshot.documents.length - 1];
          print("final data");
          setState(() {
            querySnapshot.documents.forEach((element) {
              var houses = House();
              houses = House.fromJson(element.data);
              houseList.add(houses);
            });
          });
        }
      });
    });
  }
}

class ContestDetails {
  var contestId;
  var feamId;

  ContestDetails({this.contestId, this.feamId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contestID'] = this.contestId;
    data['feamID'] = this.feamId;
    return data;
  }
}
