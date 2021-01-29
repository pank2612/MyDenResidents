class PaytmModel {
  String CURRENCY;
  String GATEWAYNAME;
  String RESPMSG;
  String BANKNAME;
  String PAYMENTMODE;
  String RESPCODE;
  String TXNAMOUNT;
  String TXNID;
  String ORDERID;
  String STATUS;
  String BANKTXNID;
  String TXNDATE;
  String paymentDateAndTime;
  bool isExpanded;
  String remark;
  PaytmModel(
      {this.CURRENCY,
        this.BANKNAME,
        this.BANKTXNID,
        this.ORDERID,
        this.PAYMENTMODE,
        this.RESPCODE,
        this.RESPMSG,
        this.STATUS,
        this.TXNAMOUNT,
        this.TXNDATE,
        this.TXNID,
        this.GATEWAYNAME,
        this.paymentDateAndTime,
        this.isExpanded = false,
        this.remark});
  factory PaytmModel.fromJson(Map<String, dynamic> json) {
    return PaytmModel(
        CURRENCY: json['CURRENCY'],
        BANKNAME: json['BANKNAME'],
        BANKTXNID: json['BANKTXNID'],
        ORDERID: json['ORDERID'],
        PAYMENTMODE: json['PAYMENTMODE'],
        RESPCODE: json['RESPCODE'],
        RESPMSG: json['RESPMSG'],
        STATUS: json['STATUS'],
        TXNAMOUNT: json['TXNAMOUNT'],
        TXNDATE: json['TXNDATE'],
        TXNID: json['TXNID'],
        GATEWAYNAME: json['GATEWAYNAME'],
        paymentDateAndTime: json['paymentDateAndTime'],
        remark: json['remark'],
        isExpanded: false);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.CURRENCY;
    data['gateWayName'] = this.GATEWAYNAME;
    data['txnID'] = this.TXNID;
    data['txnDate'] = this.TXNDATE;
    data['txnAmount'] = this.TXNAMOUNT;
    data['status'] = this.STATUS;
    data['resMsg'] = this.RESPMSG;
    data['resCode'] = this.RESPCODE;
    data['paymentMode'] = this.PAYMENTMODE;
    data['orderID'] = this.ORDERID;
    data['bankTxnID'] = this.BANKTXNID;
    data['bankName'] = this.BANKNAME;
    data['paymentDateAndTime'] = this.paymentDateAndTime;
    data['remark'] = this.remark;
    return data;
  }
}