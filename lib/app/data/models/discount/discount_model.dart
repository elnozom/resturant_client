class Discount {
  late int discCode;
  late String discDesc;
  late double discValue;
  late bool delTax;
  Discount({
    required this.discCode, required this.discDesc, required this.discValue , required this.delTax
    });
  Discount.fromJson(Map<String, dynamic> json) {
    discCode = json['DiscCode'];
    discDesc = json['DiscDesc'];
    discValue = json['DiscValue'] is int ? json['DiscValue'].toDouble() : json['DiscValue'];;
    delTax = json['DelTax'];
  }

  static Discount newInstance() {
    return new Discount(
      discCode:0,
      discDesc:"",
      discValue:0,
      delTax:false,
    );
  }
}
