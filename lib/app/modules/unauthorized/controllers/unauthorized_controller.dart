import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/auth/auth_provider.dart';
import 'package:client_v3/app/data/models/auth/setting_model.dart';

class UnauthorizedController extends GetxController {
  
  final keyController = TextEditingController();
  final nameController = TextEditingController();
  String key = Random().nextInt(999999).toString().padLeft(6, '0');
  Rx<bool> wrongKey = false.obs;
  Rx<bool> showEmpCode = false.obs;
  void submit(context) async {
    if (keyController.text == key) {
      wrongKey.value = false;
     await AuthProvider().insertDevice(nameController.text);
      await Get.offAllNamed('/home');
    } else {
      wrongKey.value = true;
    }
  }


  String encrypt(String k){
    String encrypted = "";
    for (var position = 1; position <= k.length; position++) {
      int asciKey = k.codeUnitAt(position -1);
      int newAsciKey =  asciKey + (position * 3) -  position;
      encrypted = encrypted + String.fromCharCode(newAsciKey);
    }
    return encrypted;
  }


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
