import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/auth/auth_provider.dart';
import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:client_v3/widgets/loginWidgets.dart';

// import 'package:qrscan/qrscan.dart' as scanner;
class LoginController extends GetxController with SingleGetTickerProviderMixin {
  // decalare the  code controlller & focus
  final TextEditingController codeController = new TextEditingController();
  final FocusNode codeFocus = new FocusNode();
  QRViewController? qController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final provider = new AuthProvider();

  late final LoginWidgets widgets = new LoginWidgets(toggleTabs: toggleTabs);
  // declare password text
  Rx<String> password = "".obs;
  Barcode? result;

  Rx<Emp>? emp;
  Rx<String> empName = "".obs;
  Rx<int> codeCount = 0.obs;
  Rx<bool> empNoFound = false.obs;
  // this password mode will be used on the view to show passowrd pullets
  // and remove code input
  // and change keyboard methods
  Rx<bool> passwordMode = false.obs;

  late TabController tabC = TabController(vsync: this, length: 2);
  void newCode() {
    codeController.clear();
    emp = null;
    password.value = "";
    passwordMode.value = false;
    empName.value = "";
    empNoFound.value = false;
  }

  void toggleTabs(index) {
    tabC.animateTo(index);
  }
  // call the api to get employee name
  String empGetByCode(int val) {
    // perform request
    provider.empGetByCode(val).then((value) {
      // check if value is null to reset the input and ask for empCode again
      // and show the error by setting notFound to true
      if (value == null) {
        codeController.clear();
        empNoFound.value = true;
        return;
      }

      // success call back
      emp = value.obs;
      // if we reached here that means we have the emplloyee
      // so we will clear the input
      // and allow user to enter the pin
      empNoFound.value = false;
      passwordMode.value = true;


      print(emp!.value.empPassword);

    });

    return emp != null ? emp!.value.empName : "";
    // failed callback
  }

  // call the api to perform login
  void login(password) {
    print(password);
    print(emp!.value.empPassword);
    // compare password
    if (password != emp!.value.empPassword) {
      password.value = "";
      return;
    }
    // success call back

    goToTables();
  }
  void goToTables(){
    Get.offNamed('/tables', arguments: emp!.value);
  }
  void keyPadLeftIconEntered() {
    if (passwordMode.value) {
      password.value = password.value.substring(0, password.value.length - 1);
    } else {
      codeController.text = codeController.text.substring(0, codeController.text.length - 1);
    }
  }
  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      print(scanData.code);
      provider.empGetByBarCode(int.parse(scanData.code)).then((value) {
        if (value != null) {
          emp = value.obs;
          goToTables();
        }
      }).catchError((err){
        print(err);
      });
    });
  }

  Widget qrTab(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: widgets.buildQrView(context, onQRViewCreated)),
        Container(color:Colors.white ,child: widgets.buildQrControllers()),
      ],
    );
  }

  Widget binCodeTab(BuildContext context) {
    newCode();
    return Container(
      alignment: Alignment.center,
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Obx(() => empNoFound.value
                ? Text(
                    "emp_code_err".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 22),
                  )
                : SizedBox()),
            Obx(() => Text(
                  empName.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 22),
                )),
            Obx(() => passwordMode.value
                ? widgets.buildPasswordForm(context, login, newCode)
                : widgets.buildEmpCodeForm(context, empGetByCode)),
            ElevatedButton(
                onPressed: () => toggleTabs(0), child: Text('login_by_qr'.tr , style: TextStyle(fontSize: 22)))
          ],
        )));
  }

  @override
  void onInit() {
    super.onInit();
    tabC = TabController(vsync: this, length: 2);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // disponse controllers
  }
}
