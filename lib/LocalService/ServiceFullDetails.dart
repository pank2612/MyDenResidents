import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/MaidModel.dart';

class ShowFullDetails extends StatefulWidget {
  final AllService allService;

  const ShowFullDetails({Key key, this.allService}) : super(key: key);

  @override
  _ShowFullDetailsState createState() => _ShowFullDetailsState();
}

class _ShowFullDetailsState extends State<ShowFullDetails> {
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
            )
          ],
        ),
      ),
    );
  }
}
