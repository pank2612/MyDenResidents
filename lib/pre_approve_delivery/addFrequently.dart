import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/ModelClass/AllowFrequently.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:residents/VisitorsScreen/try.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'OnlineServicesList.dart';

class AddFrequentlyAll extends StatefulWidget {
  final name;

  const AddFrequentlyAll({Key key, this.name}) : super(key: key);
  @override
  _AddFrequentlyAllState createState() => _AddFrequentlyAllState();
}

class _AddFrequentlyAllState extends State<AddFrequentlyAll> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   TextEditingController _firstTimeController = TextEditingController();
   TextEditingController _secondTimeController = TextEditingController();
   TextEditingController _vehicalNumberController = TextEditingController();
   TextEditingController _vehicalNameController = TextEditingController();
  bool isLoading = false;
  UserData _userData = UserData();
  var data = "";

  @override
  void initState() {
    print(widget.name);
    print("orderbt");
    _userData = context.bloc<AuthBloc>().getCurrentUser();
    global.selectDayList = ['Select Days'];
   // global.selectedFrequentlyList = ["Select Valid For"];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: UniversalVariables.background,
        title: Text("AddFrequently"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(children: [
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.all(15),
          child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Days of Week",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            _showDayialog();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: UniversalVariables.background)),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        global.selectDayList.join(" , "),
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Select Validity",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 10,
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

                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Select Allowed Time Slot",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                       Form(
                         key: global.formKey,
                         child:

                       Column(
                         children: [
                           widget.name == "AllowFrequentlyCab" ?
                           Stack(
                             children: [
                               IgnorePointer(
                                 child: constantTextField().InputField(
                                     "Vechical Name",
                                     "",
                                     validationKey.vehical,
                                     _vehicalNameController,
                                     false,
                                     IconButton(
                                       icon:
                                       Icon(Icons.arrow_back_ios),
                                       onPressed: () {},
                                     ),
                                     1,
                                     1,
                                     TextInputType.name,
                                     false),
                               ),
                               Positioned(
                                 right: 0,
                                 child: Container(
                                   alignment: Alignment.centerRight,
                                   child: PopupMenuButton<String>(
                                     icon: const Icon(
                                         Icons.arrow_downward),
                                     onSelected: (String val) {
                                       _vehicalNameController.text = val;
                                     },
                                     itemBuilder:
                                         (BuildContext context) {
                                       return global.vechicalList
                                           .map<PopupMenuItem<String>>(
                                               (String val) {
                                             return new PopupMenuItem(
                                                 child: new Text(val),
                                                 value: val);
                                           }).toList();
                                     },
                                   ),
                                 ),
                               ),
                             ],
                           ):
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
                           SizedBox(height: 10,),
                           widget.name == "AllowFrequentlyCab" ?
                           Column(
                             crossAxisAlignment:
                             CrossAxisAlignment.start,
                             children: [
                               Text(
                                 "  Add last 4-digits of vehicle no",
                                 style: TextStyle(
                                     fontWeight: FontWeight.w500),
                               ),
                               SizedBox(
                                 height: 10,
                               ),
                               constantTextField().InputField(
                                   "Enter Vechial no",
                                   "",
                                   validationKey.vehical,
                                   _vehicalNumberController,
                                   false,
                                   IconButton(
                                       icon:
                                       Icon(Icons.directions_car),
                                       onPressed: null),
                                   1,
                                   1,
                                   TextInputType.text,
                                   false),
                             ],
                           ):Container(),
                           SizedBox(height: 10,),
                           InkWell(
                               onTap: () {
                                 showTimePicker(
                                     context: context,
                                     initialTime: TimeOfDay(
                                         hour: DateTime.now().hour,
                                         minute: DateTime.now().minute))
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
                                         icon: Icon(Icons.arrow_drop_down),
                                         onPressed: () {}),
                                     1,
                                     1,
                                     TextInputType.emailAddress,
                                     false),
                               )),
                           SizedBox(
                             height: 10,
                           ),
                           InkWell(
                               onTap: () {
                                 showTimePicker(
                                     context: context,
                                     initialTime: TimeOfDay(
                                         hour: DateTime.now().hour,
                                         minute: DateTime.now().minute))
                                     .then((TimeOfDay value) {
                                   if (value != null) {
                                     _secondTimeController.text =
                                         value.format(context);
                                   }
                                 });
                               },
                               child: IgnorePointer(
                                 child: constantTextField().InputField(
                                     "6:00 am",
                                     "6:00 am",
                                     validationKey.time,
                                     _secondTimeController,
                                     true,
                                     IconButton(
                                       icon: Icon(Icons.arrow_drop_down),
                                       onPressed: () {},
                                     ),
                                     1,
                                     1,
                                     TextInputType.emailAddress,
                                     false),
                               )),
                         ],
                       )
                         ,)
                      ],
                    ),
                  ),

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
      ]),
    );
  }

  _showDayialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Days"),
                SizedBox(height: 5,),
               GestureDetector(
                 onTap: (){
                   setState(() {
                     global.selectDayList = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
                   });
                   Navigator.pop(context);
                 },
                 child:  Card(
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(5)
                     ),
                     elevation: 10,
                     child: Padding(
                       padding: EdgeInsets.all(5),
                       child: Text(
                         "All Days",
                         style: TextStyle(
                             fontWeight: FontWeight.w800, fontSize: 15),
                       ),
                     )),



               ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         global.selectDayList = ['Saturday',"Sunday",];
                       });
                       Navigator.pop(context);
                     },
                     child:  Card(
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(5)
                         ),
                         elevation: 10,
                         child: Padding(
                           padding: EdgeInsets.all(5),
                           child: Text(
                             "Weekend Days",
                             style: TextStyle(
                                 fontWeight: FontWeight.w800, fontSize: 15),
                           ),
                         )),

                   ),
                  GestureDetector(
                    onTap: (){
                     setState(() {
                       global.selectDayList = ['Monday',"Tuesday",'Wednesday','Thursday','Friday'];
                     });
                     Navigator.pop(context);
                    },
                    child:   Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Working Days",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                        )),
                  )
                  ],
                )
              ],
            ),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: 200.0,
              ),
              child: SingleChildScrollView(
                child: MultiSelectChip(
                  global.timeArray,
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      global.selectDayList = selectedList;
                    });
                  },
                ),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text("Ok"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }


  SaveFrequentlyInformation() {
    if (global.formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      if (global.selectDayList.contains('Select Days') || data == "" ) {
        showScaffold("Plz Select Days and validity");


      } else {


      AllowFrequentlyModel allowFrequentlyModel = AllowFrequentlyModel(
        id: Uuid().v1(),
        startTime: _firstTimeController.text,
        endTime: _secondTimeController.text,
        validity: data,
        days: global.selectDayList.join(" , "),
        enable: true,
         companyName: global.companycontroller.text,
          logo: global.companyImagecontroller.text,

        vehicalName: _vehicalNameController.text,
          vehicalNo: _vehicalNumberController.text,
        userId: global.parentId
      );
      Firestore.instance.collection(global.SOCIETY).document(global.mainId)
          .collection(widget.name).document(
          allowFrequentlyModel.id)
          .setData(jsonDecode(jsonEncode(allowFrequentlyModel.toJson())));
      Fluttertoast.showToast(msg: "Delivery added successful");
      global.companycontroller.clear();
      global.companyImagecontroller.clear();
      _firstTimeController.clear();
      _secondTimeController.clear();
      global.selectDayList = [];
      data = "";

    }
    }
  }

   void showScaffold(String message) {
     _scaffoldKey.currentState.showSnackBar(SnackBar(
       content: Text(message),
     ));
   }
}
