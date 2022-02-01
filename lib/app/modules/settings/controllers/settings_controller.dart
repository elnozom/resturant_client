import 'dart:async';

import 'package:client_v3/app/modules/printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final printing = Printing.instance;
  @override
  void onInit() {
    super.onInit();
  }
  void save() async {
   Get.offAllNamed("/home");
  }
  @override
  void onReady() {
    super.onReady();
    printing.getDevices();
  }
  @override
  void onClose() {}
}
