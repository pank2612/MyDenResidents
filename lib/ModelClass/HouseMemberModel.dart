class HouseMember {
  String id;
  DateTime enrolDate;
  DateTime deactivateDate;
  bool enable;
  String token;

  HouseMember({
    this.id,
    this.enrolDate,
    this.deactivateDate,
    this.enable,
    this.token,
  });

  HouseMember.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        token = json['token'],
        enrolDate = DateTime.tryParse(json['enrolDate']),
        deactivateDate = DateTime.tryParse(json['deactivateDate']),
        enable = json['enable'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'enrolDate': enrolDate.toIso8601String(),
        'token':token,
        'deactivateDate': deactivateDate.toIso8601String(),
        'enable': enable,
      };
}
