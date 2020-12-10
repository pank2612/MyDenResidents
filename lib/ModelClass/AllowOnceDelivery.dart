class AllowOnce {
  String id;
  String time;
  String hour;
  DateTime inviteDate;
  String companyName;
  bool enable;
  bool leavePackage;
  String logo;
  String residentId;
  String vehicalNo;





  AllowOnce({this.id, this.time,this.hour, this.inviteDate,
    this.companyName, this.enable,this.leavePackage,this.logo,this.residentId,this.vehicalNo});

  AllowOnce.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        time = json['time'],
        logo = json['logo'],
        residentId = json['residentId'],
        hour = json['hour'],
        vehicalNo =json['vehicalNo'],
        inviteDate = DateTime.tryParse(json['inviteDate']),
        companyName = json['companyName'],
        leavePackage = json['leavePackage'],
        enable = json['enable'];


  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'vehicalNo':vehicalNo,
        'residentId':residentId,
        'logo':logo,
        'time': time,
        'leavePackage':leavePackage,
        'hour': hour,
        'inviteDate': inviteDate.toIso8601String(),
        'companyName': companyName,
        'enable' : enable
      };

}
