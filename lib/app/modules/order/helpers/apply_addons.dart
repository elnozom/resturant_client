import 'package:client_v3/app/data/models/discount/discount_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/controllers/order_controller.dart';
import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:client_v3/app/modules/order/helpers/updateActions.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplyAddon extends UpdateActions implements ActionInterface {
  Rx<bool> addonsLoading = false.obs;
  List<String> addons = [];
  String addonsToApply = "";
  ApplyAddon(TableModel config) : super(config) {
    getAddons();
  }

  @override
  String actionTitle = "change_guest_no".tr;

  void reset(context) {
    Navigator.pop(context);
  }

  Future getAddons() async {
    addonsLoading.value = true;
    await orderProvider.listAddons().then((value) {
      addons = value;
      addonsLoading.value = false;
    });
  }

  // @override
  // Widget generateForm(context) => Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           Obx(() => err.value
  //               ? Text("choose_discount_type".tr,
  //                   style: TextStyle(color: Colors.red))
  //               : SizedBox()),
  //           Obx(
  //             () => addonsLoading.value
  //                 ? LoadingWidget()
  //                 : DropdownButton<Discount>(
  //                     isExpanded: true,
  //                     items: discountsDropDown(),
  //                     onChanged: (Discount? discount) {
  //                       selectedDiscount = discount;
  //                       FocusScope.of(context)
  //                           .requestFocus(discountCommentFocus);
  //                     },
  //                     value: selectedDiscount,
  //                     hint: Text("choose_discount".tr),
  //                   ),
  //           ),
  //           TextField(
  //             decoration: InputDecoration(
  //               labelText: 'comment'.tr,
  //               hintText: 'comment'.tr,
  //             ),
  //             controller: discountCommentInput,
  //             focusNode: discountCommentFocus,
  //           ),
  //           SizedBox(height: 10),
  //           ElevatedButton(
  //               onPressed: () {
  //                 submit(context);
  //               },
  //               child: Text("apply".tr))
  //         ],
  //       ),
  //     );

  @override
  void submit(context) {
    orderProvider.applyAddons(1 , addonsToApply).then((value) {
      reset(context);
    });
  }

  @override
  Widget generateForm(context) {
    // TODO: implement generateForm
    throw UnimplementedError();
  }
}
