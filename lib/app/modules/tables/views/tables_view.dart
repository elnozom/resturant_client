import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/widgets/loading.dart';
import '../controllers/tables_controller.dart';
class TablesView extends GetView<TablesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey.shade100,
                toolbarHeight: 90,
                 automaticallyImplyLeading: false,
                elevation: .9,
                title: Obx(() => controller.groupLoading.value ? LoadingWidget() : controller.widgets.tabsGroups(controller.groups , controller.getTables , controller.activeGroup) )
                ),
              body: Container(
                padding:EdgeInsets.all(10),
                color: Colors.white,
                // padding: const EdgeInsets.only(top: 30.0),
                child: Obx(() {
                  return controller.loading.value ? LoadingWidget() : controller.widgets.tablesWidget(controller.tables, controller.chooseTable, context);
                }) 
              )
        );
      
   
  }
}
