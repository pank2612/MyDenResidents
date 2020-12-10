class Alerts {
  String alertsId;
  String alertsHeading;
  String description;
  DateTime startDate;
  bool enable;
  String type;
  bool securityAdmin;
  bool houseMember;


  Alerts({this.alertsId, this.alertsHeading,this.description, this.startDate,
    this.type, this.enable,this.securityAdmin,this.houseMember});

  Alerts.fromJson(Map<String, dynamic> json)
      : alertsId = json['alertsId'],
        alertsHeading = json['alertsHeading'],
        description = json['description'],
        startDate = DateTime.tryParse(json['startDate']),
        type = json['type'],
        houseMember = json['houseMember'],
        securityAdmin = json['securityAdmin'],
        enable = json['enable'];

  Map<String, dynamic> toJson() =>
      {
        'alertsId': alertsId,
        'securityAdmin':securityAdmin,
        'alertsHeading': alertsHeading,
        'description': description,
        'houseMember':houseMember,
        'startDate': startDate.toIso8601String(),
        'type': type,
        'enable' : enable
      };

}