import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/items.dart';
import 'package:client_v3/app/modules/order/helpers/tables_form.dart';
import 'package:client_v3/app/modules/order/helpers/transfer_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transfer extends TablesForm with TransferWidgets implements ActionInterface {
  Rx<int> currentStep = 0.obs;
 
  // ItemsUtil itemsUtil = ItemsUtil.instance;

  Transfer(TableModel config , int empCode) : super(config , empCode , true); 
  List<Step> stepList(context) => [
        Step(
            title: Text('choose_table'),
            content: chooseTableForm(),
            isActive: currentStep.value == 0),
        Step(
            title: Text('transfer_items'),
            content: Center(
              child: transferItemsWidget(context),
            ),
            isActive: currentStep.value == 1),
      ];

  @override
  String actionTitle = "transfer_items".tr;

  void reset(context) {
    err.value = false;
    currentStep.value = 0;
    selectedTable = null;
    transferedOrderItems = [];
    Navigator.pop(context);
  }

  @override
  Widget generateForm(context) => Obx(() => Stepper(
        onStepCancel: () => reset(context),
        onStepContinue: () => submit(context),
        steps: stepList(context),
        type: StepperType.horizontal,
        currentStep: currentStep.value,
      ));

  @override
  void submit(context) {
    // print("submit");
    if (currentStep.value == 0) {
      if (selectedTable == null) {
        err.value = true;
        return;
      }
      err.value = false;
      listOrderItems(orderProvider , config.headSerial);
      currentStep.value++;
    }

    String transferedOrderItemsStr = "";
    for (var item in transferedOrderItems) {
      transferedOrderItemsStr += ",${item.orderItemSerial}";
    }
    transferedOrderItemsStr = transferedOrderItemsStr.substring(1);

    orderProvider
        .transferIems(
            transferedOrderItemsStr, config.waiterCode, selectedTable!.serial , false)
        .then((value) {
      reset(context);
          // itemsUtil.listOrderItems();

    });
  }
}
