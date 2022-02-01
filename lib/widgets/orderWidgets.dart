import 'package:client_v3/app/data/models/group/subgroup_model.dart';
import 'package:client_v3/app/modules/order/controllers/order_controller.dart';
import 'package:client_v3/app/modules/order/helpers/apply_discount.dart';
import 'package:client_v3/app/modules/order/helpers/change_customer.dart';
import 'package:client_v3/app/modules/order/helpers/change_guests.dart';
import 'package:client_v3/app/modules/order/helpers/change_table.dart';
import 'package:client_v3/app/modules/order/helpers/change_waiter.dart';
import 'package:client_v3/app/modules/order/helpers/split.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/side_bar_item_model.dart';
import 'package:client_v3/app/widgets/mainGroup.dart';
import 'package:client_v3/app/modules/order/helpers/transfer.dart';

class OrderWidgets extends GetView<OrderController> {
  Widget build(BuildContext context) {
    return Text("asd");
  }

  // final OrderController controller = Get.put(OrderController());
  //items section
  late Transfer transferClass = Get.put(Transfer(controller.config));
  late ChangeTable chgTableClass = Get.put(ChangeTable(controller.config));
  late ChangeCustomer chgCustomerleClass =
      Get.put(ChangeCustomer(controller.config));
  late ChangeWaiter chgWaiterClass = Get.put(ChangeWaiter(controller.config));
  late ChangeGuestsNo chgGuestsNo = Get.put(ChangeGuestsNo(controller.config));
  late ApplyDiscount applyDisc = Get.put(ApplyDiscount(controller.config));
  late Split split = Get.put(Split(controller.config));
  late List<SideBarItem> sideBarItems = [
    SideBarItem(
        title: "split_cheq".tr,
        icon: Icon(Icons.call_split, color: Colors.black),
        action: split),
    SideBarItem(
        title: 'transfer'.tr,
        icon: Icon(Icons.transform, color: Colors.black),
        action: transferClass),
    SideBarItem(
        title: 'change_table'.tr,
        icon: Icon(Icons.table_chart, color: Colors.black),
        action: chgTableClass),
    SideBarItem(
        title: 'change_customer'.tr,
        icon: Icon(Icons.person_outline, color: Colors.black),
        action: chgCustomerleClass),
    SideBarItem(
        title: 'change_waiter'.tr,
        icon: Icon(Icons.engineering, color: Colors.black),
        action: chgWaiterClass),
    SideBarItem(
        title: 'no_of_guests'.tr,
        icon: Icon(Icons.pin, color: Colors.black),
        action: chgGuestsNo),
    SideBarItem(
        title: 'apply_Discount'.tr,
        icon: Icon(Icons.money_off, color: Colors.black),
        action: applyDisc),
  ];

