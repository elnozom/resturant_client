import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:flutter/widgets.dart';

class SideBarItem {
  late String title;
  late Icon icon;
  late ActionInterface action;
  SideBarItem({
    required this.title, required this.icon, required this.action
    });
}
