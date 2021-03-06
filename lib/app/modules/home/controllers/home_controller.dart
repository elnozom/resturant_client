import 'package:client_v3/app/utils/globals.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/auth/auth_provider.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';

class HomeController extends GetxController {
  void authorizeDevice() async{
    TableProvider().tablesCloseOrder(0);
    AuthProvider().checkDeviceAuthorization().then((value) {
      if(value == null){
        Get.offAllNamed('/unauthorized');
        return ;
      }
      if(value.cashtraySerial == 0){
        Get.offAllNamed('/nocashtray');
        return ;
      }
      Get.toNamed("/login");
    }).onError((error, stackTrace){
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
    TableProvider().tablesCloseOrder(0);
  }

  @override
  void onClose() {}

}
