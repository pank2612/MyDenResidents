import 'dart:convert';

class House {
  String houseId;
  String flatMember;
  String flatNumber;
  String flatOwner;
  String tower;
  bool enable;
  String tokenNo;
  String flag;


  House({this.flatMember,this.houseId, this.flatNumber,this.flatOwner, this.tower,this.flag,
    this.enable,this.tokenNo});

  House.fromJson(Map<String, dynamic> json)
      : flatOwner = json['flatOwner'],
        flatNumber = json['flatNumber'],
        flatMember = json['flatMember'],
        tower = json['tower'],
        houseId = json['houseId'],
        enable = json['enable'],
        flag = json['flag'],
        tokenNo = json['tokenNo'];

  Map<String, dynamic> toJson() =>
      {
        'flatOwner': flatOwner,
        'houseId':houseId,
        'flag':flag,
        'flatNumber': flatNumber,
        'flatMember': flatMember,
        'tower': tower,
        'enable' : enable,
        'tokenNo':tokenNo
      };

}





