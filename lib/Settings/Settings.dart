import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

class PreapproveNotification extends StatefulWidget {
  @override
  _PreapproveNotificationState createState() => _PreapproveNotificationState();
}

class _PreapproveNotificationState extends State<PreapproveNotification> {

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: UniversalVariables.background,
        title: Text("Local Service"),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: StreamBuilder(
            stream: Firestore.instance.collection('ServiceName').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('loading....');
              return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                 // physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(
                        context, snapshot.data.documents[index]);
                  });
            }),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: optionList(document["OnlineDelivery"]));
  }

  Widget optionList(
    List data,
  ) {
    print(data.length);
    return Padding(padding: EdgeInsets.all(30),
    child: Container(
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black)),
                          height: 50,
                          width: 50,
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: FadeInImage.assetNetwork(
                                placeholder: "images/back.png",
                                image: data[index]["image"],
                                fit: BoxFit.cover,
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 70,
                        child: Text(
                          data[index]['name'],
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      Divider()
                    ],
                  ),
                  Column(
                    children: [
                      Switch(
                        value: isSwitched,
                        onChanged: (value){
                          setState(() {
                            isSwitched = value;
                          });

                        },
                        activeTrackColor: Colors.grey,
                        activeColor: UniversalVariables.background,
                      ),
                      SizedBox(height: 30)

                    ],
                  )

                ],
              );
            })
    )
    );


  }

  toggleButton(){
   setState(() {
     isSwitched = !isSwitched;
   });
  }



}
