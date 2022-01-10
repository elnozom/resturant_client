import 'package:flutter/widgets.dart';

class KeyPadActions {
  late Function pressed;
  late Function remove;
  late Function submit;
  KeyPadActions({
    required this.pressed, required this.remove, required this.submit
    });
}
