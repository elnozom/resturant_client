import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController {
  //TODO: Implement SettingsController
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  RxList<BluetoothDevice>? devices;
  BluetoothDevice? device;
  Rx<bool> loading = true.obs;
  @override
  

  void getDevices() async {
    List<BluetoothDevice> d = await bluetooth.getBondedDevices();
    devices = d.obs;
    loading.value = false;
  }

  FutureOr<dynamic> connected(val) {
    Get.snackbar("تم الاتصال", "تم الاتصال بالطابعة بنجاح");
    return "";
  }

  void notConnted() {
    Get.snackbar(
        "تم الحفظ", "تم  حفظ بيانات الطابعة و لكن فشل الاتصال في الوقت الحالي");
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('printer_name') == null
        ? ""
        : prefs.getString('printer_name');
    var address = prefs.getString('printer_address') == null
        ? ""
        : prefs.getString('printer_address');
    BluetoothDevice dev =
        new BluetoothDevice.fromMap({"name": name, "address": address});
    loading.value = true;
    device = dev;
    loading.value = false;
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();
    BluetoothDevice dev = new BluetoothDevice.fromMap(
        {"name": device?.name!, "address": device?.address!});


        bluetooth.isConnected.then((isConnected) async {
          print(isConnected);
          if (isConnected!) {
           await bluetooth.disconnect();
          print(isConnected); 
          }
          bluetooth.connect(dev).then(connected).catchError((error) {
          print(isConnected); 
            notConnted();
          });
        });
    prefs.setString("printer_name", (device?.name)!);
    prefs.setString("printer_address", (device?.address)!);
    // String server = serverController.text;
    // prefs.setInt("store", selectedOption!);
    // prefs.setString("server", server);
    // Get.offAllNamed("/home");
  }

  List<DropdownMenuItem<BluetoothDevice>>? prepareDevicesArray() {
    List<DropdownMenuItem<BluetoothDevice>>? list = [];
    for (var i = 0; i < devices!.length; i++) {
      var active = devices![i];
      DropdownMenuItem<BluetoothDevice> menuItem =
          DropdownMenuItem<BluetoothDevice>(
        child: Text(active.name!),
        value: active,
      );
      list.add(menuItem);
    }

    return list;
  }

  @override
  void onClose() {}
}
