import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/widgets/loading.dart';
import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 960;
    return Center(
        child: Obx(
      () => controller.loading.value
          ? LoadingWidget()
          : WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  floatingActionButton: Obx(()=> FloatingActionButton(child: controller.notification.notificationWidget(context , controller.cartCount.value),onPressed: (){},)),
                  appBar: AppBar(
                    centerTitle: true,
                    iconTheme: IconThemeData(color: Colors.white),
                    automaticallyImplyLeading: isMobile,
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              height: isMobile ? 30 : 50,
                              child: Image(
                                  image: AssetImage('assets/images/icon.png'))),
                          Row(
                            children: [
                              if (isMobile)
                                GestureDetector(
                                  onTap: () => controller.openItems(context),
                                  child: Column(
                                    children: [
                                      Icon(Icons.money,
                                          color: Colors.white,
                                          size: isMobile ? 25 : 40),
                                      Text('items'.tr,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16))
                                    ],
                                  ),
                                ),
                              SizedBox(width: isMobile ? 10 : 30),
                              GestureDetector(
                                  onTap: () {
                                    controller.printReceipt();
                                  },
                                                              child: Column(
                                  children: [
                                    Icon(Icons.print_outlined,
                                        color: Colors.white,
                                        size: isMobile ? 25 : 40),
                                    Text('print'.tr,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: isMobile ? 16 : 18))
                                  ],
                                ),
                              ),
                              SizedBox(width: isMobile ? 10 : 30),
                              GestureDetector(
                                  onTap: () {
                                    controller.tableProvider.tablesCloseOrder(
                                        controller.config.serial , controller.config.headSerial).then((value) {
                                          Get.offAllNamed("/home");
                                        }).catchError((err) {
                                          print(err);
                                        });
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.send_outlined,
                                          color: Colors.white,
                                          size: isMobile ? 25 : 40),
                                      Text('send'.tr,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isMobile ? 16 : 18))
                                    ],
                                  )),
                                  
                                  SizedBox(width: isMobile ? 10 : 30),
                             
                              GestureDetector(
                                  onTap: () {
                                    if(controller.itemsC.orderItems.length == 0){
                                      Get.snackbar("error".tr, "choose_item".tr);
                                      return ;
                                    }
                                    List<Item> items = controller.itemsC.orderItems;
                                    items.removeWhere((i) => i.itemPrice == 0);
                                    int lstSerial = items[items.length - 1].orderItemSerial;
                                   controller.addons.setItemSerial(context, lstSerial);
                                   controller.reloadItems = true;
                                  },
                                  child: Column(
                                    children: [
                                      Icon(Icons.add_circle_outline,
                                          color: Colors.white,
                                          size: isMobile ? 25 : 40),
                                      Text('addons'.tr,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isMobile ? 16 : 18))
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    toolbarHeight: 75.0,
                  ),
                  drawer: isMobile
                      ? SizedBox(
                          width: 100,
                          child: Drawer(
                            // Add a ListView to the drawer. This ensures the user can scroll
                            // through the options in the drawer if there isn't enough vertical
                            // space to fit everything.
                            child: controller.widgets
                                .leftSideBar(context),
                          ),
                        )
                      : null,
                  body: Container(
                    child: Row(children: [
                      if (!isMobile)
                        SizedBox(
                          width: 80,
                          child: controller.widgets
                              .leftSideBar(context),
                        ),
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Container(
                            height: double.infinity,
                            // color: Colors.grey.shade100,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Expanded(
                                      child: Obx(() =>
                                          controller.itemsC.itemsLoading.value
                                              ? LoadingWidget()
                                              : controller.itemsC
                                                  .itemsGrid(context)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                      width: 125,
                                      child: Container(
                                          child: Obx(() =>
                                              controller.subGroupsLoading.value
                                                  ? LoadingWidget()
                                                  : controller.widgets
                                                      .subGroupsList(context))))
                                ],
                              ),
                            )),
                      ),
                      if (!isMobile)
                        Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Container(
                                height: double.infinity,
                                color: Colors.grey.shade100,
                                child: controller.widgets
                                      .orderItemsAndTotalsSide(context))),
                    ]),
                  ),
                  bottomNavigationBar: controller.widgets.mainGroupsListAtBottom()),
            ),
    ));
  }
}
