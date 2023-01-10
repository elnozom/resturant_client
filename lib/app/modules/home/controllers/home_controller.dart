import 'dart:async';

import 'package:client_v3/app/modules/order/helpers/notification.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/auth/auth_provider.dart';

class HomeController extends GetxController {
  final notification = Notify.instance;
  Rx<int> cartCount = 0.obs;
  // Timer? timer;
  void authorizeDevice() async {
    AuthProvider().checkDeviceAuthorization().then((value) {
      print(value);
      if (value == null) {
        Get.offAllNamed('/unauthorized');
        return;
      }
      if (value.cashtraySerial == 0) {
        Get.offAllNamed('/nocashtray');
        return;
      }
      Get.toNamed("/login");
    }).onError((error, stackTrace) {
      print(error);
      Get.snackbar("error".tr, "connection_error".tr);
    });
  }

  @override
  void onInit() {
    super.onInit();
    authorizeDevice();
  }

  @override
  void onReady() {
    super.onReady();
    cartCount.value = Notify.instance.countItems();
    FlutterBackgroundService().onDataReceived.listen((event) {
      print("tablcontroller");
      print(event);
      cartCount.value = event!['count'];
    });
  }

  @override
  void onClose() {
    // FlutterBackgroundService().sendData({"action": "stopService"});

    // timer?.cancel();
  }
}
