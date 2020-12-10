class MessageSendToGuard {
  String id;
  String message;
  DateTime creationDate;
  bool enable;

  MessageSendToGuard({this.id, this.message, this.creationDate,
   this.enable});
  MessageSendToGuard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        message = json['message'],
        creationDate = DateTime.tryParse(json['creationDate']),
        enable = json['enable'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'message': message,
        'creationDate': creationDate.toIso8601String(),
        'enable' : enable
      };

}
