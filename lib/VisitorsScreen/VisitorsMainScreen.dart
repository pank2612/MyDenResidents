import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/constantTextField.dart';
import 'package:residents/VisitorsScreen/expected.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

import 'GetExpectedVisitors.dart';
import 'VisitorHistory.dart';

class Visitors extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<Visitors>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _firstDateController = TextEditingController();
  TextEditingController _secondDateController = TextEditingController();
  DateTime getSelectedStartDate = DateTime.now();
  bool isLoading = false;
  @override
  void initState() {
    print(DateTime.now());
    _tabController = new TabController(length: 2, vsync: this);
    // TODO: implement initState
    super.initState();
  }


  Future<Null> _selectDate(BuildContext context, DateTime firstDate,
      DateTime lastDate, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null)
      setState(() {
        isLoading = true;
        String formatDate = new DateFormat(global.dateFormat).format(picked);
        getSelectedStartDate = picked;
        _firstDateController.value = TextEditingValue(text: formatDate);
      });
  }

  Future<Null> _selectEndDate(BuildContext context, DateTime firstDate,
      DateTime lastDate, DateTime selectedDate) async {
    print(selectedDate);

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: getSelectedStartDate,
        lastDate: lastDate);
    if (picked != null)
      setState(() {
        isLoading = true;
        String formatDate = new DateFormat(global.dateFormat).format(picked);
        _secondDateController.value = TextEditingValue(text: formatDate);
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          automaticallyImplyLeading: false,
          title: Text(
            "Visitor's Details",
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: [
              Tab(
                child: Text(
                  "Expected",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Tab(
                child: Text(
                  "Historical",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          bottomOpacity: 1,
        ),
        body: TabBarView(
          children: [

            GetExpectedVisitors(),
            visitorHistory(),
          ],
          controller: _tabController,
        ));
  }

  Widget visitorHistory(){
    return ListView(
      children: [

        SizedBox(
          height: 50
        ),
        Padding(padding: EdgeInsets.all(15),
         child: Card(
           elevation: 10,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(20)
           ),
           child: Column(
             children: [
               Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(20.0),
                     topRight: Radius.circular(20.0),
                   ),
                   color: UniversalVariables.background,
                 ),
                 child: Center(
                     child: Padding(
                       padding: EdgeInsets.all(8),
                       child: Icon(
                         Icons.done,
                         size: 30,
                         color: UniversalVariables.background,
                       ),
                     )),
               ),
               Padding(padding: EdgeInsets.all(15),
                 child: Form(
                   key: global.formKey,
                   child: Column(
                     children: [
                       Text("Select Date to see history of visitors",style: TextStyle(
                         fontSize: 20,fontWeight: FontWeight.w800,fontStyle: FontStyle.italic
                       ),),
                       SizedBox(height: 30,),
                       InkWell(
                         onTap: () {
                           _selectDate(
                               context,
                               DateTime.now().subtract(Duration(days: 365)),
                               DateTime.now().subtract(Duration(days: 1)),
                               DateTime.now().subtract(Duration(days: 31)));
                         },
                         child: IgnorePointer(
                             child: constantTextField().InputField(
                                 "Enter Date",
                                 "",
                                 validationKey.date,
                                 _firstDateController,
                                 true,
                                 IconButton(
                                   icon: Icon(Icons.calendar_today),
                                   onPressed: () {},
                                 ),
                                 1,
                                 1,
                                 TextInputType.name,
                                 false)),
                       ),
                       SizedBox(
                         height: 20,
                       ),
                       InkWell(
                         onTap: () {
                           _selectEndDate(
                               context,
                               DateTime.now()
                                   .subtract(Duration(days: 365)),
                               DateTime.now(),
                               DateTime.now());
                         },
                         child: IgnorePointer(
                             child: constantTextField().InputField(
                                 "Enter Date",
                                 "",
                                 validationKey.date,
                                 _secondDateController,
                                 true,
                                 IconButton(
                                   icon: Icon(Icons.calendar_today),
                                   onPressed: () {},
                                 ),
                                 1,
                                 1,
                                 TextInputType.name,
                                 false)),
                       ),

                     ],
                   ),
                 ),
               ),
               SizedBox(height: 30,),
               InkWell(
                 onTap: () {
                   SaveInformation();
                 },
                 child: Container(
                   clipBehavior: Clip.antiAlias,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.only(
                       bottomLeft: Radius.circular(20.0),
                       bottomRight: Radius.circular(20.0),
                     ),
                     color: UniversalVariables.background,
                   ),
                   child: Center(
                       child: Padding(
                         padding: EdgeInsets.all(10),
                         child: Text(
                           "History",
                           style: TextStyle(fontSize: 20,
                             color: UniversalVariables.ScaffoldColor,fontWeight: FontWeight.w800
                           ),

                         ),
                       )),
                 ),
               )
             ],
           ),
         ),
        ),

      ],
    );
  }
  SaveInformation(){
    if(global.formKey.currentState.validate()){
      setState(() {

        isLoading = true;
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => VisitorHistory(
                  startDate: _firstDateController.text,
                  endDate: _secondDateController.text,
                )));

      });

    }
  }
}
