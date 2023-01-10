import 'package:flutter/widgets.dart';

class OptionsModel {
  late int storeCode;
  late bool multiPOS;
  late int transSerial;
  late bool useWaiter;
  late int accountSerial;
  late double saleTax;
  late double minimumBon;

  OptionsModel.fromJson(Map<String, dynamic> json) {
    storeCode = json['StoreCode'];
    multiPOS = json['MultiPOS'];
    transSerial = json['TransSerial'];
    useWaiter = json['UseWaiter'];
    accountSerial = json['AccountSerial'];
    saleTax = json['SaleTax'] is int ? json['SaleTax'].toDouble() : json['SaleTax'];
    minimumBon = json['MinimumBon'] is int ? json['MinimumBon'].toDouble() : json['MinimumBon'];
  }
 
}