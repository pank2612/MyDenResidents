class BillingModel {
  String billingId;
  String billingHeader;
  String flatNumber;
  bool enable;
  double totalAmount;
  String perUnit;
  String validDays;
  DateTime startDate;
  DateTime endDate;
  String mode;

  BillingModel(
      {this.billingId,
        this.billingHeader,
        this.flatNumber,
        this.enable,
        this.totalAmount,
        this.perUnit,
        this.endDate,
        this.validDays,
        this.startDate});

  BillingModel.fromJson(Map<String, dynamic> json)
      : billingId = json['billingId'],
        billingHeader = json['billingHeader'],
        enable = json['enable'],
        mode = json['mode'],
        validDays = json['validDays'],
        totalAmount = json['totalAmount'],
        perUnit = json['perUnit'],
        startDate = DateTime.tryParse(json['startDate']),
        endDate = DateTime.tryParse(json['endDate']),
        flatNumber = json['flatNumber'];

  Map<String, dynamic> toJson() => {
    'billingId': billingId,
    'totalAmount': totalAmount,
    'perUnit': perUnit,
    'validDays':validDays,
    'mode':mode,
    'billingHeader': billingHeader,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'enable': enable,
    'flatNumber': flatNumber,
  };
}
