import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:flutter/widgets.dart';

class NotificationModel {
  late int type;
  late int cartSerial;
  late int tableSerial;
  late String guestName;
  late String groupTableName;
  late int groupTableNo;
  late int tableNo;
  late int count;

  NotificationModel({
    required this.type, required this.cartSerial, required this.tableSerial,required this.guestName, required this.groupTableNo ,  required this.tableNo , required this.groupTableName , required this.count
    });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    cartSerial = json['CartSerial'];
    tableSerial = json['TableSerial'];
    guestName = json['GuestName'];
    groupTableNo = json['GroupTableNo'];
    groupTableName = json['GroupTableName'];
    tableNo = json['TableNo'];
    count = json['Count'];
  }
}
