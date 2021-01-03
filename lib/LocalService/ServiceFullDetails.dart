import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/MaidModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/Constant/globalsVariable.dart' as globals;
import 'package:residents/ModelClass/UserModel.dart';

class ShowFullDetails extends StatefulWidget {
  final AllService allService;

  const ShowFullDetails({Key key, this.allService}) : super(key: key);

  @override
  _ShowFullDetailsState createState() => _ShowFullDetailsState();
}

class _ShowFullDetailsState extends State<ShowFullDetails> {
  UserData _userData = UserData();

  @override
  void initState() {
    // TODO: implement initState
    _userData = context.bloc<AuthBloc>().getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: UniversalVariables.background,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Text(widget.allService.name),
            Container(
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.width / 2,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl:
                widget.allService.photoUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child:  Row(

                  children: [
                    GestureDetector(
                      onTap: (){
                        addServiceToNotification();
                      },
                      child: Card(
                          color: UniversalVariables.background,
                          child: Padding(
                              padding: EdgeInsets.only(left: 20,right: 20,top: 5,bottom: 5),
                              child: Text("Add",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)
                          )
                      ),
                    ),

                    Card(
                        color: UniversalVariables.background,
                        child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text("Remove",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)
                        )
                    ),
                  ],
                )
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child:  Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: " + widget.allService.name,
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                      ),
                      Text(
                        "MobileNumber: " + widget.allService.mobileNumber,
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                      ),
                      Text(
                        "OtherMobile: " + widget.allService.otherMobileNumber,
                        style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                      ),
                    ],
                  ),
                )
              )
            ),

          ],
        ),
      ),
    );
  }

  addServiceToNotification(){
    Firestore.instance.collection(globals.SOCIETY)
        .document(globals.mainId).collection("HouseDevices").document(_userData.uid).setData({
        widget.allService.service: widget.allService.documentNumber,
        "houseId":globals.parentId,
    },merge: true);
  }
}
