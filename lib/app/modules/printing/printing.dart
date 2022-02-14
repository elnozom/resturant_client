
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Printing {
  bool connected = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  OrderProvider orderProvider = Get.put(new OrderProvider());
  List<BluetoothDevice>? devices;
  BluetoothDevice? _device;
  Rx<bool> loading = true.obs;
  static Printing? _instance;
  SharedPreferences? _prefs;
  String charset = "windows-1256";
  int headSerial = 0;
  Printing._internal() {
    _init();
  }
  static Printing get instance {
    if (_instance == null) {
      _instance = Printing._internal();
    }

    return _instance!;
  }


  void getDevices() async{
    loading.value = true;
    devices = await bluetooth.getBondedDevices();
    loading.value = false;
  }
  void _init() async {
    getDevices();
    _prefs = await SharedPreferences.getInstance();
    loading.value = true;
    String? printerName = _prefs!.getString('printer_name') == null
        ? ""
        : _prefs!.getString('printer_name');
    String? printerAddress = _prefs!.getString('printer_address') == null
        ? ""
        : _prefs!.getString('printer_address');
    _device = new BluetoothDevice.fromMap(
        {"name": printerName, "address": printerAddress});
    loading.value = false;
  }

  Future _connect({bool fromPrint = false}) async {
    await bluetooth.isConnected.then((isConnected) async {
      if (isConnected!) {
        await bluetooth.disconnect();
      }
      bluetooth.connect(_device!).then((val) {
        connected = true;
        Get.snackbar("تم الاتصال", "تم الاتصال بالطابعة بنجاح");
        if(fromPrint){
          printReceipt();
        }
      }).catchError((error) {
        connected = false;
        Get.snackbar("تم الحفظ",
            "تم  حفظ بيانات الطابعة و لكن فشل الاتصال في الوقت الحالي");
      });
    });
  }

  void _savePrinter(BluetoothDevice dev) {
    _prefs!.setString("printer_name", dev.name!);
    _prefs!.setString("printer_address", dev.address!);
    _device = dev;
    _connect();
  }

  List<DropdownMenuItem<BluetoothDevice>>? _prepareDevicesArray() {
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

  DropdownButton devicesDropDown() {
    return DropdownButton<BluetoothDevice>(
        value: _device,
        isExpanded: true,
        hint: Text("select_printer".tr),
        onChanged: (device) {
          _savePrinter(device!);
        },
        items: _prepareDevicesArray());
  }


  void _printFixedLine() {
    bluetooth.printCustom("ــــــــــــــــــــــــ", 2, 1,
        charset: "windows-1256");
  }

  void _printCenter(String text) {
    bluetooth.printCustom(text, 1, 1, charset: charset);
  }

  void _printLeft(String text) {
    bluetooth.printCustom(text, 2, 0, charset: charset);
  }

  void _printRight(String text) {
    bluetooth.printCustom(text, 2, 2, charset: charset);
  }
  void _print2Cols(String text1,String text2) {
    // bluetooth.printLeftRight(text1, text2, 1 , charset: charset);
    bluetooth.print3Column(text1, "", text2 ,1, charset: charset ,  format: "%-20s %1s %20s %n");
  }
  void _print2ColsSpace(String text1,String text2) {
    bluetooth.printLeftRight(text1, text2, 1 , charset: charset ,format: "%-21s %21s %n");
  }
  
  
  void _newLine() {
    bluetooth.printNewLine();
  }

  void setHeadSerial(int serial) async {
    headSerial = serial;
    if(!connected){
      await _connect(fromPrint :true);
    }
    printReceipt();
  }
  void printReceipt() {
    if(!connected){
      _connect(fromPrint :true);

      return ;
    }
    orderProvider.listItemFromPrint(headSerial).then((val) {
      String orderNo = "Order # ${val['Config']['OrderNo']}";
      String cheqNo = "Cheque # ${val['Config']['BonNo']}";
      String cashtry = "CashTry # ${val['Config']['CashtryNo']}";
      String captain = "Captain # ${val['Config']['WaiterName']}";
      String guest = "Guest # ${val['Config']['GuestsNo']}";
      String date = val['Config']['DocDate'];
      String user = "User: ${val['Config']['CustomerName']}";
      String customer = "Cust Name:${val['Config']['CustomerName']}";
      String time = "Time:${val['Config']['DocTime']}";
      String table = "Table : ${val['Config']['TableNO']} - ${val['Config']['GroupTableName']}";
      String subtotal = "Subtotal: ${val['Config']['SubTotal'].toStringAsFixed(2)} L.E";
      String tax = "Tax(${val['Config']['TaxPercent']}%) :${val['Config']['SaleTax'].toStringAsFixed(2)} L.E";
      String disc = "Disc(${val['Config']['DiscountPercent']}%) :${val['Config']['DiscountValue'].toStringAsFixed(2)} L.E";
      String total = "Grand Total ${val['Config']['Total'].toStringAsFixed(2)} L.E";
      String foot = "عميلنا العزيز يسعدنا تشريفكم";
      String pwrd ="powered by El Nozom F&B - www.elnozom.com";
      _newLine();
      _newLine();
      _newLine();
      _newLine();
      // _printCenter(orderNo);
      _print2Cols(cashtry, guest);
      _print2Cols(orderNo, captain);
      _print2Cols(customer, time);
      _print2ColsSpace(cheqNo, date);
      _newLine();
      bluetooth.printCustom(table, 3, 1 , charset: charset);
      _printFixedLine();
      bluetooth.print4Column("اسم الصنف", "العدد", "السعر", "القيمة", 1,
          format: "%-20s %7s %7s %7s %n", charset: charset);
      _printFixedLine();
      print(val['Items']);
      for (var item in val['Items']) {
        bluetooth.print4Column(
            item['ItemName'],
            item['Qnt'].toString(),
            item['Price'].toStringAsFixed(2),
            item['Total'].toStringAsFixed(2),
            1,
            format: "%-20s %7s %7s %7s %n",
            charset: charset);
        _printFixedLine();
      }
      _printLeft(subtotal);
      _newLine();
      _printLeft(tax);
      _newLine();
      _printLeft(total);
      _newLine();
      if(val['Config']['DiscountPercent'] > 0)_printRight(disc);
      
      bluetooth.printCustom(foot, 3, 1 , charset: charset);
      _newLine();
      bluetooth.printCustom(pwrd, 1, 1 , charset: charset);

      _newLine();
      _newLine();
      _newLine();
      _newLine();
      _newLine();
    });
    
  
  }

  void disconnect() {}
}
