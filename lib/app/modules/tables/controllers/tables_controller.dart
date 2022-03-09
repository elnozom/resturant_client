import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/modules/order/helpers/notification.dart';
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
  // Timer? timer;
  List<TableGroup> groups = [TableGroup.newInstance()].obs;
  RxList<TableModel> tables = [TableModel.newInstance()].obs;
  Rx<bool> loading = true.obs;
  Rx<bool> groupLoading = true.obs;
  late AudioPlayer player;
  Rx<int> activeGroup = 0.obs;
  final TablesWidgets widgets = new TablesWidgets();
  final count = 0.obs;
  Emp emp = Get.arguments;

  Future chooseTable(TableModel table) async {
    

  // await player.setAsset('assets/audio/notify.mp3');
  // player.play();

  //   return ;
    provider.tablesOpenOrder(table.serial, emp.empCode , table.headSerial).then((value) {
      // table.waiterCode = emp.empCode;
      if(value.msg == "order_finished") getTables(activeGroup.value);
      if (value.isOrderOpened) {
        Get.offNamed("/order", arguments: [table , emp]);
        
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
      getTables(groups.first.groupTableNo);
      groupLoading.value = false;
    });
  }

  // list all tables for active group
  void getTables(int no) {
    loading.value = true;
    activeGroup.value = no;
    provider.tablesListByGroupNo(no).then((value) {
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
