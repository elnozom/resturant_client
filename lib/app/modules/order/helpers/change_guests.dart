import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/data/models/customer/customer_model.dart';
import 'package:client_v3/app/data/models/customer/customer_provider.dart';
import 'package:client_v3/app/modules/order/helpers/toatls.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeGuestsNo extends UpdateActions implements ActionInterface {
    TextEditingController gueststInput = new TextEditingController();
  Rx<bool> err = false.obs;
  ChangeGuestsNo(TableModel config) : super(config);
 
  @override
  String actionTitle = "change_guest_no".tr;

  @override
  void reset(context) {
    err.value = false;
    Navigator.pop(context);
  }

  @override
  Widget generateForm(context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
          children: [
            Obx(() => err.value
                ? Text("enter_valid_no".tr , style: TextStyle(color:Colors.red)) : SizedBox()),
           TextField(
                    decoration: InputDecoration(
                      labelText: 'no_of_guests'.tr,
                    ),
                      keyboardType: TextInputType.number,
                    controller: gueststInput,
                  ),
            ElevatedButton(
                onPressed: () {
                  submit(context);
                },
                child: Text("submit".tr))
          ],
        ),
  );

  @override
  void submit(context) {
    if (gueststInput.text == null) {
      err.value = true;
      return;
    }
    Map req = {
      "HeadSerial": config.headSerial,
      "Guests": int.parse(gueststInput.text),
    };
    orderProvider.changeNoOfGuests(req).then((value) {
      Totals totals = Totals.instance;
      totals.setGuests(int.parse(gueststInput.text));
     reset(context);
    });
  }
}
