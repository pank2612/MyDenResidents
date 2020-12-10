import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/ModelClass/AllowFrequently.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/pre_approve_delivery/OnlineServicesList.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVisitingHelpFrequently extends StatefulWidget {
  final name;

  const AddVisitingHelpFrequently({Key key, this.name}) : super(key: key);

  @override
  _AddVisitingHelpOneState createState() => _AddVisitingHelpOneState();
}

class _AddVisitingHelpOneState extends State<AddVisitingHelpFrequently> {
  TextEditingController _allowOnceDateController = TextEditingController();
  TextEditingController _firstTimeController = TextEditingController();
  TextEditingController _secondTimeController = TextEditingController();
  var data = "Select Days";
  bool isLoading = false;
  UserData _userData = UserData();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();
  void showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
  Future<Null> _selectDate(
      BuildContext context, DateTime firstDate, DateTime lastDate) async {
    DateTime selectedDate = firstDate;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null) // && picked != selectedDate)
      selectedDate = picked;
    String _formattedate =
    new DateFormat(global.dateFormat).format(selectedDate);
    setState(() {
      _allowOnceDateController.value = TextEditingValue(text: _formattedate);
    });
  }



  @override
  void initState() {
    _userData = context.bloc<AuthBloc>().getCurrentUser();



    global.companycontroller.clear();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: ListView(children: [
        SizedBox(height: 50),
        Padding(
          padding: EdgeInsets.all(15),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Form(
                        key: global.formKey,
                        child: Column(
                          children: [
                            Text(
                              "Allow " +
                                  widget.name +
                                  " executed to enter today once in next",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PopupMenuButton<String>(
                              child:Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: UniversalVariables.background)),
                                  child: Padding(padding: EdgeInsets.all(11),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("$data",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 18),),
                                        Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  )
                              ),
                              onSelected: (String val) {
                                data = val;
                                setState(() {
                                  global.changeValidation = global.documentData[val];
                                });
                              },
                              itemBuilder: (BuildContext context) {
                                return
                                  global.dayArray
                                      .map<PopupMenuItem<String>>((String val) {
                                    return new PopupMenuItem(
                                        child: new Text(val), value: val);
                                  }
                                  ).toList();
                              },
                            ),
                            SizedBox(height: 20,),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OnlineServices()));
                              },
                              child: IgnorePointer(
                                child: constantTextField().InputField(
                                    "CompanyName",
                                    "",
                                    validationKey.companyName,
                                    global.companycontroller,
                                    false,
                                    IconButton(
                                        icon:
                                        Icon(Icons.directions_car),
                                        onPressed: null),
                                    1,
                                    1,
                                    TextInputType.text,
                                    false),
                              ),
                            ),
                            SizedBox(height: 20,),
                            // InkWell(
                            //   onTap: () {
                            //     _selectDate(
                            //         context,
                            //         DateTime.now().subtract(Duration(days: 0)),
                            //         DateTime.now().add(Duration(days: 365)));
                            //   },
                            //   child: IgnorePointer(
                            //       child: constantTextField().InputField(
                            //           "Enter Date",
                            //           "",
                            //           validationKey.date,
                            //           _allowOnceDateController,
                            //           true,
                            //           IconButton(
                            //             icon: Icon(Icons.calendar_today),
                            //             onPressed: () {},
                            //           ),
                            //           1,
                            //           1,
                            //           TextInputType.name,
                            //           false)),
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay(
                                                    hour: DateTime.now().hour,
                                                    minute:
                                                        DateTime.now().minute))
                                            .then((TimeOfDay value) {
                                          if (value != null) {
                                            _firstTimeController.text =
                                                value.format(context);
                                          }
                                        });
                                      },
                                      child: IgnorePointer(
                                        child: constantTextField().InputField(
                                            "9:00 pm",
                                            "",
                                            validationKey.time,
                                            _firstTimeController,
                                            true,
                                            IconButton(
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                onPressed: () {}),
                                            1,
                                            1,
                                            TextInputType.emailAddress,
                                            false),
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: DateTime.now().hour,
                                                minute:
                                                DateTime.now().minute))
                                            .then((TimeOfDay value) {
                                          if (value != null) {
                                            _secondTimeController.text =
                                                value.format(context);
                                          }
                                        });
                                      },
                                      child: IgnorePointer(
                                        child: constantTextField().InputField(
                                            "9:00 pm",
                                            "",
                                            validationKey.time,
                                            _secondTimeController,
                                            true,
                                            IconButton(
                                                icon:
                                                Icon(Icons.arrow_drop_down),
                                                onPressed: () {}),
                                            1,
                                            1,
                                            TextInputType.emailAddress,
                                            false),
                                      )),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      SaveFrequentlyInformation();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        color: UniversalVariables.background,
                      ),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.done,
                          size: 30,
                          color: UniversalVariables.ScaffoldColor,
                        ),
                      )),
                    ),
                  )
                ],
              )),
        ),
        SizedBox(
          height: 50,
        )
      ]),
    );
  }

  SaveFrequentlyInformation() {
    if (global.formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      if (data == 'Select Days') {
        showScaffold("Select days First");


      } else {
        AllowFrequentlyModel allowFrequentlyModel = AllowFrequentlyModel(
            id: _userData.uid,
            startTime: _firstTimeController.text,
            endTime: _secondTimeController.text,
            validity: data,
            enable: true,
            companyName: global.companycontroller.text,
            userId: global.parentId
        );
        Firestore.instance.collection(global.SOCIETY).document(global.mainId)
            .collection(widget.name).document()
            .setData(jsonDecode(jsonEncode(allowFrequentlyModel.toJson())));
        Fluttertoast.showToast(msg: " added successful");
        global.companycontroller.clear();
        _firstTimeController.clear();
        _secondTimeController.clear();

      }
    }
  }


}
