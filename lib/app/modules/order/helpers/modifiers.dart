import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/item/modifier_item_model.dart';
import 'package:client_v3/app/data/models/item/item_provider.dart';
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/items.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Modifiers  {
  Rx<bool> err = false.obs;
  Rx<bool> modifiersLoading = true.obs;
  Map<int , List<ModiferItem>> modifiers = {};
  int itemSerial = 0;
  int orderItemSerial = 0;
  int screens = 0;
  int headSerial = 0;
  Rx<int> currentScreen = 0.obs;
  String selectedModifiers = "";
  int selected = 0;
  // ItemsUtil itemsUtil = ItemsUtil.instance;
  OrderProvider orderProvider = new OrderProvider();
  // ItemsUtil itemsUtil = ItemsUtil.instance;
  Modifiers() ;
  Future getModifires() async {
    modifiersLoading.value = true;
    ItemProvider itemProvider = new ItemProvider();
    await itemProvider.getItemModifers(itemSerial).then((value) {
      modifiers = value;
      screens = value.length;
      modifiersLoading.value = false;
      currentScreen.value = 1;
    });
  }

  void setHeadSerial(int val){
    headSerial = val;
  }
  void setOrderItemSerial(int val){
    orderItemSerial = val;
  }
  Future setItemSerial(int val) async{
    itemSerial = val;
    getModifires();
  }

  @override
  String actionTitle = "modifiers".tr;

  void reset(context) {
    err.value = false;
    selected = 0;
    modifiers = {};
    selectedModifiers = "";
    Navigator.pop(context);
  }
  Widget itemWidget(BuildContext context , ModiferItem item ){
    Rx<bool> isActive = false.obs;
    return GestureDetector(
        onTap: () {
           isActive.value = true;
          selectedModifiers += ",${item.itemSerial}";
       
          item.mainModSerial = orderItemSerial;
          selected++;
          if(selected == item.screenTimes){
            selected = 0;
            nextScreen(context);
          }
          // createItemModifers(context);
          // orderItems!.value.add(item);
          // if (currentModifiersindex.value < modifiersScreens!) {
          //   currentModifiersindex.value++;
          //   return;
          // }
        },
        child: Obx(() => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isActive.value
                ? Colors.green.shade900
                : Theme.of(context).primaryColor,),
            padding: EdgeInsets.fromLTRB(5, 5, 10, 0),
            child: Center(
              child: Text(
                item.itemName,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
            )),
      ));
  }
  Widget modifiersGrid(BuildContext context) {
    if (modifiersLoading.value) {
      return LoadingWidget();
    }
    List<Widget> widgets = [];
    for (var item in modifiers[currentScreen.value]!) {
      widgets.add(itemWidget(context , item));
      // widgets.add(SizedBox(height: 10,));
    }
    // return Column(children:widgets,);
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: 1.2,
            addRepaintBoundaries:false,
            // padding: EdgeInsets.all(10),
            crossAxisCount: MediaQuery.of(context).size.width < 960 ? 4 : 8,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widgets));
  }

  void nextScreen(context){
    selected = 0;
    currentScreen.value == modifiers.length  ? submit(context) : currentScreen.value++;
  }
  @override
  Widget generateForm(context) => Obx(() => 
  modifiersLoading.value ? LoadingWidget() :
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
          children: [
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              
            ElevatedButton(onPressed: () {nextScreen(context);}, child: Text('next'.tr)),
            ElevatedButton(onPressed: () {submit(context);}, child: Text('done'.tr)),
            ],)),
            
             SizedBox(
                    height: 400,
            child : modifiersGrid(context)
             )
            // Text(modifiers[currentScreen.value]!.toString()),
            //  Obx(() => err.value
            //     ? Text("choose_waiter".tr , style: TextStyle(color:Colors.red)) : SizedBox()),
            // Obx(() => modifiersLoading.value
            //     ? LoadingWidget()
            //     : waitersAutocomplete()),
            // ElevatedButton(
            //     onPressed: () {
            //       submit(context);
            //     },
            //     child: Text("submit".tr))
          ],
        ),
  ));

  @override
  void submit(context) {
    String sreials = selectedModifiers.substring(1);
    Map insertItemModifersReq = {
      "ItemsSerials": sreials,
      "HeadSerial": headSerial,
      "OrderItemSerial": orderItemSerial
    };
    orderProvider.createOrderItemModifers(insertItemModifersReq).then((value) {
      // itemsUtil.listOrderItems();
      ItemsUtil.instance.listOrderItems();
      reset(context);
      selectedModifiers = "";
    });
  }
}
