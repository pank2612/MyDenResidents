import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:residents/Bloc/AuthBloc.dart';
import 'package:residents/Constant/Constant_Color.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;
import 'package:residents/LocalService/LocalServiceScreen.dart';
import 'package:residents/LocalService/ServiceFullDetails.dart';
import 'package:residents/ModelClass/HouseModel.dart';
import 'package:residents/ModelClass/MaidModel.dart';
import 'package:residents/ModelClass/UserModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  UserData _userData = UserData();
  List<UserData> userDataList = List<UserData>();
  List<AllService> allServiceList = List<AllService>();
  List<House> houseList = List<House>();

  bool isLoading = false;
  DocumentSnapshot lastDocument = null;

  @override
  void initState() {
    super.initState();
    getHouseMembers();
    getHouseAllService();
    _userData = context.bloc<AuthBloc>().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: UniversalVariables.backgroundThree,
        appBar: AppBar(
          backgroundColor: UniversalVariables.background,
          title: Text(
            global.flatNo,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(0),
          child: ListView(
            children: [
             Padding(padding: EdgeInsets.all(10),
             child:  Card(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(15)),
                 child: Padding(
                   padding: EdgeInsets.all(15),
                   child: Column(
                     children: [
                       Row(
                         children: [
                           Container(
                               height: 70,
                               width: 70,
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(70),
                                 child: Image.network(_userData.profilePhoto),
                               )),
                           SizedBox(
                             width: 20,
                           ),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 _userData.name,
                                 style: TextStyle(fontSize: 20),
                               ),
                               Text(
                                 "(Me)",
                                 style: TextStyle(fontSize: 20),
                               )
                             ],
                           )
                         ],
                       ),
                       Row(
                         children: [
                           Icon(
                             Icons.send,
                             size: 20,
                           ),
                           SizedBox(
                             width: 10,
                           ),
                           Text("Share My Address")
                         ],
                       )
                     ],
                   ),
                 )),
             ),
              SizedBox(
                height: 10,
              ),
            Padding(padding: EdgeInsets.only(left: 15,right: 15),
             child:   Row(
              children: [
                Text(
                  "MY FAMILY",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //         builder: (context) => LocalService()));
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: UniversalVariables.background,
                      ),
                      Text(
                        "ADD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: UniversalVariables.background,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            ),
              Container(
                height: MediaQuery.of(context).size.width / 2.6,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: userDataList.length,
                    itemBuilder: (context, index) {
                      return
                        InkWell(
                          onTap: (){
                            // Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //         builder: (context) => ShowFullDetails(
                            //           allService: allServiceList[index],
                            //         )));
                          },
                          child:  Row(
                            children: [
                              SizedBox(width: 10,),
                              Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 5),
                                      child: Column(
                                        children: [
                                          Container(
                                              height: 70,
                                              width: 70,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(70),
                                                child: CachedNetworkImage(
                                                  placeholder:
                                                      (context, url) =>
                                                      Container(
                                                        child:
                                                        CircularProgressIndicator(
                                                          valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                              UniversalVariables
                                                                  .background),
                                                        ),
                                                        width: 50.0,
                                                        height: 50.0,
                                                      ),
                                                  imageUrl:
                                                  userDataList[index]
                                                      .profilePhoto,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                3.88,
                                            child: Text(userDataList[index].name,
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,textAlign: TextAlign.center,),
                                          ),
                                          // Container(
                                          //   width: MediaQuery.of(context)
                                          //       .size
                                          //       .width /
                                          //       3.88,
                                          //   child: Text(allServiceList[index].service,
                                          //     style: TextStyle(fontSize: 13),
                                          //     overflow: TextOverflow.ellipsis,
                                          //     maxLines: 1,textAlign: TextAlign.center,),
                                          // ),
                                          SizedBox(height: 4,),
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  3.88,
                                              child: FittedBox(
                                                child: Row(
                                                  children: [
                                                    OutlineButton(
                                                      onPressed: () {},
                                                      child: Icon(
                                                        Icons.phone,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    OutlineButton(
                                                      onPressed: () {},
                                                      child: Icon(Icons.share),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ))),
                            ],
                          )
                        );


                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(padding: EdgeInsets.only(left: 15,right: 15),
              child:  Row(
                  children: [
                    Text(
                      "MY SERVICE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => LocalService()));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: UniversalVariables.background,
                          ),
                          Text(
                            "ADD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: UniversalVariables.background,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                  height: MediaQuery.of(context).size.width / 2.4,
                  child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: allServiceList.length,
                          itemBuilder: (context, index) {
                            return
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ShowFullDetails(
                                          allService: allServiceList[index],
                                        )));
                              },
                              child:  Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          child: Column(
                                            children: [
                                             Stack(
                                               children: [
                                                 Container(
                                                     height: 70,
                                                     width: 70,
                                                     child: ClipRRect(
                                                       borderRadius:
                                                       BorderRadius.circular(70),
                                                       child: CachedNetworkImage(
                                                         placeholder:
                                                             (context, url) =>
                                                             Container(
                                                               child:
                                                               CircularProgressIndicator(
                                                                 valueColor:
                                                                 AlwaysStoppedAnimation<
                                                                     Color>(
                                                                     UniversalVariables
                                                                         .background),
                                                               ),
                                                               width: 50.0,
                                                               height: 50.0,
                                                             ),
                                                         imageUrl:
                                                         allServiceList[index]
                                                             .photoUrl,
                                                         fit: BoxFit.cover,
                                                       ),
                                                     )),
                                                Positioned(
                                                    bottom: 3,
                                                    right: 3,
                                                    child:
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(70),
                                                    color: allServiceList[index].passwordEnable == true ? Colors.green :Colors.grey,
                                                  ),
                                                  height: 15,
                                                  width: 15,

                                                )),
                                                 Text(allServiceList[index].passwordEnable.toString())
                                               ],
                                             ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    3.88,
                                                child: Text(allServiceList[index].name,
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,textAlign: TextAlign.center,),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    3.88,
                                                child: Text(allServiceList[index].service,
                                                  style: TextStyle(fontSize: 13),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,textAlign: TextAlign.center,),
                                              ),
                                              SizedBox(height: 4,),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      3.88,
                                                  child: FittedBox(
                                                    child: Row(
                                                      children: [
                                                        OutlineButton(
                                                          onPressed: () {},
                                                          child: Icon(
                                                            Icons.phone,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                        OutlineButton(
                                                          onPressed: () {},
                                                          child: Icon(Icons.share),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          ))),
                                ],
                              )
                            );


                          }),
              )
            ],
          ),
        ));
  }



  getHouseAllService() async {

    Firestore.instance
        .collection(global.SOCIETY)
        .document(global.mainId)
        .collection(global.HOUSES)
        .document(global.parentId)
        .get()
        .then((value) {
      print("value nnnnn ${value}");
      print("data is ---${value.data[""]}");
      value.data["LocalService"].forEach((value) {
        print("value is ${value}");
        if (value['enable'] == true) {
        Localservices localService = Localservices(
            enable: value['enable'],
            service: value['service'],
            id: value['id']);
        print("local services dats  ${localService.id}");
        getLocalServices(lastDocument,localService.id);
      }
      });
    });
  }





  getLocalServices(DocumentSnapshot _lastDocument,String id) async {
    allServiceList.clear();
    QuerySnapshot querySnapshot;
    if (_lastDocument == null) {
      querySnapshot = await Firestore.instance
      .collection(global.SOCIETY).document(global.mainId)
          .collection('LocalServices')
          .where("documentNumber",isEqualTo:id )
          // .where()
          .getDocuments();
      if (querySnapshot.documents.length != 0) {
        setState(() {
          querySnapshot.documents.forEach((element) {
            var allService = AllService();
            allService = AllService.fromJson(element.data);
            allServiceList.add(allService);
            print(allService.photoUrl);
          });
        });
      }
    }
  }


  getHouseMembers()  {
    print("aaaaa");
    QuerySnapshot querySnapshot;
    Firestore.instance.collection(global.SOCIETY).document(global.mainId)
        .collection(global.HOUSES).document(global.parentId)
        .collection("members")
        .where("enable",isEqualTo: true)
        .getDocuments().then((value) {
      value.documents.forEach((element) async {
        if(element['id'] != context.bloc<AuthBloc>().getCurrentUser().uid){
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
                print("hjdfs");
                print(userDataList.length);
              });
            });
          }
        }
      }
      );
    });
  }
}
