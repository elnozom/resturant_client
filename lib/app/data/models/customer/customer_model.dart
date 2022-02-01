import 'package:get/get.dart';


class Customer {
  late int serial;
  late int accountCode;
  late String accountName;
  
  Customer({
    required this.serial, required this.accountCode,  required this.accountName 
    });
   
  Customer.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    accountCode = json['AccountCode'] ;
    accountName = json['AccountName'];
  }


  static Customer newInstance() {
    return new Customer(
      serial : 0,
      accountCode : 0,
      accountName : "",
    );
  }
}
