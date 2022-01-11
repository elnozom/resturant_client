import 'package:get/get.dart';


class Item {
  late int itemSerial;
  late double itemPrice;
  late String itemName;
  late bool withModifier;
  late int screen;
  late int orderItemSerial;
  late int mainModSerial;
  late Rx<int>? qnt = 0.obs;
  Item({
    required this.itemSerial, required this.itemPrice,  required this.itemName , required this.withModifier ,required this.orderItemSerial,this.qnt,required this.mainModSerial
    });
   
  Item.fromJson(Map<String, dynamic> json) {
    itemSerial = json['ItemSerial'];
    itemPrice = json['ItemPrice'] is int ? json['ItemPrice'].toDouble() : json['ItemPrice'];
    orderItemSerial = json['OrderItemSerial'];
    mainModSerial = json['MainModSerial'];
    itemName = json['ItemName'];
    withModifier = json['WithModifier'];
    screen = json['Screen'];
  }

  Map<String, dynamic> toJson() => {
    "ItemSerial" : itemSerial,
    "ItemPrice" : itemPrice,
    "ItemName" : itemName,
    "WithModifier" : withModifier,
    "Screen" : screen,
    "OrderItemSerial" : orderItemSerial,
    "MainModSerial" : mainModSerial,
  };

  static Item newInstance() {
    return new Item(
      itemSerial : 0,
      itemPrice : 0,
      orderItemSerial : 0,
      mainModSerial : 0,
      itemName : "",
      withModifier : false,
    );
  }
}
