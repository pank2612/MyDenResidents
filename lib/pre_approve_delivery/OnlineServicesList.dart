import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

class OnlineServices extends StatefulWidget {
  @override
  _OnlineServicesState createState() => _OnlineServicesState();
}

class _OnlineServicesState extends State<OnlineServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: UniversalVariables.background,
        title: Text("Local Service"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: StreamBuilder(
            stream: Firestore.instance

                .collection('ServiceName')

                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('loading....');
              return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
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

  Widget optionList(List data,) {
    return Container(
      height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.2,
        child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 0.7,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(data.length, (index) {
              return InkWell(
                onTap: (){
                  Navigator.pop(context);
                   global.companycontroller.text = data[index]['name'];
                  global.companyImagecontroller.text = data[index]['image'];
                },
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black)),
                        height: 70,
                        width: 70,
                        child: Padding(padding: EdgeInsets.all(5),
                          child: FadeInImage.assetNetwork(placeholder: "images/back.png", image: data[index]["image"],fit: BoxFit.cover,)
                        )
                    ),
                    SizedBox(height: 5,),
                    Container(
                      width: 70,
                      child: Text(data[index]['name'],style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 12),),
                    )
                  ],
                ),
              );
            }))
    );
  }
}
