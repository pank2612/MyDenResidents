import 'package:flutter/material.dart';
import 'package:residents/Constant/globalsVariable.dart' as global;

class UserData {
  String uid;
  String name;
  String email;
  String phoneNo;

  String gender;
  String token;
  String profilePhoto;
  List<AccessList> accessList;
  bool emailVerified;

  UserData(
      {this.uid,
      this.name,
      this.email,
      this.phoneNo,
      this.gender,
      this.token,
      this.profilePhoto,
      this.accessList,
      this.emailVerified});

  Map toJson() {
    var data = Map<String, dynamic>();
    data['id'] = this.uid;
    data['nickname'] = this.name;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;

    data["gender"] = this.gender;
    data["token"] = this.token;
    data["photoUrl"] = this.profilePhoto;
    //final Map<String, dynamic> data = new Map<String, dynamic>();
    // if (this.accessList != null) {
    //   data['accessList'] = this.accessList.map((v) => v.toMap(v)).toList();
    // }
    return data;
  }

  UserData.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['id'];
    this.name = mapData['nickname'];
    this.email = mapData['email'];
    this.phoneNo = mapData['phoneNo'];

    this.gender = mapData['gender'];
    this.token = mapData['token'];
    this.profilePhoto = mapData['photoUrl'];
    if (mapData['accessList'] != null) {
      List<AccessList> mainAccessList = List<AccessList>();
      for (int i = 0; i < mapData['accessList'].length; i++) {
        if (mapData['accessList'][i]['type'] == global.appType) {
          print(mapData['accessList'][i]['id']);
          AccessList accessList = AccessList();
          accessList.id = mapData['accessList'][i]['id'];
          accessList.type = mapData['accessList'][i]['type'];
          accessList.status = mapData['accessList'][i]["status"];
          accessList.societyName = mapData['accessList'][i]['societyName'];
          accessList.residentId = mapData['accessList'][i]['residentId'];
          accessList.flatNo = mapData['accessList'][i]['flatNo'];
          accessList.token = mapData['accessList'][i]['token'];
          print(accessList);
          mainAccessList.add(accessList);
        }
      }
      this.accessList = mainAccessList;
    }
  }
}

class AccessList {
  String id;
  bool status;
  String type;
  String societyName;
  String residentId;
  String flatNo;
  String token;

  AccessList({
    this.id,
    this.status,
    this.type,
    this.societyName,
    this.residentId,
    this.flatNo,
    this.token,
  });

  Map toMap(AccessList obj) {
    var data = Map<String, dynamic>();
    data['id'] = obj.id;
    data['status'] = obj.status;
    data['type'] = obj.type;
    data['flatNo'] = obj.flatNo;
    data['societyName'] = obj.societyName;
    data['residentId'] = obj.residentId;
    data['token'] = obj.token;

    return data;
  }

  AccessList.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['id'];
    this.status = mapData['status'];
    this.type = mapData['type'];
    this.flatNo = mapData['flatNo'];
    this.societyName = mapData['societyName'];
    this.residentId = mapData['residentId'];
    this.token = mapData['token'];
  }
}

