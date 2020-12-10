// import 'dart:convert';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:residents/Bloc/AuthBloc.dart';
// import 'package:residents/Constant/Constant_Color.dart';
// import 'package:residents/Constant/constantTextField.dart';
// import 'package:residents/Constant/globalsVariable.dart' as global;
// import 'package:residents/ModelClass/AllowOnceDelivery.dart';
// import 'package:residents/ModelClass/UserModel.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// class AddAllowOnceCab extends StatefulWidget {
//   @override
//   _AddAllowOnceState createState() => _AddAllowOnceState();
// }
//
// class _AddAllowOnceState extends State<AddAllowOnceCab> {
//   TextEditingController _allowOnceDateController = TextEditingController();
//   TextEditingController _allowOnceTimeController = TextEditingController();
//   TextEditingController _allowOnceHourController = TextEditingController();
//   bool isLoading = false;
//   bool leavePackageAtGate = false;
//
//   Future<Null> _selectDate(BuildContext context, DateTime firstDate,
//       DateTime lastDate) async {
//     DateTime selectedDate = firstDate;
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: firstDate,
//         lastDate: lastDate);
//     if (picked != null) // && picked != selectedDate)
//       selectedDate = picked;
//     String _formattedate =
//     new DateFormat(global.dateFormat).format(selectedDate);
//     setState(() {
//       _allowOnceDateController.value = TextEditingValue(text: _formattedate);
//     });
//   }
//
//   @override
//   void initState() {
//    // _userData = context.bloc<AuthBloc>().getCurrentUser();
//     global.companyImagecontroller.clear();
//     global.companycontroller.clear();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: UniversalVariables.background,
//           title: Text("Allow Once Cab"),
//           leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){Navigator.pop(context);}),
//         ),
//         body: ListView(children: [
//           SizedBox(
//               height: 50
//           ),
//           Padding(
//             padding: EdgeInsets.all(15),
//             child: Card(
//                 shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//
//                   children: [
//                     Padding(
//                         padding: EdgeInsets.all(15),
//                         child: Form(
//                           key: global.formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Allow Cab to enter today once in Society",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.w800),
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   _selectDate(
//                                       context,
//                                       DateTime.now().subtract(Duration(days: 0)),
//                                       DateTime.now().add(Duration(days: 365)));
//                                 },
//                                 child: IgnorePointer(
//                                     child: constantTextField().InputField(
//                                         "Enter Date",
//                                         "",
//                                         validationKey.date,
//                                         _allowOnceDateController,
//                                         true,
//                                         IconButton(
//                                           icon: Icon(Icons.calendar_today),
//                                           onPressed: () {},
//                                         ),
//                                         1,
//                                         1,
//                                         TextInputType.name,
//                                         false)),
//                               ),
//
//                               SizedBox(height: 20,),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: InkWell(
//                                         onTap: () {
//                                           showTimePicker(
//                                               context: context,
//                                               initialTime: TimeOfDay(
//                                                   hour: DateTime
//                                                       .now()
//                                                       .hour,
//                                                   minute: DateTime
//                                                       .now()
//                                                       .minute))
//                                               .then((TimeOfDay value) {
//                                             if (value != null) {
//                                               _allowOnceTimeController.text =
//                                                   value.format(context);
//                                             }
//                                           });
//                                         },
//                                         child: IgnorePointer(
//                                           child: constantTextField().InputField(
//                                               "9:00 pm",
//                                               "",
//                                               validationKey.time,
//                                               _allowOnceTimeController,
//                                               true,
//                                               IconButton(
//                                                   icon: Icon(Icons.arrow_drop_down),
//                                                   onPressed: () {}),
//                                               1,
//                                               1,
//                                               TextInputType.emailAddress,
//                                               false),
//                                         )),
//
//                                   ),
//                                   SizedBox(width: 20,),
//                                   Expanded(
//                                     child: Stack(
//                                       children: [
//                                         IgnorePointer(
//                                           child: constantTextField().InputField(
//                                               "1 hour",
//                                               "",
//                                               validationKey.time,
//                                               _allowOnceHourController,
//                                               false,
//                                               IconButton(
//                                                 icon: Icon(Icons.arrow_back_ios),
//                                                 onPressed: () {},
//                                               ),
//                                               1,
//                                               1,
//                                               TextInputType.name,
//                                               false),
//                                         ),
//                                         Positioned(
//                                           right: 0,
//                                           child: Container(
//                                             alignment: Alignment.centerRight,
//                                             child: PopupMenuButton<String>(
//                                               icon: const Icon(
//                                                   Icons.arrow_downward),
//                                               onSelected: (String val) {
//                                                 _allowOnceHourController.text = val;
//                                               },
//                                               itemBuilder: (BuildContext context) {
//                                                 return
//                                                   global.hourList
//                                                       .map<PopupMenuItem<String>>((
//                                                       String val) {
//                                                     return new PopupMenuItem(
//                                                         child: new Text(val),
//                                                         value: val);
//                                                   }
//                                                   ).toList();
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//
//                                 ],
//                               ),
//                            SizedBox(height: 20,),
//                                   Text("  Add last 4-digits of vehicle no",style: TextStyle(
//                                       fontWeight: FontWeight.w500
//                                   ),),
//                                   SizedBox(height: 10,),
//                                   constantTextField().InputField(
//                                       "6767 ",
//                                       "",
//                                       validationKey.date,
//                                       _allowOnceDateController,
//                                       false,
//                                       IconButton(
//                                         icon: Icon(Icons.calendar_today),
//                                         onPressed: () {},
//                                       ),
//                                       1,
//                                       1,
//                                       TextInputType.name,
//                                       false),
//
//                               SizedBox(height: 20,),
//                               InkWell(
//                                 onTap: () {
//                                   // Navigator.push(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //         builder: (context) => OnlineServices()));
//                                 },
//                                 child: IgnorePointer(
//                                   child: constantTextField().InputField(
//                                       "CompanyName",
//                                       "",
//                                       validationKey.companyName,
//                                       global.companycontroller,
//                                       false,
//                                       IconButton(icon: Icon(Icons.directions_car),
//                                           onPressed: null),
//                                       1,
//                                       1,
//                                       TextInputType.text,
//                                       false),
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         SaveAllowOnceInformation();
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(20.0),
//                             bottomRight: Radius.circular(20.0),
//                           ),
//                           color: UniversalVariables.background,
//                         ),
//                         child: Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(8),
//                               child: Icon(
//                                 Icons.done,
//                                 size: 30,
//                                 color: UniversalVariables.ScaffoldColor,
//                               ),
//                             )),
//                       ),
//                     )
//                   ],
//                 )),
//           )
//         ])
//     );
//   }
//   SaveAllowOnceInformation() {
//     if (global.formKey.currentState.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//       AllowOnce allowOnce = AllowOnce(
//         id: Uuid().v1(),
//         inviteDate: DateFormat(global.dateFormat).parse(
//             _allowOnceDateController.text),
//         time: _allowOnceTimeController.text,
//         hour: _allowOnceHourController.text,
//         leavePackage: leavePackageAtGate,
//         companyName: global.companycontroller.text,
//         enable: true,
//         logo:global.companyImagecontroller.text,
//         residentId:global.parentId,
//       );
//       Firestore.instance.collection(global.SOCIETY).document(global.mainId)
//           .collection("AllowOnceDelivery").document(allowOnce.id)
//           .setData(jsonDecode(jsonEncode(allowOnce.toJson())));
//       Fluttertoast.showToast(msg: "Delivery added successful");
//       _allowOnceTimeController.clear();
//       _allowOnceHourController.clear();
//       _allowOnceDateController.clear();
//       global.companycontroller.clear();
//       global.companyImagecontroller.clear();
//
//     }
//   }
// }
