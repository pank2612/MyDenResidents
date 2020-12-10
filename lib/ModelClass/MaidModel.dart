
import 'dart:io';

class AllService {
  String name;
  String mobileNumber;
  String otherMobileNumber;
  DateTime startDate;
  String photoUrl;
  String dutyTiming;
  bool enable;
  String documentNumber;
  String documentType;

  String service;



  AllService({ this.name, this.mobileNumber, this.otherMobileNumber, this.startDate,
    this.photoUrl, this.dutyTiming,this.enable,this.documentNumber,this.service,this.documentType});

  AllService.fromJson(Map<String, dynamic> json)
      :
        name = json['name'],
        documentType = json['documentType'],
        mobileNumber = json['mobileNumber'],
        otherMobileNumber = json['otherMobileNumber'],
        startDate =  DateTime.tryParse(json['startDate']),
        photoUrl = json['photoUrl'],
        enable = json['enable'],
        documentNumber =  json['documentNumber'],
        service = json['service'],
        dutyTiming = json['dutyTiming'];


  Map<String, dynamic> toJson() =>
      {

        'name': name,
        'documentType':documentType,
        'service':service,
        'mobileNumber': mobileNumber,
        'otherMobileNumber': otherMobileNumber,
        'startDate': startDate.toIso8601String(),
        'photoUrl': photoUrl,
        'enable':enable,
        'dutyTiming': dutyTiming,
        'documentNumber':documentNumber,
      };
}

class History {
  String Id;
  String societyID;
  DateTime startDate;

  History({this.societyID ,this.startDate,this.Id,});
  History.fromJson(Map<String, dynamic> json)
      :
        Id = json['ID'],
        societyID = json['societyID'],
        startDate =  DateTime.tryParse(json['startDate']);


  Map<String, dynamic> toJson() =>
      {
        'ID':Id,
        'societyID':societyID,
        'startDate': startDate.toIso8601String(),
      };
}

