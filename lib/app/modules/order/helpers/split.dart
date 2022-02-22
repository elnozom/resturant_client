import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/items.dart';
import 'package:client_v3/app/modules/order/helpers/tables_form.dart';
import 'package:client_v3/app/modules/order/helpers/transfer_widgets.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Split extends UpdateActions with TransferWidgets implements ActionInterface {
  Rx<int> currentStep = 0.obs;
  ItemsUtil itemsUtil = ItemsUtil.instance;
 
  @override
  String actionTitle = "split_cheq".tr;

  Split(TableModel config) : super(config);

  Future listItems() async{
   listOrderItems(orderProvider, config.headSerial);
  }



  void reset(context) {
    err.value = false;
    currentStep.value = 0;
    transferedOrderItems = [];
    Navigator.pop(context);
  }

  @override
  Widget generateForm(context) => Column(
    children: [
      transferItemsWidget(context),
      ElevatedButton(onPressed: () => submit(context), child: Text("save".tr))
    ],
  );


  @override
  void submit(context)  {
    // print("submit");
    String transferedOrderItemsStr = "";
    for (var item in transferedOrderItems) {
      transferedOrderItemsStr += ",${item.orderItemSerial}";
    }
    transferedOrderItemsStr = transferedOrderItemsStr.substring(1);

    orderProvider
        .transferIems(
            transferedOrderItemsStr, config.waiterCode, config.serial , true)
        .then((value) async  {
          insertLoading.value = true;
          transferIetmsLoading.value = true;
          await listItems();
          transferedOrderItems =[];
          print(transferedOrderItems);
          transferIetmsLoading.value = false;
          insertLoading.value = false;
          itemsUtil.listOrderItems();

     if(orderItems.length == 1) {
       reset(context);
     }

    });
  }
}
