import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TablesForm extends UpdateActions{
  final TableProvider tableProvider = Get.put(TableProvider());
  List<TableGroup> tableGroups = [TableGroup.newInstance()].obs;
  RxList<TableModel> tables = [TableModel.newInstance()].obs;
  TableGroup? selectedTableGroup;
  TableModel? selectedTable;
  Rx<bool> tableLoading = true.obs;
  Rx<bool> groupLoading = true.obs;
  Rx<bool> err = false.obs;
  int empCode = 0;
  late final bool isTransfer ;

  TablesForm(TableModel config , int emp , bool tr) : super(config) {
    empCode = emp;
    isTransfer = tr;
    getTablesGroups();
  }
  Future getTablesGroups() async {
    groupLoading.value = true;
    tableProvider.groupTablesList(empCode).then((value) {
      tableGroups = value;
      selectedTableGroup = tableGroups.first;
      getTables(tableGroups.first.groupTableNo);
      groupLoading.value = false;
    });
  }

  List<DropdownMenuItem<TableGroup>> groupsDropDown() {
    List<DropdownMenuItem<TableGroup>> list = [];
    for (var i = 0; i < tableGroups.length; i++) {
      list.add(DropdownMenuItem<TableGroup>(
          child: Text(tableGroups[i].groupTableName), value: tableGroups[i]));
    }
    return list;
  }

  List<DropdownMenuItem<TableModel>> tablesDropDown() {
    List<DropdownMenuItem<TableModel>> list = [];
    for (var i = 0; i < tables.length; i++) {
      list.add(DropdownMenuItem<TableModel>(
          child: tables[i].state == 'Free' ?  Text('${tables[i].tableName}') : Container( width: double.infinity,decoration: BoxDecoration(color: Colors.red ) , child :Text('${tables[i].tableName}' , style: TextStyle(color: Colors.white), )), value: tables[i]));
    }
    return list;
  }

 

  void getTables(int no) {
    tableLoading.value = true;
    selectedTable = null;
    tableProvider.tablesListByGroupNo(no).then((value) {
      tableLoading.value = false;
      tables.value = value;
      tableLoading.value = false;
    });
  }

  Widget chooseTableForm() => Column(
        children: [
          Obx(() => err.value
              ? Text(
                  "choose_table_err".tr,
                  style: TextStyle(color: Colors.red.shade400),
                )
              : SizedBox()),
          Obx(
            () => tableLoading.value
                ? LoadingWidget()
                : DropdownButton<TableGroup>(
                    isExpanded: true,
                    items: groupsDropDown(),
                    onChanged: (TableGroup? group) {
                      getTables(group!.groupTableNo);
                      selectedTableGroup = group;
                    },
                    hint: Text("choose_table_group".tr),
                    value: selectedTableGroup),
          ),
          Obx(
            () => tableLoading.value
                ? LoadingWidget()
                : DropdownButton<TableModel>(
                    isExpanded: true,
                    items: tablesDropDown(),
                    onChanged: (TableModel? table) {
                      print(this.isTransfer);
                      if(table!.state != 'Free' && !this.isTransfer) {
                        Get.snackbar("error".tr, "choose_table_err".tr);
                        return ;
                      }
                      tableLoading.value = true;
                      selectedTable = table;
                      tableLoading.value = false;
                    },
                    hint: Text("choose_table".tr),
                    value: selectedTable),
          ),
        ],
      );
  
}
