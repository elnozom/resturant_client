import 'package:client_v3/app/modules/order/helpers/localStorage.dart';
import 'package:client_v3/app/modules/printing/printing.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final Printing printing = Printing.instance;
  final TextEditingController ipInput = new TextEditingController();
  final TextEditingController portInput = new TextEditingController();
  final TextEditingController logoInput = new TextEditingController();
  final LocalStorage localStorage = LocalStorage.instance;
  @override
  void onInit() {
    super.onInit();
  }
  void save() async {
    printing.getDevices();
    localStorage.setIp(ipInput.text);
    localStorage.setPort(portInput.text);
    localStorage.setLogo(logoInput.text);
    Get.offAllNamed("/home");
  }
  @override
  void onReady() {
    super.onReady();
    printing.getDevices();
    ipInput.text = localStorage.ip;
    portInput.text = localStorage.port;
    logoInput.text = localStorage.logoPath;
  }
  @override
  void onClose() {}
}
