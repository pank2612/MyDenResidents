import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';

import 'addExpected.dart';
class Expected extends StatefulWidget {
  @override
  _ExpectedState createState() => _ExpectedState();
}

class _ExpectedState extends State<Expected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: UniversalVariables.background,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddExpected()));
          }),
    );
  }
}
