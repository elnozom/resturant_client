import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/item/item_provider.dart';
import 'package:client_v3/app/data/models/order/order_model.dart';
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/modifiers.dart';
import 'package:client_v3/app/modules/order/helpers/toatls.dart';
import 'package:client_v3/app/modules/singletons/addons.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';

class ItemsUtil {
  int groupSerial = 0;

  List<Item> items = [];
  List<Item> orderItems = [];
  Rx<bool> itemsLoading = false.obs;
  Rx<bool> orderItemsLoading = false.obs;
  bool createOrderLoading = false;
  Emp? emp;
  ItemProvider itemProvider = new ItemProvider();
  OrderProvider orderProvider = new OrderProvider();
  static ItemsUtil? _instance;
  ItemsUtil._internal();
  TableModel? table;
  final totals = Totals.instance;
  Modifiers modifiers = new Modifiers();
  final addons = Addons.instance;
  int lastSerial = 0;

  static ItemsUtil get instance {
    if (_instance == null) {
      _instance = ItemsUtil._internal();
    }

    return _instance!;
  }

  List<Item> getItems() {
    return items;
  }

  List<Item> getOrderItems() {
    return orderItems;
  }


  Future setGroupSerial(int group) async{
    groupSerial = group;
    await _listItems();
  }
  Future init(int group, Emp e, TableModel t) async {
    emp = e;
    groupSerial = group;
    table = t;
    await _listItems();
    await listOrderItems();
    // totals.init(table!.subtotal, table!.discountPercent);
  }

