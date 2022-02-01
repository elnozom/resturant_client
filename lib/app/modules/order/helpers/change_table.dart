
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/tables_form.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeTable  extends TablesForm implements ActionInterface{
  
  OrderProvider orderProvider = Get.put(new OrderProvider());

  @override
  String actionTitle = "change_table".tr;
  ChangeTable(TableModel config) : super(config);
  void reset(context) {
    err.value = false;
    selectedTable = null;
    Navigator.pop(context);
  }

  @override
  Widget generateForm(context) => Padding(padding: EdgeInsets.all(8) ,child :  Column(
    children: [
      chooseTableForm(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () => reset(context), child: Text("cancle".tr)),
          SizedBox(width:10),
          ElevatedButton(onPressed: () => submit(context), child: Text("submit".tr)),
        ],
      )
    ],
  ));

  @override
  void submit(context) {
    // print("submit");
     if (selectedTable == null) {
        err.value = true;
        return;
      }
      err.value = false;


    orderProvider.changeTable(config.serial, selectedTable!.serial)
        .then((value) {
      config.serial = selectedTable!.serial;
      reset(context);
    });

    print("orderItems");
  }
}
