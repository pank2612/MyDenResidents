
class BillingModel {
  String billingId;
  String billingHeader;
  String flatNumber;
  bool enable;
  double totalAmount;
  String perUnit;


  BillingModel({this.billingId, this.billingHeader,this.flatNumber,this.enable,this.totalAmount,this.perUnit
  });

  BillingModel.fromJson(Map<String, dynamic> json)
      : billingId = json['billingId'],
        billingHeader = json['billingHeader'],
        enable = json['enable'],
        totalAmount =json['totalAmount'],
        perUnit =json['perUnit'],
        flatNumber = json['flatNumber'];


  Map<String, dynamic> toJson() =>
      {
        'billingId': billingId,
        'totalAmount':totalAmount,
        'perUnit':perUnit,
        'billingHeader':billingHeader,
        'enable':enable,
        'flatNumber': flatNumber,

      };

}