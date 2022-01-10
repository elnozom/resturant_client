import 'package:get/get.dart';
import 'package:client_v3/app/data/models/auth/auth_provider.dart';

class NocashtrayController extends GetxController {
  //TODO: Implement NocashtrayController

  void reload(){
     AuthProvider().checkDeviceAuthorization().then((value) {
      if(value!.cashtraySerial != 0){
        Get.offAllNamed('/home');
        return ;
      }
    });
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
