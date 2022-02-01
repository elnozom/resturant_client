import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:client_v3/app/data/models/keypad_actions_model.dart';
import 'package:client_v3/app/utils/globals.dart';
import 'package:client_v3/app/widgets/pinInput.dart';

class LoginWidgets {
  late final Function toggleTabs;
  LoginWidgets({required this.toggleTabs});
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qController;
  final TextEditingController codeController = new TextEditingController();
  final FocusNode codeFocus = new FocusNode();
  Rx<String> password = "".obs;


  void reset(){
    codeController.clear();
    password.value = "";
  }
  void attachLetterToEmpCode(val) {
    codeController.text += val.toString();
  }

  void removeLetterFromEmpCode() {
    codeController.text =
        codeController.text.substring(0, codeController.text.length - 1);
  }

  void attachLetterToPassword(val, Function submit) {
    password.value += val.toString();
    if (password.value.length == 6) {
      submit(password);
    }
  }

  void removeLetterFromPassword() {
    password.value = password.value.substring(0, password.value.length - 1);
  }

  Widget buildQrView(BuildContext context, Function onCreated) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        onCreated(controller);
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  Widget buildQrControllers() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
       
        ElevatedButton(
                onPressed: () {
                  toggleTabs(1);
                },
                child: Text('login_by_code', style: TextStyle(fontSize: 32))),
        
        ],
      ),
    );
  }

  Widget buildKeyPad(context, KeyPadActions keyPadActions) {
    return Container(
      width: 500.0,
      color: Colors.white,
      alignment: Alignment.center,
      child: Directionality(
        textDirection:TextDirection.ltr,
              child: NumericKeyboard(
          boxDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: Globals().radius,
            boxShadow: [Globals().shadow],
          ),
          size: MediaQuery.of(context).size.width > 960 ? 100.0 : 60.0,
          // bgColor: Theme.of(context).primaryColor,
          onKeyboardTap: (val) {
            keyPadActions.pressed(val);
          },
          textColor: Colors.white,
          rightIcon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          rightButtonFn: () {
            keyPadActions.submit();
          },
          leftIcon: Icon(
            Icons.backspace,
            color: Colors.white,
          ),
          leftButtonFn: () {
            keyPadActions.remove();
          },
        ),
      ),
    );
  }

  Widget buildEmpCodeForm(BuildContext context, Function getEmpByCode) {
    reset();
    KeyPadActions keyPadActions = new KeyPadActions(
        pressed: attachLetterToEmpCode,
        submit: () {
          getEmpByCode(int.parse(codeController.text));
        },
        remove: removeLetterFromEmpCode);
    return Container(
      color: Colors.white,
      child: Column(children: [
        Text(
          'enter_pin',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        TextField(
          textAlign: TextAlign.center,
          controller: codeController,
          readOnly: true,
          decoration: new InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              isDense: true),
          style: TextStyle(color: Colors.black),
        ),
        buildKeyPad(context, keyPadActions),
      ]),
    );
  }

  Widget buildPasswordForm(
      BuildContext context, Function login, Function newCode) {
    KeyPadActions keyPadActions = new KeyPadActions(
        pressed: (val) {
          attachLetterToPassword(val, login);
        },
        submit: () {
          login(password);
        },
        remove: removeLetterFromPassword);

    return Column(children: [
      // Text(empName.value),
      Text(
        'enter_code',
        textAlign: TextAlign.center,
        style: TextStyle( fontSize: 22),
      ),
      TextButton(
        child: Text('new_code' , style: TextStyle(fontSize: 22),),
        onPressed: () {
          newCode();
        },
      ),
      // Obx(() => Text("asd")),
      SizedBox(
        height: 50,
        child: Container(child: PinInput(count: password.value.length)),
      ),
      buildKeyPad(context, keyPadActions),
    ]);
  }
}