  Widget itemWidget(BuildContext context, Item item) {
    Rx<bool> isActive = false.obs;
    isActive.value = item.qnt > 0;
    item.qntReactive = item.qnt.obs;
    return GestureDetector(
      onTap: () {
        isActive.value = true;
        controller.addItem(context, item);
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
    );
  }

  Widget itemsGrid(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width > 960;
    List<Widget> widgets = [];
    var items = controller.items!;
    //check that items is empty
    // length will be one because tthe empty item in the first of array used to avoid bug
    if (items.length == 0) {
      return Center(
          child: Text("no_items".tr, style: TextStyle(color: Colors.black)));
    }
    for (var item in items.value) {
      widgets.add(
        itemWidget(context, item),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: isMobile ? .8 : 1,
            padding: EdgeInsets.all(10),
            crossAxisCount: isMobile ? 4 : 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widgets));
  }

  //subgroups section
  Widget subGroupWidget(SubGroupModel item) {
    return GestureDetector(
        onTap: () {
          controller.activeSubGroup = item.groupCode;
          controller.listItems();
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
                      item.groupName,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ))
              ],
            ),
          ),
        ));
  }

  Widget subGroupsList(context) {
    List<Widget> groups = [];
    bool isMobile = MediaQuery.of(context).size.width > 960;
    for (var item in controller.subGroups!.value) {
      groups.add(subGroupWidget(item));
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: isMobile ? .8 : 1,
            padding: EdgeInsets.all(10),
            crossAxisCount: 1,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: groups));
  }

  // left sidebar secttion
  Widget leftSideBarItemWidget(BuildContext context, SideBarItem item) {
    return GestureDetector(
        onTap: () {
          if (item.title == "split_cheq".tr) split.listItems();
          controller.openUpdateModal(item.action, context);
        },
        child: Column(children: [
          item.icon,
          Text(item.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1)
        ]));
  }

  List<Widget> leftSideBarItems(context) {
    List<Widget> items = [];
    for (var item in sideBarItems) {
      items.add(leftSideBarItemWidget(context, item));
      items.add(SizedBox(height: 30));
    }
    return items;
  }

  Container leftSideBar(BuildContext context) {
    return Container(
      child: Container(
          child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: leftSideBarItems(context),
          ),
        ),
      )),
    );
  }

  // maingroups section
  Widget mainGroupWidget(GroupModel group) {
    return GestureDetector(
        onTap: () {
          controller.listSubGroups(group.groupCode);
        },
        child: MainGroup(title: group.groupName, icon: group.icon));
  }

  List<Widget> mainGroupsItems() {
    List<Widget> items = [];
    for (var group in controller.mainGroups) {
      items.add(mainGroupWidget(group!));
    }
    return items;
  }

  Widget mainGroupsListAtBottom() {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: mainGroupsItems()),
        padding: EdgeInsets.all(10),
      ),
    );
  }

  // delete item
  Future<bool> deleteConfirmDialog(BuildContext context, Item item) async {
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
                controller.deleteItem(item);
                Get.back(result: true);
              },
            ),
          ],
        )));
    return result;
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
        height: isMod ? 30 : item.addItems == "" ? 40 : 55,
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
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(item.itemName,
                        style: TextStyle(fontSize: isMod ? 14 : 18)),
                      if(item.addItems != "")  Text(item.addItems ,style: TextStyle(fontSize: 10 , color: Colors.grey.shade800))
                  ],
                ),
                flex: 7),
            Expanded(
                child: Text(item.itemPrice.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMod ? 14 : 18)),
                flex: 2),
            Expanded(
                child: Text('1',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isMod ? 14 : 18)),
                flex: 2),
                if(!isMod) GestureDetector(
                   onTap: (){
                     controller.addons.setItemSerial(context , item.orderItemSerial);
                   },
                                    child: Expanded(
                child: Icon(Icons.add_circle_outline,
                                            color: Colors.black,
                                            size: 20),
                flex: 1),
                 ),
                
          ],
        ),
      ),
    );
  }

  Widget orderItemsTableRows(BuildContext context) {
    List<Widget> itemsRows = [];
    for (var item in controller.orderItems!.value) {
      itemsRows.add(itemRow(context, item));
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

  Scaffold orderItemsAndTotalsSide(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.config.docNo,
                    style: Theme.of(context).textTheme.headline1),
                Text(controller.config.openTime,
                    style: Theme.of(context).textTheme.headline6)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            tableHeader(),
            orderItemsTableRows(context)
          ]),
        ),
      ),
      bottomNavigationBar: Obx(()  {
        return Container(
        height:controller.hasDiscount.value ? 160 :125,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'subtotal'.tr,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  controller.totalAmount.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'TAX'.tr,
                    style: Theme.of(context).textTheme.headline1,
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              '(14%)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text(
                  (controller.totalAmount * .14).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
            if( controller.hasDiscount.value ) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'discount'.tr,
                    style: Theme.of(context).textTheme.headline1,
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              '(${controller.config.discountPercent.toString()}%)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text(
                  ( controller.config.discountPercent.toDouble() * controller.totalAmount.value / 100.0).toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  (controller.totalAmount + (controller.totalAmount * .14))
                      .toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            ),
          ],
        ),
      );
      }  ) 
    );
  }
}
