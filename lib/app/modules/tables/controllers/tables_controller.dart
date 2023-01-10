import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/modules/order/helpers/notification.dart';
import 'package:client_v3/app/modules/order/helpers/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';
import 'package:client_v3/widgets/tablesWidgets.dart';
import 'package:just_audio/just_audio.dart';

class TablesController extends GetxController {
  final provider = new TableProvider();
  final notification = Notify.instance;
  Rx<int> cartCount = 0.obs;
  TextEditingController guests = new TextEditingController();
  // Timer? timer;
  List<TableGroup> groups = [TableGroup.newInstance()].obs;
  TableGroup? activeGroup ;
  RxList<TableModel> tables = [TableModel.newInstance()].obs;
  Rx<bool> loading = true.obs;
  Rx<bool> groupLoading = true.obs;
  Options options = Options.instance;
  late AudioPlayer player;
  // Rx<int> activeGroup = 0.obs;
  final TablesWidgets widgets = new TablesWidgets();
  final count = 0.obs;
  Emp emp = Get.arguments;

  Future _openPopup(context , table) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                contentPadding: EdgeInsets.all(0),
                elevation: 2,
                content: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        autofocus: true,
                        controller: guests,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'من فضلك ادخل عدد الزوار',
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            table.guests = int.parse(guests.text);
                            table.minimumBon = table.guests * options.minmumBon() ;
                            chooseTable(context , table , withMinimum: true);
                          },
                          child: Text(
                            "ادخال",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }

  Future<bool> checkMinimum(context , table) async {
    var useMinimum = groups
        .where((g) => g.groupTableNo == activeGroup!.groupTableNo)
        .first
        .useMinimumBon;
    if (useMinimum) {
      await _openPopup(context , table);
      return true;
    }
    return false;
  }

  Future chooseTable(BuildContext context, TableModel table , {bool withMinimum = false}) async {
    if (table.state == "Free") {
      table.useTax = activeGroup!.useSellTax;
      if(!withMinimum && activeGroup!.useMinimumBon){
        await _openPopup(context , table);
        // table.minimumBon = table.guests * options.minmumBon() ;
        return;
      }
    }

    provider
        .tablesOpenOrder(table.serial, emp.empCode, table.headSerial )
        .then((value) {
      // table.waiterCode = emp.empCode;
      if (value.msg == "order_finished") getTables(activeGroup!);
      if (value.isOrderOpened) {
        Get.offNamed("/order", arguments: [table, emp]);
      } else {
        Get.snackbar(
          "not_allowed".tr,
          value.msg.tr,
        );
      }
    });
    // Get.toNamed('login' , arguments: config);
  }

  // list all groups
  void getGroups() {
    groupLoading.value = true;
    provider.groupTablesList(emp.empCode).then((value) {
      groups = value;
      getTables(groups.first);
      groupLoading.value = false;
    });
  }

  // list all tables for active group
  void getTables(TableGroup group) {
    loading.value = true;
    activeGroup = group;
    provider.tablesListByGroupNo(group.groupTableNo).then((value) {
      loading.value = false;
      // success call back
      tables.value = value;
      loading.value = false;
    });
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    cartCount.value = Notify.instance.countItems();
    super.onReady();
    getGroups();

    FlutterBackgroundService().onDataReceived.listen((event) {
      print("tablcontroller");
      print(event);
      cartCount.value = event!['count'];
    });
    // timer = Timer.periodic(Duration(seconds: 60), (Timer t) => notification.checkForNewCalls());
  }

  @override
  void onClose() {
    // timer?.cancel();
  }
  void increment() => count.value++;
}
