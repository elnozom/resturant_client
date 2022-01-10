import 'package:get/get.dart';

import '../controllers/nocashtray_controller.dart';

class NocashtrayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NocashtrayController>(
      () => NocashtrayController(),
    );
  }
}
