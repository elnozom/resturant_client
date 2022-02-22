import 'package:get/state_manager.dart';

class Item {
  late int itemSerial;
  late double itemPrice;
  late String itemName;
  late bool withModifier;
  late int orderItemSerial;
  late int mainModSerial;
  late int qnt = 0;
  late String addItems = "";
  late Rx<int>? qntReactive = 0.obs;
  late bool printed = false;
  Item({
    required this.itemSerial, required this.itemPrice,  required this.itemName , required this.withModifier ,required this.orderItemSerial,required this.qnt,required this.mainModSerial ,  this.qntReactive , required this.addItems , required this.printed
    });
   
  Item.fromJson(Map<String, dynamic> json) {
    itemSerial = json['ItemSerial'];
    itemPrice = json['ItemPrice'] is int ? json['ItemPrice'].toDouble() : json['ItemPrice'];
    orderItemSerial = json['OrderItemSerial'];
    mainModSerial = json['MainModSerial'];
    itemName = json['ItemName'];
    withModifier = json['WithModifier'];
    qnt = json['Qnt'];
    addItems = json['AddItems'];
    printed = json['Printed'];
    
  }

  Map<String, dynamic> toJson() => {
    "ItemSerial" : itemSerial,
    "ItemPrice" : itemPrice,
    "ItemName" : itemName,
    "WithModifier" : withModifier,
    "OrderItemSerial" : orderItemSerial,
    "MainModSerial" : mainModSerial,
    "AddItems" : addItems,
    
  };

  static Item newInstance() {
    return new Item(
      itemSerial : 0,
      itemPrice : 0,
      orderItemSerial : 0,
      mainModSerial : 0,
      itemName : "",
      withModifier : false,
      qnt : 0,
      addItems: "",
      printed: false,
      
    );
  }
}
