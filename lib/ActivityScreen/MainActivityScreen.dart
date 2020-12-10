import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/ActivityScreen/MessageToGuard.dart';
import 'package:residents/CabScreen/CabTabBarScreen.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/ModelClass/AlertsModel.dart';
import 'package:residents/VisitinHelpForUsers/alert.dart';
import 'package:residents/VisitingHelp/visitingHelpMainScren.dart';

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UniversalVariables.background,
        title: Text("Quick Actions"),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ListView(
              children: [
                Text(
                  "  Allow Future Entry",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                GridView.count(
                    crossAxisCount: 4,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 0.9,
                    children: List.generate(_futureEntry.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: InkWell(
                            onTap: () {
                               _furyreNavigation(index);
                            },
                            child:Container(
                              child:  Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: UniversalVariables.background,
                                      maxRadius: 25,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          _futureEntry[index]["image"],
                                        ),
                                      )
                                  ),
                                  Expanded(
                                    child:
                                      Text(
                                        _futureEntry[index]["name"],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),

                                  )
                                ],
                              ),
                            )

                            ),
                      );
                    })),
                Text(
                  "  Notify Gate",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                GridView.count(
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 1,
                    children: List.generate(_notifyGate.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: InkWell(
                          //splashColor: UniversalVariables.background,
                            onTap: () {
                              _notiFyGateNavigation(index);
                            },
                            child:Container(
                              child:  Column(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: UniversalVariables.background,
                                      maxRadius: 25,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          _notifyGate[index]["image"],
                                        ),
                                      )
                                  ),
                                Container(
                                  width: 70,
                                  child:   Text(
                                    _notifyGate[index]["name"],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                                ],
                              ),
                            )

                        ),
                      );
                    })),
                Text(
                  "  MY Visits",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                GridView.count(
                    crossAxisCount: 3,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(_myVisits.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: InkWell(
                          //splashColor: UniversalVariables.background,
                            onTap: () {
                              // _NavigateScreen(index);
                            },
                            child:Container(
                              child:  Column(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: UniversalVariables.background,
                                      maxRadius: 25,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          _myVisits[index]["image"],
                                        ),
                                      )
                                  ),
                                  Container(
                                    width: 70,
                                    child:   Text(
                                      _myVisits[index]["name"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )

                        ),
                      );
                    })),
              ],
            ),
          )),
    );
  }

  List<Map<String, dynamic>> _futureEntry = [
    {
      'name': 'Cab',
      'image':
          "https://cdn.iconscout.com/icon/premium/png-256-thumb/cab-2294524-1942771.png"
    },
    {
      'name': "Delivery",
      'image':
          "https://www.manageteamz.com/blog/wp-content/uploads/2019/12/Grocery-Delivery.png"
    },
    {
      'name': 'Guest',
      'image':
          "https://ps.w.org/guest-author/assets/icon-256x256.png?rev=2301810"
    },
    {
      'name': "Visiting Help",
      'image':
          "https://cdn.iconscout.com/icon/premium/png-256-thumb/seting-2547123-2136922.png"
    },
  ];

  List<Map<String, dynamic>> _notifyGate = [
    {
      'name': 'Security Alert',
      'image':
      "https://www.evansville.edu/residencelife/images/alertIcon.png"
    },
    {
      'name': "Message To Guard",
      'image':
      "https://cdn.iconscout.com/icon/premium/png-256-thumb/security-guard-16-679122.png"
    },

  ];

  List<Map<String, dynamic>> _myVisits = [
    {
      'name': 'Request Visit Code',
      'image':
      "https://vistapointe.net/images/message-wallpaper-9.jpg"
    },


  ];



  Future<void> _showGuardDialog() async {
    return showDialog<void>(
      context: context,
     // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

              ],
            ),
          ),
          actions: <Widget>[
           Column(
             children: [
               RaisedButton(
                   child: Text('share Code'),
                   onPressed: () {

                   }
               ),
             ],
           )
          ],
        );
      },
    );
  }



  Widget _notiFyGateNavigation (int indexValue) {
    if (indexValue == 0) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => AlertsForUsers (
      )));
    } else if (indexValue == 1) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => MessageToGuard (
      )));
    }
    else {
      return Text("");
    }
  }



  Widget _furyreNavigation (int indexValue) {
    if (indexValue == 0) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => CabTabBar (
      )));
    } else if (indexValue == 1) {
      // Navigator.push(
      //     context, CupertinoPageRoute(builder: (context) => HousesScreen()));
    } else if (indexValue == 2) {
      // Navigator.push(
      //     context, CupertinoPageRoute(builder: (context) => VisitingHelpMainScreen()));
    } else if (indexValue == 3) {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => VisitingHelpMainScreen()));
    }
    else {
      return Text("");
    }
  }

}
