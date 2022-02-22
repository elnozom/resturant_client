import 'package:get/state_manager.dart';

class ModiferItem {
  late int itemSerial;
  late double itemPrice;
  late String itemName;
  late bool withModifier;
  late int screen;
  late int screenTimes;
  late int orderItemSerial;
  late int mainModSerial;
  late int qnt = 0;
  late String addItems = "";
  late Rx<int>? qntReactive = 0.obs;
  ModiferItem({
    required this.itemSerial, required this.itemPrice,  required this.itemName , required this.withModifier ,required this.orderItemSerial,required this.qnt,required this.mainModSerial ,  this.qntReactive , required this.addItems
    });
   
  ModiferItem.fromJson(Map<String, dynamic> json) {
    itemSerial = json['ItemSerial'];
    itemPrice = json['ItemPrice'] is int ? json['ItemPrice'].toDouble() : json['ItemPrice'];
    orderItemSerial = json['OrderItemSerial'];
    mainModSerial = json['MainModSerial'];
    itemName = json['ItemName'];
    withModifier = json['WithModifier'];
    screen = json['Screen'];
    screenTimes = json['ScreenTimes'];
    qnt = json['Qnt'];
    addItems = json['AddItems'];
  }
}
