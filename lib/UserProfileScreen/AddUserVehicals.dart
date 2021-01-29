import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;

class AddUserVehicle extends StatefulWidget {
  @override
  _AddUserVehicalState createState() => _AddUserVehicalState();
}

class _AddUserVehicalState extends State<AddUserVehicle> {
  TextEditingController _vehicleController = TextEditingController();
  TextEditingController _vehicleNumberController = TextEditingController();
  String operation = '';
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
          title: Text("Add Vehicle"),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      constantTextField().InputField(
                          "Enter Name eg. My Car",
                          "",
                          validationKey.name,
                          _vehicleController,
                          false,
                          IconButton(icon: Icon(Icons.add), onPressed: () {}),
                          1,
                          1,
                          TextInputType.name,
                          false),
                      SizedBox(
                        height: 10,
                      ),
                      constantTextField().InputField(
                          "Enter Vehicle Number",
                          "",
                          validationKey.name,
                          _vehicleNumberController,
                          false,
                          IconButton(icon: Icon(Icons.add), onPressed: () {}),
                          1,
                          1,
                          TextInputType.name,
                          false),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("VEHICLE TYPE"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile(
                              groupValue: operation,
                              title: Text(
                                '2-Wheeler',
                                style: TextStyle(fontSize: 15),
                              ),
                              value: '2-Wheeler',
                              onChanged: (val) {
                                setState(() {
                                  operation = val;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              groupValue: operation,
                              title: Text(
                                '4-Wheeler',
                                style: TextStyle(fontSize: 15),
                              ),
                              value: '4-Wheeler',
                              onChanged: (val) {
                                setState(() {
                                  operation = val;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        addVehicle();
                      },
                      child: Text("Add"),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  addVehicle() {
    if (formKey.currentState.validate()) {
    if(operation == "4-Wheeler" || operation == "2-Wheeler"){
      Firestore.instance
          .collection(globals.SOCIETY)
          .document(globals.mainId)
          .collection("Houses")
          .document(globals.parentId)
          .setData({
        operation : {
          "name":_vehicleController.text,
          "number": _vehicleNumberController.text
        }
      },merge: true);
    }else{
      showScaffold("Select Vehicle type First");
    }
    }
  }
}
