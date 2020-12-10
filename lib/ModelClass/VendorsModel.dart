class Vendor {
  String vendorId;
  String name;
  String enterTime;
  String mobileNumber;
  String vendor;
  String photoUrl;
  bool enable;


  Vendor({this.vendorId, this.name,this.enterTime, this.mobileNumber,this.photoUrl,
    this.vendor, this.enable});

  Vendor.fromJson(Map<String, dynamic> json)
      : vendorId = json['vendorId'],
        name = json['name'],
        enterTime = json['enterTime'],
        mobileNumber = json['mobileNumber'],
        vendor = json['vendor'],
        photoUrl = json['photoUrl'],
        enable = json['enable'];

  Map<String, dynamic> toJson() =>
      {
        'vendorId': vendorId,
        'name': name,
        'enterTime': enterTime,
        'mobileNumber': mobileNumber,
        'vendor': vendor,
        'enable' : enable,
        'photoUrl':photoUrl
      };

}
