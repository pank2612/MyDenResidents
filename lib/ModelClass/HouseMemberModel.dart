class HouseMember {
  String id;
  DateTime enrolDate;
  DateTime deactivateDate;
  bool enable;

  HouseMember({
    this.id,
    this.enrolDate,
    this.deactivateDate,
    this.enable,
  });

  HouseMember.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        enrolDate = DateTime.tryParse(json['enrolDate']),
        deactivateDate = DateTime.tryParse(json['deactivateDate']),
        enable = json['enable'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'enrolDate': enrolDate.toIso8601String(),
        'deactivateDate': deactivateDate.toIso8601String(),
        'enable': enable,
      };
}
