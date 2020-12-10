import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/tokenGenerate.dart';
import 'package:residents/ModelClass/ActivationModel.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:uuid/uuid.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

class AddHouseScreen extends StatefulWidget {
  @override
  _AddHouseScreenState createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
  TextEditingController _tokenController = TextEditingController();

  bool isLoading = false;

  SaveActivation() async {
    ActivationCode activationCode = ActivationCode(
        iD: global.uuid,
        type: "Residents",
        society: global.mainId,
        creationDate: DateTime.now(),
        societyId: _tokenController.text,
        master: false,
        flatNo: global.flatNo,
        enable: true);
    await Firestore.instance
        .collection('ActivationCode')
        .document()
        .setData(jsonDecode(jsonEncode(activationCode.toJson())))
        .then((data) async {
      _showDialog();
      setState(() {
        isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Family Members',
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
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                "Enter Button to Generate Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 50,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 2,
                ),
                GestureDetector(
                    onTap: () {
                      _tokenController.text = RandomString(10);
                      global.uuid = Uuid().v1();
                      SaveActivation();
                    },
                    child: Card(
                        color: UniversalVariables.background,
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Add House",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                          ),
                        ))),
              ])
            ],
          ),
        ),
        Positioned(
          child: isLoading
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ),
      ]),
    );
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  " Code Generate For Resident is Successfully Please share this code to your family Members",
                  style: TextStyle(color: UniversalVariables.background),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('share Code'),
              onPressed: () async {
                var response = await FlutterShareMe().shareToSystem(
                  msg: global.RWATokenMsg + _tokenController.text,
                );
                if (response == 'success') {
                  print('navigate success');
                }
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}


