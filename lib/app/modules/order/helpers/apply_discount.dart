import 'package:client_v3/app/data/models/discount/discount_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/controllers/order_controller.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/data/models/customer/customer_model.dart';
import 'package:client_v3/app/data/models/customer/customer_provider.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyDiscount extends UpdateActions implements ActionInterface {
  Rx<bool> discountsLoading = false.obs;
  List<Discount> discounts = [];
  Discount? selectedDiscount;
  TextEditingController discountCommentInput = new TextEditingController();
  FocusNode discountCommentFocus = new FocusNode();
  Rx<bool> err = false.obs;
  ApplyDiscount(TableModel config) : super(config) {
    getDiscounts();
  }

  @override
  String actionTitle = "change_guest_no".tr;

  void reset(context) {
    err.value = false;
    Navigator.pop(context);
  }

  List<DropdownMenuItem<Discount>> discountsDropDown() {
    List<DropdownMenuItem<Discount>> list = [];
    for (var i = 0; i < discounts.length; i++) {
      list.add(DropdownMenuItem<Discount>(
          child: Text(discounts[i].discDesc), value: discounts[i]));
    }
    return list;
  }

  Future getDiscounts() async {
    discountsLoading.value = true;
    await orderProvider.listDiscounts().then((value) {
      discounts = value;
      discountsLoading.value = false;
    });
  }

  @override
  Widget generateForm(context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => err.value
                ? Text("choose_discount_type".tr,
                    style: TextStyle(color: Colors.red))
                : SizedBox()),
            Obx(
              () => discountsLoading.value
                  ? LoadingWidget()
                  : DropdownButton<Discount>(
                      isExpanded: true,
                      items: discountsDropDown(),
                      onChanged: (Discount? discount) {
                        selectedDiscount = discount;
                        FocusScope.of(context)
                            .requestFocus(discountCommentFocus);
                      },
                      value: selectedDiscount,
                      hint: Text("choose_discount".tr),
                    ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'comment'.tr,
                hintText: 'comment'.tr,
              ),
              controller: discountCommentInput,
              focusNode: discountCommentFocus,
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  submit(context);
                },
                child: Text("apply".tr))
          ],
        ),
      );

  @override
  void submit(context) {
    if (selectedDiscount == null) {
      err.value = true;
      return;
    }
    Map req = {
      "HeadSerial": config.serial,
      "Comment": discountCommentInput.text,
      "DiscCode": selectedDiscount!.discCode,
      "DiscValue": selectedDiscount!.discValue
    };
    OrderController controller = Get.find<OrderController>();
    orderProvider.applyDiscount(req).then((value) {
      controller.hasDiscount.value = true;
      controller.config.discountPercent = selectedDiscount!.discValue.toInt();
      reset(context);
    });
  }
}
