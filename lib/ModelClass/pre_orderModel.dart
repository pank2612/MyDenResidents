

class PreOrder {
  String houseId;
  String name;
  String id;
  String societyId;
  String mobileNumber;
  String firstTime;
  String secondTime;
  bool enable;
  String selectDays;
  String selectValidity;

  PreOrder(
      {this.houseId,
      this.name,
      this.mobileNumber,
      this.societyId,
      this.firstTime,
      this.secondTime,
      this.enable,
      this.selectDays,
      this.selectValidity,
      this.id});

  PreOrder.fromJson(Map<String, dynamic> json)
      : houseId = json['houseId'],
        name = json['name'],
        id = json['id'],
        societyId = json["societyId"],
        mobileNumber = json['mobileNumber'],
        firstTime = json['firstTime'],
        secondTime = json['secondTime'],
        selectDays = json['selectDays'],
        enable = json['enable'],
        selectValidity = json['selectValidity'];

  Map<String, dynamic> toJson() => {
        'houseId': houseId,
        'id': id,
        'name': name,
        'societyId': societyId,
        'firstTime': firstTime,
        'mobileNumber': mobileNumber,
        'secondTime': secondTime,
        'selectDays': selectDays,
        'selectValidity': selectValidity,
        'enable': enable
      };
}
