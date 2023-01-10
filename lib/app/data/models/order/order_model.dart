class Order {
  late int  tableSerial;
  late String  imei;
  late int  orderType;
  late int guests;
  late int  waiterCode;
  Order({
    required this.tableSerial, required this.imei , required this.orderType , required this.guests , required this.waiterCode 
    });
  Order.fromJson(Map<String, dynamic> json) {
    tableSerial = json['TableSerial'];
    imei = json['Imei'];
    orderType = json['OrderType'];
    waiterCode = json['WaiterCode'];
    guests = json['Guests'];
  }

 Map<String, dynamic> toJson() => {
        "TableSerial" : tableSerial,
        "Imei" : imei,
        "OrderType" : orderType,
        "WaiterCode" : waiterCode,
        "Guests" : guests,
      };
}
