import 'dart:async';

import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/customer/customer_provider.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/printing/printing.dart';
import 'package:client_v3/app/modules/singletons/addons.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/group/group_provider.dart';
import 'package:client_v3/app/data/models/group/subgroup_model.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/item/item_provider.dart';
import 'package:client_v3/app/data/models/order/order_model.dart';
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
  final addons = Addons.instance;
  // listing items & groups
  void listMainGroups() {
    groupProvider.listMainGroups().then((value) {
      mainGroups = value;
      listSubGroups(mainGroups.first!.groupCode);
    });
  }

  void openUpdateModal(ActionInterface action, context) {
    if(emp.secLevel < 2){
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
      listItems();
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

  // creat & delete items
  void createItem(Item item) {
    Map i = {
      "HeadSerial": config.headSerial,
      "ItemSerial": item.itemSerial,
      "WithMod": item.withModifier,
      "IsMod": false,
    };

    orderProvider.createOrderItem(i).then((value) {
      item.orderItemSerial = value;
      item.qntReactive!.value++;
      totalAmount.value += item.itemPrice;
      orderItems == null
          ? orderItems = [item].obs
          : orderItems!.value.add(item);
    
    });
  }

  void deleteItem(Item item) {
    orderProvider.deleteOrderItem(item.orderItemSerial).then((value) {
      listOrderItems(config.headSerial);
      listItems();
    });
  }

  void getItemModifers(item, context) {
    var modifiers;
    ItemProvider().getItemModifers(item.itemSerial).then((value) {
      modifiers = value;
      modifiersScreens = modifiers.length;
      currentModifiersindex.value = 1;
      Get.bottomSheet(Obx(() {
        return WillPopScope(
          onWillPop: () async => true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: Text(
                  " ${currentModifiersindex} اضافة",
                  style: TextStyle(color: Colors.black),
                )),
                ElevatedButton(
                  child: Text("done".tr),
                  onPressed: () {
                    createItemModifers(context, item.orderItemSerial);
                  },
                ),
                SizedBox(
                  height: 400,
                  child: modifiersGrid(
                      context,
                      modifiers[currentModifiersindex.value],
                      item.orderItemSerial),
                ),
              ],
            ),
          ),
        );
      }),
          elevation: 20.0,
          enableDrag: false,
          backgroundColor: Colors.white,
          persistent: true,
          isDismissible: false,
          useRootNavigator: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          )));
    });
  }

  void addItem(BuildContext context, Item item) async {
    if(emp.secLevel > 4) {
      Get.snackbar("error".tr, "not_allowed".tr);
      return ;
    }
    if (createOrderLoading == true) return;
    if (config.headSerial == 0) {
      await createOrder(context, item);
      return;
    }
    if (item.withModifier) {
      createItem(item);
      getItemModifers(item, context);
      return;
    }
    createItem(item);
  }

  Future createOrder(BuildContext context, Item item) async {
    createOrderLoading = true;
    String imei = await DeviceInformation.deviceIMEINumber;
    Order order = new Order(
        tableSerial: config.serial,
        imei: imei,
        orderType: 2,
        waiterCode: config.waiterCode);
    orderProvider.createOrder(order).then((value) {
      DateTime now = new DateTime.now();
      config.headSerial = value.headSerial;
      config.docNo = value.docNo;
      config.openTime = "${now.hour} : ${now.minute}";
      config.openDate = "${now.year}/${now.month}/${now.day}";
      createOrderLoading = false;
      addItem(context, item);
    });
  }

  void createItemModifers(BuildContext context, int orderItemSerial) {
    // remove the first comma from modifiers serials string
    // ",1,2,3" => "1,2,3"
    String sreials = modifersSerials.substring(1);
    Map insertItemModifersReq = {
      "ItemsSerials": sreials,
      "HeadSerial": config.headSerial,
      "OrderItemSerial": orderItemSerial
    };
    orderProvider.createOrderItemModifers(insertItemModifersReq).then((value) {
      modifersSerials = "";
      Navigator.pop(context);
    });
  }

  void openItems(context) {
    if (reloadItems) listOrderItems(config.headSerial);
    Get.bottomSheet(Obx(() {
      if (orderItemsLoading.value) return LoadingWidget();
      if (orderItems == null || orderItems!.value.length == 0)
        return Container(
            height: 100,
            child: Center(
                child: Text(
              "no_items".tr,
              style: TextStyle(color: Colors.black),
            )));
      return widgets.orderItemsAndTotalsSide(context);
    }),
        elevation: 20.0,
        enableDrag: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )));
  }

  Widget modifiersGrid(context, items, orderItemSerial) {
    if (itemsLoading.value) {
      return LoadingWidget();
    }
    List<Widget> widget = [];
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      widget.add(GestureDetector(
        onTap: () {
          modifersSerials += ",${item.itemSerial}";
          item.mainModSerial = orderItemSerial;
          orderItems!.value.add(item);
          if (currentModifiersindex.value < modifiersScreens!) {
            currentModifiersindex.value++;
            return;
          }
          createItemModifers(context, orderItemSerial);
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor),
            padding: EdgeInsets.fromLTRB(5, 5, 10, 0),
            child: Center(
              child: Text(
                item.itemName,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
            )),
      ));
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: .8,
            padding: EdgeInsets.all(10),
            crossAxisCount: MediaQuery.of(context).size.width < 960 ? 4 : 8,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widget));
  }
  
  void printReceipt() {
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
    totalAmount.value = config.subtotal;
    hasDiscount.value = config.discountPercent > 0;
    if (config.headSerial != 0) {
      listOrderItems(config.headSerial);
      return;
    }
    orderItemsLoading.value = false;
  }

  @override
  void onClose() {
    tableProvider.tablesCloseOrder(config.serial);
  }
}
