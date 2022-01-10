import 'package:client_v3/app/modules/order/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/side_bar_item_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/widgets/mainGroup.dart';

class OrderWidgets {
  late OrderController orderController;
  // OrderWidgets (OrderController orderController){
  //   this.orderController = orderController;
  // }
  

  Widget itemWidget(BuildContext context, Item item, Function addItem) {
    Rx<bool> isActive = false.obs;
    return GestureDetector(
        onTap: () {
          isActive.value = true;
          addItem(context, item);
        },
        child: SizedBox(
          child: Obx(() => AnimatedContainer(
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
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
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
                                "${item.itemPrice.toString()}EGP",
                                style: TextStyle(color: Colors.white),
                              ),
                              Obx(() => Text(
                                    item.qnt!.value.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ))
                              // Obx(()=> item.qnt > 0 ? Text(
                              //   item.qnt.toString(),
                              //   style: TextStyle(color: Colors.white),
                              // ) : Text(""))
                            ],
                          )),
                    ],
                  ),
                ),
              )),
        ));
  }

  Widget itemsGrid(BuildContext context, RxList<Item> items, Function addItem) {
    List<Widget> widget = [];
    if (items.length == 0) {
      return Center(
          child: Text("no_items".tr, style: TextStyle(color: Colors.black)));
    }
    for (var i = 0; i < items.value.length; i++) {
      var item = items.value[i];
      widget.add(
        itemWidget(context, item, addItem),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: MediaQuery.of(context).size.width > 960 ? .8 : 1,
            padding: EdgeInsets.all(10),
            crossAxisCount: MediaQuery.of(context).size.width > 960 ? 4 : 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widget));
  }

  Widget subGroupsList(context, subGroups, Function listItems) {
    List<Widget> groups = [];
    for (var i = 0; i < subGroups.length; i++) {
      var active = subGroups[i];
      Widget g = GestureDetector(
          onTap: () {
            listItems(active.groupCode);
          },
          child: SizedBox(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xff5b88bc)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                      width: double.infinity,
                      child: Text(
                        active.groupName,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ))
                ],
              ),
            ),
          ));
      groups.add(g);
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: MediaQuery.of(context).size.width > 960 ? .8 : 1,
            padding: EdgeInsets.all(10),
            crossAxisCount: 1,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: groups));
  }

  List<Widget> leftSideBarItems(context , sideBarItems) {
    List<Widget> items = [];
    for (var i = 0; i < sideBarItems.length; i++) {
      var activeItem = sideBarItems[i];
      GestureDetector item = GestureDetector(
          onTap: () {
            activeItem.action();
          },
          child: Column(children: [
            activeItem.icon,
            Text(activeItem.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1)
          ]));
      items.add(item);
      items.add(SizedBox(height: 30));
    }
    return items;
  }

  Container leftSideBar(context , sideBarItems) {
    return Container(
      child: Container(
          child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: leftSideBarItems(context , sideBarItems),
          ),
        ),
      )),
    );
  }

  List<Widget> mainGroupsItems(mainGroups, Function getSubGroups) {
    List<Widget> items = [];
    for (var i = 0; i < mainGroups.length; i++) {
      var g = mainGroups[i]!;
      Widget gr = GestureDetector(
          onTap: () {
            getSubGroups(g.groupCode);
          },
          child: MainGroup(title: g.groupName, icon: g.icon));
      items.add(gr);
    }

    return items;
  }

  Widget mainGroupsListAtBottom(BuildContext context,
      List<GroupModel?> mainGroups, Function getSubGroups) {
    return Container(
      height: MediaQuery.of(context).size.width > 960 ? 100 : 100,
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: mainGroupsItems(mainGroups, getSubGroups)),
        padding: EdgeInsets.all(10),
      ),
    );
  }

  Future<bool> deleteConfirmDialog(
      BuildContext context, Item item, Function deleteItem) async {
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
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text('cancle'.tr),
                onPressed: () => Get.back(result: false)
                // ** result: returns this value up the call stack **
                ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              child: Text('confirm'.tr),
              onPressed: () {
                deleteItem(item);
                Get.back(result: true);
              },
            ),
          ],
        )));
    return result;
  }

  Widget itemRow(BuildContext context, Item item, RxList<Item> items,
      Function deleteItem) {


        bool isMod = item.mainModSerial > 0;
    return Container(
      height: isMod ? 30 : 40,
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.4, color: Colors.black),
        ),
      ),
      child: OverflowBox(
              child: Dismissible(
          confirmDismiss: (dir) async {
            bool result = await deleteConfirmDialog(context, item, deleteItem);
            if (result)
              items.removeWhere((Item i) {
                return i.orderItemSerial == item.orderItemSerial ||
                    i.mainModSerial == item.orderItemSerial;
              });
            return result;
          },
          // direction: DismissDirection.endToStart,
          // onDismissed: (dir) {
          //   deleteItem(item ,context);
          // },
          key: Key(item.orderItemSerial.toString()),
          background: Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(20)),
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
            alignment: Alignment.center,
            color: isMod ? Colors.grey.shade400 : Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(item.itemName, style: TextStyle(fontSize:isMod ? 14 : 18)),
                    flex: 7),
                Expanded(
                    child: Text(item.itemPrice.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize:isMod ? 14 : 18)),
                    flex: 2),
                Expanded(
                    child: Text('1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize:isMod ? 14 : 18)),
                    flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderItemsTableRows(
      BuildContext context, RxList<Item> orderItems, Function delteItem) {
    List<Widget> itemsRows = [];

    for (var i = 0; i < orderItems.length; i++) {
      var activeItem = orderItems[i];
      itemsRows.add(itemRow(context, activeItem, orderItems, delteItem));
    }
    return Column(children: itemsRows);
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

  Scaffold orderItemsAndTotalsSide(
      BuildContext context,
      RxList<Item> orderItems,
      double totalAmount,
      Function deleteItem,
      TableModel config) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(config.docNo,
                    style: Theme.of(context).textTheme.headline1),
                Text(config.openDateTime,
                    style: Theme.of(context).textTheme.headline6)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            tableHeader(),
            orderItemsTableRows(context, orderItems, deleteItem)
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'total',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              totalAmount.toString(),
              style: Theme.of(context).textTheme.headline1,
            )
          ],
        ),
      ),
    );
  }
}
