//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:residents/Constant/Constant_Color.dart';
// import 'package:residents/Constant/globalsVariable.dart';
// import 'package:residents/Constant/globalsVariable.dart' as global;
// import 'package:residents/ModelClass/AllowOnceDelivery.dart';
//
//
// class VisitingHelpTabBar extends StatefulWidget {
//   final name;
//
//   const VisitingHelpTabBar({Key key, this.name}) : super(key: key);
//   @override
//   _AllowOnceDeliveryState createState() => _AllowOnceDeliveryState();
// }
//
// class _AllowOnceDeliveryState extends State<VisitingHelpTabBar>
//     with SingleTickerProviderStateMixin {
//   List<AllowOnce> allowOnceList = List<AllowOnce>();
//   DocumentSnapshot lastDocument = null;
//
//
//   TabController _tabController;
//   bool isLoading = false;
//   bool leavePackageAtGate = false;
//
//   @override
//   void initState() {
//
//
//
//     global.companycontroller.clear();
//     selectedReportList = ["Select Day"];
//     _tabController = new TabController(length: 2, vsync: this);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: UniversalVariables.background,
//           title: Text("Pre Approve Delivery"),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           bottom: TabBar(
//             unselectedLabelColor: Colors.white,
//             labelColor: Colors.amber,
//             tabs: [
//               Tab(
//                 child: Text(
//                   "Allow Once",
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   "Allow Frequently",
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//             ],
//             controller: _tabController,
//             indicatorColor: Colors.white,
//             indicatorSize: TabBarIndicatorSize.tab,
//           ),
//           bottomOpacity: 1,
//         ),
//         body: TabBarView(
//           children: [
//             Text("xbx"),
//
//             Text("xbx")
//           ],
//           controller: _tabController,
//         ));
//   }}