  Future createOrder(BuildContext context, Item item) async {
    createOrderLoading = true;
    String imei = await DeviceInformation.deviceIMEINumber;
    Order order = new Order(
        tableSerial: table!.serial,
        imei: imei,
        orderType: 2,
        guests : table!.guests,
        waiterCode: emp!.empCode);
    orderProvider.createOrder(order).then((value) {
      DateTime now = new DateTime.now();
      table!.headSerial = value.headSerial;
      table!.docNo = value.docNo;
      table!.openTime = "${now.hour} : ${now.minute}";
      table!.openDate = "${now.year}/${now.month}/${now.day}";
      table!.waiterCode = emp!.empCode;
      createOrderLoading = false;
      addItem(context, item);
    });
  }
  Future addItem(BuildContext context, Item item) async {
 
    if (createOrderLoading == true) return;
    if (table!.headSerial == 0) {
      await createOrder(context, item);
      return;
    }
    if (emp!.empCode != table!.waiterCode && table!.waiterCode != 0) {
      Get.snackbar("error".tr, "not_allowed".tr);
      return;
    }
    Map i = {
      "HeadSerial": table!.headSerial,
      "ItemSerial": item.itemSerial,
      "WithMod": item.withModifier,
      "IsMod": false,
    };
    orderItemsLoading.value = true;
   
    orderProvider.createOrderItem(i).then((value) {
      item.orderItemSerial = value;
      item.qntReactive!.value++;
      totals.append(item.itemPrice);
      orderItems.add(item);
      orderItemsLoading.value = false;
      if (item.withModifier) {
        openModifiersModal(context, item.itemSerial , item.orderItemSerial);
      }
    });
  }
  Future<bool> deleteConfirmDialog(BuildContext context, Item item) async {
     if(item.printed && emp!.secLevel < 2){
      Get.snackbar("error".tr, "not_allowed".tr);
      return false;
    }
    bool result = await Get.dialog(AlertDialog(
        title: Text(
          "confirm_delete".tr,
          style: TextStyle(color: Colors.black),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade400),
                ),
                child: Text('cancle'.tr),
                onPressed: () => Get.back(result: false)),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              child: Text('confirm'.tr),
              onPressed: () {
                deleteItem(item , context);
                Get.back(result: true);
              },
            ),
          ],
        )));
    return result;
  }


  void appendItem(Item i){
    orderItemsLoading.value = true;
    orderItems.add(i);
    orderItemsLoading.value = false;
  }
  void removeItem(Item i){
    orderItemsLoading.value = true;
    orderItems.remove(i);
    orderItemsLoading.value = false;
  }
  Future openModifiersModal(context , itemSerial , orderItemSerial) async {
    modifiers.setHeadSerial(table!.headSerial);
    modifiers.setOrderItemSerial(orderItemSerial);
    await modifiers.setItemSerial(itemSerial);
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    modifiers.reset(context);
                  }),
              title: Text(modifiers.actionTitle),
              centerTitle: true,
            ),

            body: Container(child: Center(child: modifiers.generateForm(context))),
          );
        },
        fullscreenDialog: true));
  }

  void deleteItem(Item item  ,BuildContext context ) {
    orderProvider.deleteOrderItem(item.orderItemSerial , emp!.empCode).then((value) {
      // orderItems.remove(item);
      totals.remove(item.itemPrice);
      listOrderItems().then((value) {
        if(orderItems.length == 0) {
          Get.offAllNamed("/home");
        }
      });
    });
  }
  Widget itemRow(BuildContext context, Item item) {
    if (item.itemSerial == 0) {
      return SizedBox(
        height: 0,
      );
    }

    bool isMod = item.itemPrice == 0;
    return Dismissible(
      confirmDismiss: (dir) async {
        // return false;
        return await deleteConfirmDialog(context, item);
      },
      direction: DismissDirection.endToStart,
      key: Key(UniqueKey().toString()),
      background: Container(
        decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text('delete'.tr, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      child: Container(
        height: isMod
            ? 30
            : item.addItems == ""
                ? 40
                : 55,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.4, color: Colors.black),
          ),
          color: isMod ? Colors.grey.shade400 : Colors.white,
        ),

        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                    text: item.itemName,
                    style: TextStyle(
                        fontSize: isMod ? 14 : 18, color: Colors.black),
                    children: <TextSpan>[
                      if (item.addItems != "")
                        TextSpan(
                            text: "(${item.addItems})",
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade800 , fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                flex: 7),
            Expanded(
                child: Text(item.itemPrice.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMod ? 14 : 18)),
                flex: 2),
            Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '1',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: isMod ? 14 : 18),
                    ),
                    if (!isMod)
                      GestureDetector(
                        onTap: () {
                          // controller.reloadItems = true;
                          addons
                              .setItemSerial(context, item.orderItemSerial);

                        },
                        child: Icon(Icons.add_circle_outline,
                            color: Colors.black, size: 20),
                      ),
                  ],
                ),
                flex: 2),
          ],
        ),
      ),
    );
  }
  void reset(){
    groupSerial = 0;
    items = [];
    orderItems = [];
    itemsLoading = false.obs;
    orderItemsLoading = false.obs;
    createOrderLoading = false;
    emp = null;
    table = null;
  }
  Widget orderItemsTableRows(BuildContext context) {
  
    return Obx(() => orderItemsLoading.value ? LoadingWidget(): Column(children: List<Widget>.generate(orderItems.length, (int index) {
      return itemRow(context, orderItems[index]);
    })));
  }
  Widget itemsGrid(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 560;
    bool isSmallTablet = MediaQuery.of(context).size.width < 660;
    List<Widget> widgets = [];
    //check that items is empty
    // length will be one because tthe empty item in the first of array used to avoid bug
    if (items.length == 0) {
      return Center(
          child: Text("no_items".tr, style: TextStyle(color: Colors.black)));
    }
    for (var item in items) {
      widgets.add(
        itemWidget(context, item),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            // childAspectRatio: isMobile ? 1 :  .8,
            childAspectRatio:  1,
            padding: EdgeInsets.all(10),
            crossAxisCount: isMobile ?  2 : isSmallTablet ? 3 :4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widgets));
  }

  Widget itemWidget(BuildContext context, Item item) {
    Rx<bool> isActive = false.obs;
    isActive.value = item.qnt > 0;
    item.qntReactive = item.qnt.obs;
    return GestureDetector(
      onTap: () async {
        isActive.value = true;
        item.qnt++;
        await addItem(context, item);
      },
      child: SizedBox(
          child: Obx(
        () => AnimatedContainer(
          duration: Duration(microseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isActive.value
                ? Colors.green.shade900
                : Theme.of(context).primaryColor,
            boxShadow: [
              if (isActive.value)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                  width: double.infinity,
                  child: Text(
                    item.itemName,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )),
              Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item.itemPrice.toStringAsFixed(2)}EGP",
                        style: TextStyle(color: Colors.white),
                      ),
                      Obx(() => Text(
                            item.qntReactive!.value.toString(),
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )),
            ],
          ),
        ),
      )),
    );
  }

  Future _listItems() async {
    itemsLoading.value = true;
    itemProvider.listItemsByGroup(groupSerial, table!.serial).then((value) {
      items = value;
      itemsLoading.value = false;
    }).catchError((err) {
      print(err);
    });
  }

  Future listOrderItems() async {
    orderItemsLoading.value = true;
    await orderProvider.listOrderItems(table!.headSerial).then((value) {
      orderItems = value;
      orderItemsLoading.value = false;
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
