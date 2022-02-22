import 'dart:async';

import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/customer/customer_provider.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/items.dart';
import 'package:client_v3/app/modules/order/helpers/toatls.dart';
import 'package:client_v3/app/modules/printing/printing.dart';
import 'package:client_v3/app/modules/singletons/addons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/group/group_provider.dart';
import 'package:client_v3/app/data/models/group/subgroup_model.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/item/item_provider.dart';
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:client_v3/widgets/orderWidgets.dart';

class OrderController extends GetxController {
  final GroupProvider groupProvider = Get.put(GroupProvider());
  final ItemProvider itemProvider = Get.put(ItemProvider());
  final TableProvider tableProvider = Get.put(TableProvider());
  final OrderWidgets widgets = Get.put(OrderWidgets());
  final OrderProvider orderProvider = Get.put(OrderProvider());
  final CustomerProvider customerProvider = Get.put(CustomerProvider());
  // final Transfer transferClass = Get.put(Transfer());
  bool reloadItems = false;
  Rx<bool> hasDiscount = false.obs;
 
  List<GroupModel?> mainGroups = [];

  Rx<bool> loading = true.obs;
  Rx<bool> subGroupsLoading = true.obs;
  Rx<bool> itemsLoading = true.obs;
  Rx<bool> orderItemsLoading = true.obs;
  Rx<bool> groupLoading = true.obs;
  Rx<bool> tableLoading = true.obs;

  TableModel config = Get.arguments[0];
  Emp emp = Get.arguments[1];

  RxList<SubGroupModel>? subGroups;
  RxList<Item>? items;
  RxList<Item>? orderItems;
  int? activeSubGroup;

  Rx<double> totalAmount = 0.0.obs;
  Rx<int> activeGroup = 0.obs;

  Rx<int> currentModifiersindex = 1.obs;
  int? modifiersScreens;
  String modifersSerials = "";

  bool createOrderLoading = false;
  final printing = Printing.instance;
  final totals = Totals.instance;
  final addons = Addons.instance;
  final itemsC = ItemsUtil.instance;
  // listing items & groups
  void listMainGroups() {
    groupProvider.listMainGroups().then((value) {
      mainGroups = value;
      listSubGroups(mainGroups.first!.groupCode);
    });
  }

 
  
  void openUpdateModal(ActionInterface action, context) {
    if(action.actionTitle == "change_table".tr){
      if(config.subtotal == 0) {
        Get.snackbar("error".tr, "not_allowed_before_send".tr);
        return ;
      }
    }
    if(emp.secLevel < 2 && action.actionTitle != "change_table".tr){
      Get.snackbar("error".tr, "not_allowed".tr);
      return ;
    }
    reloadItems = true;
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    action.reset(context);
                  }),
              title: Text(action.actionTitle),
              centerTitle: true,
            ),

            body: Container(child: Center(child: action.generateForm(context))),
            // floatingActionButton: ElevatedButton(onPressed: ()=> action.submit(context), child: Text("save".tr),),
            // bottomNavigationBar: Expanded(child: ElevatedButton(onPressed: ()=> action.submit(context), child: Text("save".tr),),),
          );
        },
        fullscreenDialog: true));
  }

  void listSubGroups(int group) {
    subGroupsLoading.value = true;
    groupProvider.listSubGroups(group as int).then((value) {
      subGroups = value!.obs;
      subGroupsLoading.value = false;
      loading.value = false;
      activeSubGroup = subGroups!.value.first.groupCode;
      // listItems();
      itemsC.init(activeSubGroup!, emp, config);
    });
  }

  void listItems() {
    itemsLoading.value = true;
    itemProvider.listItemsByGroup(activeSubGroup! , config.serial).then((value) {
      items = value.obs;
      itemsLoading.value = false;
      loading.value = false;
    }).catchError((err) {
      print(err);
    });
  }

  void listOrderItems(int headSerial) {
    // itemsLoading.value = true;
    orderItemsLoading.value = true;
    orderProvider.listOrderItems(headSerial).then((value) {
      orderItems = value.obs;
      orderItemsLoading.value = false;
    }).onError((error, stackTrace) {
      Get.snackbar("error".tr, "connection_error".tr);
    });
  }




  void openItems(context) {
    Get.bottomSheet(widgets.orderItemsAndTotalsSide(context),
        elevation: 20.0,
        enableDrag: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )));
  }

  
  void printReceipt() {
    if(emp.secLevel == 1 && config.printTimes > 0){
      Get.snackbar("error".tr, "print_not_allowed".tr);
    }
    printing.setHeadSerial(config.headSerial);
  }

  @override
  void onInit() {
    super.onInit();
    listMainGroups();
  }

  @override
  void onReady() {
    super.onReady();
    hasDiscount.value = config.discountPercent > 0;
    totals.init(config.subtotal , config.discountPercent);
    itemsC.reset();
  }

  @override
  void onClose() {
    tableProvider.tablesCloseOrder(config.serial , config.headSerial);
  }
}
