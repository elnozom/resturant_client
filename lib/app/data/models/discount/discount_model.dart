class Discount {
  late int discCode;
  late String discDesc;
  late double discValue;
  late bool delTax;
  late int secLevel;
  Discount({
    required this.discCode, required this.discDesc, required this.discValue , required this.delTax , required this.secLevel
    });
  Discount.fromJson(Map<String, dynamic> json) {
    discCode = json['DiscCode'];
    discDesc = json['DiscDesc'];
    discValue = json['DiscValue'] is int ? json['DiscValue'].toDouble() : json['DiscValue'];;
    delTax = json['DelTax'];
    secLevel = json['SecLevel'];
  }

  static Discount newInstance() {
    return new Discount(
      discCode:0,
      discDesc:"",
      discValue:0,
      delTax:false,
      secLevel:0,
    );
  }
}
