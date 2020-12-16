import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'AddHouse.dart';
import 'package:flutter_bloc/flutter_bloc.dart';








class HousesScreen extends StatefulWidget {
  @override
  _HousesScreenState createState() => _HousesScreenState();
}

class _HousesScreenState extends State<HousesScreen> {
   List<UserData> userDataList = List<UserData>();
  bool isLoading = false;
   DocumentSnapshot lastDocument = null;

   UserData _userData = UserData();

  @override
  void initState() {
    _userData = context.bloc<AuthBloc>().getCurrentUser();
    getHouseMembers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Houses',
          style: TextStyle(color: UniversalVariables.ScaffoldColor),
        ),
        backgroundColor: UniversalVariables.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:

      Stack(children: [

        Column(children: [
          SizedBox(
            height: 10,
          ),

          Expanded(
            child: userDataList.length == 0
                ? Center(
              child: Text("No data"),
            )
                : ListView.builder(

              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12,),
                  child:   Card(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userDataList[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Container(
                                    decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(70)),
                                    height: 70,
                                    width: 70,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(70),
                                        child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(70),
                                                child: userDataList[index].profilePhoto == null ||
                                                    userDataList[index].profilePhoto == ""
                                                    ? Image.network(
                                                    "https://icon-library.com/images/person-image-icon/person-image-icon-6.jpg")
                                                    :
                                                Image.network(userDataList[index].profilePhoto)
                                            )))),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    userDataList[index].phoneNo == null || userDataList[index].phoneNo == ""
                                        ? Text("Update Yor Mobile Number")
                                        :
                                    Text(
                                        userDataList[index].phoneNo)
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )),


                );
              },
            ),
          ),
          isLoading
              ? Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(5),
            color: UniversalVariables.background,
            child: Text(
              'Loading......',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: UniversalVariables.ScaffoldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Container()
        ]),
      ]),

      floatingActionButton: (FloatingActionButton(
        onPressed: () {
          navigateSecondPage();
        },
        child: Icon(Icons.add),
      )),
    );
  }




  getHouseMembers()  {
    QuerySnapshot querySnapshot;
    Firestore.instance.collection(global.SOCIETY).document(global.mainId)
        .collection(global.HOUSES).document(global.parentId)
        .collection("members")
        .where("enable",isEqualTo: true)
        .getDocuments().then((value) {
          value.documents.forEach((element) async {
            print(element['id']);
            querySnapshot = await
            Firestore.instance
                .collection("users")
                .where("id",isEqualTo: element['id'])
                .getDocuments();
            if (querySnapshot.documents.length != 0) {
              lastDocument =
              querySnapshot.documents[querySnapshot.documents.length - 1];
              print("final data");
              setState(() {
                querySnapshot.documents.forEach((element) {
                  var userData = UserData();
                  userData = UserData.fromMap(element.data);
                  userDataList.add(userData);
                });
              });
            }

          }
          );


    });
  }


  FutureOr onGoBack(dynamic value) {
    print("On call back");
  }

  void navigateSecondPage() {
    Route route = CupertinoPageRoute(builder: (context) => AddHouseScreen());
    Navigator.push(context, route).then(onGoBack);
  }
}
