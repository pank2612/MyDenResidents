class Notice {
  String noticeId;
  String noticeHeading;
  String description;
  DateTime startDate;
  DateTime endDate;
  bool enable;


  Notice({this.noticeId, this.noticeHeading,this.description, this.startDate,
    this.endDate, this.enable});

  Notice.fromJson(Map<String, dynamic> json)
      : noticeId = json['noticeId'],
        noticeHeading = json['noticeHeading'],
        description = json['description'],
        startDate = DateTime.tryParse(json['startDate']),
        endDate = DateTime.tryParse(json['endDate']),
        enable = json['enable'];

  Map<String, dynamic> toJson() =>
      {
        'noticeId': noticeId,
        'noticeHeading': noticeHeading,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'enable' : enable
      };

}
