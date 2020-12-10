import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:residents/AlertScreen/AlertMainScreen.dart';
import 'package:residents/AmenityScreen/AmenityMainScreen.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/GateScreen/GateMainScreen.dart';
import 'package:residents/LocalService/LocalServiceScreen.dart';
import 'package:residents/ModelClass/PollsModel.dart';
import 'package:residents/PollsScreen/MainPolllScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residents/ResidentScreen/ResidentMainScreen.dart';
import 'package:residents/ResidentSignIn/activationScreen.dart';
import 'package:residents/VisitorsScreen/VisitorsMainScreen.dart';
import 'package:residents/VrndorsScreen/VendorMainScreen.dart';
import 'package:residents/pre_approve_delivery/allowOnceMainDelivery.dart';

import '../main.dart';
import '../try.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: UniversalVariables.background,
        title: Text("Home Page"),
        actions: [
          IconButton(icon: Icon(Icons.clear), onPressed: (){
            context.bloc<AuthBloc>().signOut().then((value) =>
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp())));
          })
        ],
        leading: IconButton(icon: Icon(Icons.dehaze), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ActivationScreen()));
        }),
      ),
    // drawer: Drawer(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, bottom: 12),
            child: GridView.count(
              crossAxisCount: 3,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children:
              List.generate(_categories.length, (index) {
                return Padding(
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 5),
                  child: InkWell(
                    splashColor: UniversalVariables.background,
                    onTap: () {
                      _NavigateScreen(index);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(15))),
                      elevation: 10,
                      child: Column(
                        children: [
                          Container(
                            child: Image.network(
                              _categories[index]["image"],
                              height: 50,
                              width: 50,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Expanded(
                              child: Padding(padding: EdgeInsets.only(left: 10,right: 6),
                                child: Text(
                                  _categories[index]["name"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),)
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
          )
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _categories = [
    {
      'name': 'Exclusives',

      'image': "https://degoo.com/android-chrome-256x256.png?v=3eB5GjaPya"
    },
    {
      'name': "Covid Protect",

      'image':
      "https://cdn.iconscout.com/icon/premium/png-256-thumb/face-mask-2682218-2229278.png"
    },
    {
      'name': 'Security Alert',

      'image':
      "https://cdn.iconscout.com/icon/premium/png-256-thumb/security-alert-2010754-1694142.png"
    },
    {
      'name': "Pre-approve Delivery",

      'image':
      "https://www.manageteamz.com/blog/wp-content/uploads/2019/12/Grocery-Delivery.png"
    },
    {
      'name': 'Local Services',

      'image': "https://mclean.co.in/homeservices/wp-content/uploads/2020/04/trained-personnel.png"
    },
    {
      'name': "Residents",

      'image':
      "https://1.bp.blogspot.com/-0RGtO6ZR8nQ/XrISty1b7yI/AAAAAAABD9g/U_F3amGLaVkpqZdKLklYzzo8mqBE5VhhQCNcBGAsYHQ/s1600/Discussion.png"
    },
    {
      'name': "Polls",
      'image': "https://www.shareicon.net/data/2015/06/05/49543_polls_256x256.png"
    },
    {
      'name': 'Gates',
      'image':
      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcS56SSZe6mbCuAnwJE6HKwUrbfHZEF6vgr5fw&usqp=CAU"
    },
    {
      'name': 'Vendors',
      'image': "https://image.flaticon.com/icons/png/128/79/79565.png"
    },
    {
      'name': "Amenity",
      'image':
      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSGQYakY1YcSEBpAdQe7tXM7-zq7IyHrctlTg&usqp=CAU"
    },
    {
      'name': "Visitor's Details",
      'image':
      "https://authorisedvisitor.com/img/visitors/people.png"
    },


  ];

  Widget _NavigateScreen(int indexValue) {
    if (indexValue == 0) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => PinCodeTextField()));
    } else if (indexValue == 1) {
      // Navigator.push(
      //     context, CupertinoPageRoute(builder: (context) => HousesScreen()));
    } else if (indexValue == 2) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => newAlert()));
    } else if (indexValue == 3) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => AllowOnceDelivery()));
    } else if (indexValue == 4) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => LocalService()));
    } else if (indexValue == 5) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => HousesScreen()));
    } else if (indexValue == 6) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => mainPollScreen()));
    } else if (indexValue == 7) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => GatesScreen()));
    } else if (indexValue == 8) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => VendorsScreen()));
    } else if (indexValue == 9) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => AmenityScreen()));
    }else if (indexValue == 10) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => Visitors()));
    }

    else {
      return Text("");
    }
  }



}

