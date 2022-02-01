import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/tables_form.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferWidgets {
  List<Item> transferedOrderItems = [];
  Rx<bool> transferIetmsLoading = false.obs;

  Rx<bool> orderItemsLoading = true.obs;
  Rx<bool> insertLoading = false.obs;

  late List<Item> orderItems;
  Rx<bool> err = false.obs;

  void listOrderItems(OrderProvider provider , int headSerial) {
    orderItemsLoading.value = true;
    provider.listOrderItems(headSerial).then((value) {
      value.removeWhere((item) => checkForModifiers(item));
      orderItems = value;
      orderItemsLoading.value = false;
    }).onError((error, stackTrace) {
      print("error");
      print(error);
      Get.snackbar("error".tr, "connection_error".tr);
    });
  }


  Widget tableHeader() {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.black),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
                "name".tr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              flex: 7),
          Expanded(
              child: Text("price".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center),
              flex: 2),
          Expanded(
              child: Text("qnt".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center),
              flex: 2),
        ],
      ),
    );
  }

  Future<bool> transferItem(Item item) async {
    if(orderItems.length == 1){
      Get.snackbar("not_allowed".tr, "cant_transfer_last_item".tr);
      return false;
    }
    insertLoading.value = true;
    orderItems.remove(item);
    transferedOrderItems.add(item);
    insertLoading.value = false;

    return true;
  }

  Future<bool> deTransferItem(Item item) async {
    orderItemsLoading.value = true;
    insertLoading.value = true;
    transferedOrderItems.remove(item);
    orderItems.add(item);
    orderItemsLoading.value = false;
    insertLoading.value = false;
    return true;
  }

  bool checkForModifiers(Item item) =>
      item.itemSerial == 0 || item.itemPrice == 0;
  Widget transferItemRow(Item item) {
    return Dismissible(
        // direction: DismissDirection.endToStart,
        confirmDismiss: (dir) async {
          return await transferItem(item);
        },
        key: Key(UniqueKey().toString()),
        background: dismisibleBg(Colors.green.shade400, "transfer".tr),
        child: plainItemRow(item, Colors.white));
  }

  Widget transferedItemRow(Item item) {
    return Dismissible(
        // direction: DismissDirection.endToStart,
        confirmDismiss: (dir) async {
          return await deTransferItem(item);
        },
        key: Key(UniqueKey().toString()),
        background: dismisibleBg(Colors.red.shade400, "remove".tr),
        child: plainItemRow(item, Colors.grey));
  }

  Widget dismisibleBg(Color color, String text) => Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.transform, color: Colors.white),
                  Text(text, style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.transform, color: Colors.white),
                  Text(text, style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      );
  Widget plainItemRow(Item item, Color color) => Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 8),
        // alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.4, color: Colors.black),
            ),
            color: color),

        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(item.itemName, style: TextStyle(fontSize: 18)),
                flex: 7),
            Expanded(
                child: Text(item.itemPrice.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18)),
                flex: 2),
            Expanded(
                child: Text('1',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18)),
                flex: 2),
          ],
        ),
      );

  Widget orderItemsTransferTableRows() {
    List<Widget> itemsRows = [];
    for (var item in orderItems) {
      itemsRows.add(transferItemRow(item));
    }
    return Column(children: itemsRows);
  }

  Widget transferItemsWidget(context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    tableHeader(),
                    Obx(() => orderItemsLoading.value
                        ? LoadingWidget()
                        : Column(
                            children: orderItems
                                .map((i) => transferItemRow(i))
                                .toList()))
                  ],
                ),
              )),
          SizedBox(height: 10),
          Container(
              height: MediaQuery.of(context).size.height * 0.2,
              color: Colors.grey.shade100,
              child: SingleChildScrollView(
                child: Obx(() => !insertLoading.value
                    ? Column(
                        children: transferedOrderItems
                            .map((i) => transferedItemRow(i))
                            .toList())
                    : LoadingWidget()),
              ))
        ]),
      );
}
