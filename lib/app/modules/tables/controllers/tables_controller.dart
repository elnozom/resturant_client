import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:get/get.dart';

import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';
import 'package:client_v3/widgets/tablesWidgets.dart';

class TablesController extends GetxController {
  final provider = new TableProvider();
  List<TableGroup> groups = [TableGroup.newInstance()].obs;
  RxList<TableModel> tables = [TableModel.newInstance()].obs;
  Rx<bool> loading = true.obs;
  Rx<bool> groupLoading = true.obs;

  Rx<int> activeGroup = 0.obs;
  final TablesWidgets widgets = new TablesWidgets();
  final count = 0.obs;
  Emp emp = Get.arguments;

  void chooseTable(TableModel table) {
    
    provider.tablesOpenOrder(table.serial, emp.empCode , table.headSerial).then((value) {
      // table.waiterCode = emp.empCode;
       print("value.msg");
        print(value.msg == "order_finished");
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
    super.onReady();
    getGroups();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
