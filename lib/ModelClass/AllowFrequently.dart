class AllowFrequentlyModel {
  String id;
  String days;
  String validity;
  String userId;
  String startTime;
  bool enable;
  String endTime;
  String vehicalNo;
  String vehicalName;
  String companyName;
  String logo;

  AllowFrequentlyModel({
    this.id,
    this.days,
    this.validity,
    this.startTime,
    this.enable,
    this.endTime,
    this.userId,
    this.vehicalNo,
    this.companyName,
    this.vehicalName,
    this.logo,
  });

  AllowFrequentlyModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        days = json['days'],
        endTime = json['endTime'],
        logo =json['logo'],

        validity = json['validity'],
        startTime = json['startTime'],
        userId = json['userId'],
        companyName = json['companyName'],
        vehicalNo = json['vehicalNo'],
        vehicalName = json['vehicalName'],
        enable = json['enable'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'days': days,
        'endTime': endTime,
        'validity': validity,
        'startTime': startTime,
        'companyName':companyName,
        'vehicalNo': vehicalNo,
        'vehicalName': vehicalName,
        'enable': enable,
         'userId':userId,
        'logo':logo,
      };
}
