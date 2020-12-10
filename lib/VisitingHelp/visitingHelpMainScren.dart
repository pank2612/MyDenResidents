import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';

import 'VisitingHelpTabBarScreen.dart';

class VisitingHelpMainScreen extends StatefulWidget {
  @override
  _VisitingHelpMainScreenState createState() => _VisitingHelpMainScreenState();
}

class _VisitingHelpMainScreenState extends State<VisitingHelpMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalVariables.background,
        title: Text("Visiting Help"),
      ),
      body: Padding(padding: EdgeInsets.all(15),
      child: ListView.builder(
          itemCount: _myVisits.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> VisitingTabBar(
                  name: _myVisits[index]['name'],
                )));
              },
              child: Card(
                  elevation: 2,
                  child: Padding(padding: EdgeInsets.all(10),
                      child: Text(_myVisits[index]['name'],style: TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w800,fontStyle: FontStyle.italic),)
                  )
              ),
            );
          }),
      )
    );
  }

  List<Map<String, dynamic>> _myVisits = [
    {
      'name': 'Home repair',
    },
    {
      'name': 'Appliance repair',
    }, {
      'name': 'Internet repair',
    }, {
      'name': 'Beautician',
    }, {
      'name': 'Tutor',
    }, {
      'name': 'Others',
    },


  ];
}

