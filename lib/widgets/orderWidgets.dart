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
import 'package:client_v3/app/data/models/side_bar_item_model.dart';
import 'package:client_v3/app/widgets/mainGroup.dart';
import 'package:client_v3/app/modules/order/helpers/transfer.dart';

class OrderWidgets extends GetView<OrderController> {
  Widget build(BuildContext context) {
    return Text("asd");
  }

  // final OrderController controller = Get.put(OrderController());
  //items section
  late Transfer transferClass = Get.put(Transfer(controller.config ,  controller.emp.empCode));
  late ChangeTable chgTableClass = Get.put(ChangeTable(controller.config , controller.emp.empCode));
  late ChangeCustomer chgCustomerleClass =
      Get.put(ChangeCustomer(controller.config));
  late ChangeWaiter chgWaiterClass = Get.put(ChangeWaiter(controller.config));
  late ChangeGuestsNo chgGuestsNo = Get.put(ChangeGuestsNo(controller.config));
  late ApplyDiscount applyDisc = Get.put(ApplyDiscount(controller.config,controller.emp ));
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


  //subgroups section
  Widget subGroupWidget(SubGroupModel item) {
    return GestureDetector(
        onTap: () {
          // controller.activeSubGroup = item.groupCode;
          // controller.listItems();
          controller.itemsC.setGroupSerial(item.groupCode);
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
    var totals = controller.totals.getTotals();
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
              controller.itemsC.orderItemsTableRows(context)
            ]),
          ),
        ),
        bottomNavigationBar: Obx(() {
          return Container(
            height: controller.hasDiscount.value ? 160 : 125,
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
                      totals.amount.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
                if(totals.taxPercent > 0)  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'tax'.tr,
                        style: Theme.of(context).textTheme.headline1,
                        children: <TextSpan>[
                          TextSpan(
                              text: '(${totals.taxPercent}%)',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Text(
                      totals.tax.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
                if (controller.hasDiscount.value)
                  Row(
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
                        totals.discount
                            .toStringAsFixed(2),
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
                      totals.total.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline1,
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
