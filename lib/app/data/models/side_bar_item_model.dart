import 'package:flutter/widgets.dart';

class SideBarItem {
  late String title;
  late Icon icon;
  late Function action;
  SideBarItem({
    required this.title, required this.icon, required this.action
    });
}
