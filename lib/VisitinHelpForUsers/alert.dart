import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/AlertsModel.dart';
import 'package:uuid/uuid.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
class AlertsForUsers extends StatefulWidget {
  @override
  _AlertsState createState() => _AlertsState();
}

class _AlertsState extends State<AlertsForUsers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();
  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  var selectedIndex = null;
  bool isLoading = false;
  bool isCheckedHouse = false;
  bool isCheckedadmin = false;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _alertController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Alerts"),
        backgroundColor: UniversalVariables.background,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: Padding(padding: EdgeInsets.all(15),
      child:  ListView(
        children: [
          SizedBox(height: 40,),
          Container(
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _alertCategory.length,
              itemBuilder: (BuildContext context, int index) => Row(
                children: [
                  SizedBox(
                      width: 100,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          _alertController.text =
                          _alertCategory[index]['name'];
                          print(_alertController.text);
                        },
                        child: Card(
                            child: Stack(
                              children: [
                                Column(children: [
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Container(
                                    child: Image.network(
                                      _alertCategory[index]["image"],
                                      fit: BoxFit.cover,
                                      height: 60,
                                      width: 70,
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              _alertCategory[index]['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                            ),
                                          ))),
                                ]),
                                Positioned(
                                  right: 0,
                                  child: Icon(
                                    Icons.check,
                                    color:
                                    UniversalVariables.nearlyDarkBlue,
                                    size: selectedIndex == index ? 30 : 0,
                                  ),
                                ),
                              ],
                            )),
                      )),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Your Message",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          TextFormField(
            maxLines: null,
            decoration: InputDecoration(hintText: "(Optional)"),
            controller: _descriptionController,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "Send this Emergency Message to",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Checkbox(
                activeColor: UniversalVariables.background,
                value: isCheckedHouse,
                onChanged: (value) {
                  setState(() {
                    isCheckedHouse = value;
                  });
                },
              ),
              Text("House Members"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Checkbox(
                activeColor: UniversalVariables.background,
                value: isCheckedadmin,
                onChanged: (value) {
                  setState(() {
                    isCheckedadmin = value;
                  });
                },
              ),
              Text("Society security and admin"),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: UniversalVariables.background,
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.only(right: 50, left: 50),
                  child: Text("Submit"),
                ),
                onPressed: () {
                  SaveInformation();
                },
              )
            ],
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
      )
    );
  }

  List<Map<String, dynamic>> _alertCategory = [
    {
      'name': 'Stuck in Lift',
      'image':
      "https://cdn.iconscout.com/icon/premium/png-128-thumb/stuck-in-lift-1560887-1322669.png"
    },
    {
      'name': "Fire",
      'image':
      "https://cdn.iconscout.com/icon/premium/png-256-thumb/fire-2096406-1767058.png"
    },
    {
      'name': 'Medical Emergency',
      'image':
      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSERIuXGm7xJfW4e6v3Neg9HzTNskr6C2d8jA&usqp=CAU"
    },
    {
      'name': "Visitors Threat",
      'image':
      "https://cdn2.iconfinder.com/data/icons/insurance-type-coverage/278/insurance-claim-002-512.png"
    },
    {
      'name': 'Animal Threat',
      'image':
      "https://www.grow-trees.com/images/Biodiversity%20Enhancement.png"
    },
  ];



  SaveInformation() async {
    if ((isCheckedHouse || isCheckedadmin) && selectedIndex != null) {
    } else {
      if (selectedIndex == null) {
        return showScaffold("First Select alert Type msg");
      } else {
        return showScaffold("Select send this emergency message to");
      }
    }
    Alerts alerts = Alerts(
      alertsId: Uuid().v1(),
      alertsHeading: _alertController.text,
      startDate: DateTime.now(),
      description: _descriptionController.text,
      enable: true,
      type: "Residents",
      houseMember: isCheckedHouse,
      securityAdmin: isCheckedadmin,
    );
    await Firestore.instance
        .collection('Society')
        .document(global.mainId)
        .collection("Alerts")
        .document(alerts.alertsId)
        .setData(jsonDecode(jsonEncode(alerts.toJson())))
        .then((data) async {
      setState(() {
        isLoading = false;
      });
      showScaffold(" Alert message Send Successfully");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }


}
