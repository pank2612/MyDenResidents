import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/PollsModel.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

class PollsGiven extends StatefulWidget {
  final Polls polls;

  const PollsGiven({Key key, this.polls}) : super(key: key);

  @override
  _PollState createState() => _PollState();
}

class _PollState extends State<PollsGiven> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String selectedValue = "";


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
        backgroundColor: UniversalVariables.background,
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Card(
                child: Column(
                  children: [
                    Text(
                      "Poll Topic: " + widget.polls.pollName,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic),
                    ),
                    optionList(widget.polls.options, widget.polls.pollsId,
                        widget.polls.pollName),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RaisedButton(
                          onPressed: () {
                           _showDialog(widget.polls.pollsId,);
                          },
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: UniversalVariables.ScaffoldColor),
                          ),
                          color: UniversalVariables.background,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget optionList(
    List data,
    var pollsId,
    var pollsTopic,
  ) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    data[index],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  leading: Radio(
                    value: data[index],
                    groupValue: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    activeColor: UniversalVariables.background,
                  ),
                );
              }),
        ),

      ],
    );
  }


  Future<void> _showDialog(
      // var pollOptions,
       var pollsId,
      ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Poll'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  selectedValue,
                  style: TextStyle(color: UniversalVariables.background),
                )
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              elevation: 10,
              color: UniversalVariables.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: UniversalVariables.ScaffoldColor)),
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              elevation: 10,
              color: UniversalVariables.background,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: UniversalVariables.ScaffoldColor)),
              child: Text('Yes'),
              onPressed: () {
                voting(pollsId,);
                Navigator.pop(context);
                showScaffold('Thanks For Voting');
              },
            ),
          ],
        );
      },
    );
  }
  voting(var pollsId, ) {
    print("call to voting function");
    Firestore.instance
        .collection(global.SOCIETY)
        .document(global.mainId)
        .collection("Polls")
        .document(pollsId.toString())
        .collection("ResidentPolls")
        .document(global.parentId)
        .setData({"VoteAns": selectedValue});
  }

}
