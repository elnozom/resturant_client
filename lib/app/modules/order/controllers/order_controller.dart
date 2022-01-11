import 'package:client_v3/app/data/models/side_bar_item_model.dart';
import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/group/group_model.dart';
import 'package:client_v3/app/data/models/group/group_provider.dart';
import 'package:client_v3/app/data/models/group/subgroup_model.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/item/item_provider.dart';
import 'package:client_v3/app/data/models/order/order_model.dart';
import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:client_v3/widgets/orderWidgets.dart';

class OrderController extends GetxController with GetSingleTickerProviderStateMixin {
  GroupProvider groupProvider = new GroupProvider();
  ItemProvider itemProvider = new ItemProvider();
  TableProvider tableProvider = new TableProvider();
  List<GroupModel?> mainGroups = [];
  int? activeMainGroup;
  int? activeSubGroup;
  Rx<bool> loading = true.obs;
  Rx<bool> subGroupsLoading = true.obs;
  Rx<bool> itemsLoading = true.obs;
  Rx<bool> orderItemsLoading = true.obs;
  Rx<double> totalAmount = 0.0.obs;
  RxList<SubGroupModel>? subGroups;
  RxList<Item>? items;
  RxList<Item> orderItems =[Item.newInstance()].obs;
  Rx<int> currentModifiersindex = 1.obs;
  int? modifiersScreens;
  TableModel config = Get.arguments;
  final OrderWidgets widgets = new OrderWidgets();
  int headSerial = 0;
  OrderProvider orderProvider = new OrderProvider();
  bool createOrderLoading = false;
  AnimationController? animationController;
  final duration = const Duration(milliseconds: 1000);
  String modifersSerials = "";
  List<TableGroup> tableGroups = [TableGroup.newInstance()].obs;
  RxList<TableModel> tables = [TableModel.newInstance()].obs;
  Rx<bool> groupLoading = true.obs;
  Rx<bool> tableLoading = true.obs;
  Rx<int> activeGroup = 0.obs;
  TableGroup? selectedTableGroup ;
  Rx<TableModel?>? selectedTable;
late List<SideBarItem> sideBarItems = [
    SideBarItem(
        title: "split_cheq",
        icon: Icon(Icons.call_split, color: Colors.black),
        action: () => {print("hi")}),
    SideBarItem(
        title: 'transfer',
        icon: Icon(Icons.transform, color: Colors.black),
        action: () => {print("hi")}),
    SideBarItem(
        title: 'change table',
        icon: Icon(Icons.table_chart, color: Colors.black),
        action: changeTable),
    SideBarItem(
        title: 'change customer',
        icon: Icon(Icons.person_outline, color: Colors.black),
        action: () => {print("hi")}),
    SideBarItem(
        title: 'change waiter',
        icon: Icon(Icons.engineering, color: Colors.black),
        action: () => {print("hi")}),
    SideBarItem(
        title: 'apply Minimum',
        icon: Icon(Icons.monetization_on, color: Colors.black),
        action: () => {print("hi")}),
    SideBarItem(
        title: 'Apply Taxes',
        icon: Icon(Icons.money_rounded, color: Colors.black),
        action: () => {print("hi")}),
  ];
  void closeTable() {
    print(config.serial);
    TableProvider().tablesCloseOrder(config.serial);
    // Get.toNamed('login' , arguments: config);
  }

  void listMainGroups() {
    groupProvider.listMainGroups().then((value) {
      mainGroups = value;
      listSubGroups(mainGroups.first!.groupCode);
    });
  }

  Future getTablesGroups(context) async{
    groupLoading.value = true;
    tableProvider.groupTablesList().then((value) {
      tableGroups = value;
      selectedTableGroup = tableGroups.first;
      getTables(tableGroups.first.groupTableNo);
      groupLoading.value = false;
      changeTable(context);
    });
  }
  void getTables(int no) {
    tableLoading.value = true;
    activeGroup.value = no;
    selectedTable = null;
    tableProvider.tablesListByGroupNo(no).then((value) {
      print(value);
      tableLoading.value = false;
      // success call back
      tables.value = value;
      tableLoading.value = false;
    });
  }


  List<DropdownMenuItem<TableGroup>> groupsDropDown(){
    List<DropdownMenuItem<TableGroup>> list = [];
    for (var i = 0; i < tableGroups.length; i++) {
      list.add(DropdownMenuItem<TableGroup>(child: Text(tableGroups[i].groupTableName) , value: tableGroups[i]));
    }
    return list;
  }
  List<DropdownMenuItem<TableModel>> tablesDropDown(){
    List<DropdownMenuItem<TableModel>> list = [];
    for (var i = 0; i < tables.length; i++) {
      list.add(DropdownMenuItem<TableModel>(child: Text(tables[i].tableName) , value: tables[i]));
    }
    return list;
  }
  void changeTableSubmit(context) {
    orderProvider.changeTable(config.serial , selectedTable!.value!.serial).then((value){
      config.serial = selectedTable!.value!.serial;
      Navigator.pop(context);
    });
  }
  void changeTable(context) async{
    if(tableGroups[0].groupTableNo == 0){
      await getTablesGroups(context);
      return ; 
    }


    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight :Radius.circular(20.0) , topLeft: Radius.circular(20.0))
      ),
      child: Column(
                children: [
                  Center(
                      child: Text(
                    "choose_table".tr,
                    style: TextStyle(color: Colors.black),
                  )),
                   Obx(() => 
                    tableLoading.value ?  LoadingWidget() : DropdownButton<TableGroup>(items: groupsDropDown(), onChanged: (TableGroup? group){
                    getTables(group!.groupTableNo);
                    selectedTableGroup = group;
                  } , hint: Text("choose_table_group".tr),value: selectedTableGroup)),
                  Obx(() => 
                    tableLoading.value ? LoadingWidget() : DropdownButton<TableModel>(items: tablesDropDown(), onChanged: (TableModel? table){
                    selectedTable = table.obs;
                  } , hint: Text("choose_table".tr),value: selectedTable == null ? null : selectedTable!.value)
                  ),
                  ElevatedButton(onPressed: (){
                    changeTableSubmit(context);
                  }, child: Text("change".tr))
                  

                  // ElevatedButton(
                  //   child: Text("done".tr),
                  //   onPressed: () {
                  //     createItemModifers(context, item.orderItemSerial);
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 400,
                  //   child: modifiersGrid(context,
                  //       modifiers[currentModifiersindex.value], item.orderItemSerial),
                  // ),
                ],),
    ));
  }
  void debugPrint(){
    for (var i = 0; i < orderItems.value.length; i++) {
      var active = orderItems.value[i];
      print(active.itemName);
      print(active.mainModSerial);
    }
  }
  void createItem(Item item) {
    
    Map i = {
      "HeadSerial": config.headSerial,
      "ItemSerial": item.itemSerial,
      "WithMod": item.withModifier,
      "IsMod": false,
    };

    orderProvider.createOrderItem(i).then((value) {
      item.orderItemSerial = value;
      item.qnt!.value++;
      totalAmount.value += item.itemPrice;
      orderItems.value.add(item);
      debugPrint();
    });
  }

  void deletItem(Item item) {
    orderProvider.deleteOrderItem(item.orderItemSerial).then((value) {
      // orderItems.value.removeWhere((Item i) {
      //   return i.orderItemSerial == item.orderItemSerial || i.mainModSerial == item.orderItemSerial;
      // });
      item.qnt!.value--;
    });
  }

  void getItemModifers(item, context) {
    var modifiers;
    ItemProvider().getItemModifers(item.itemSerial).then((value) {
      modifiers = value;
      modifiersScreens = modifiers.length;
      currentModifiersindex.value = 1;
      Get.bottomSheet(Obx(() {
        return WillPopScope(
          onWillPop: () async => true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                    child: Text(
                  " ${currentModifiersindex} اضافة",
                  style: TextStyle(color: Colors.black),
                )),
                ElevatedButton(
                  child: Text("done".tr),
                  onPressed: () {
                    createItemModifers(context, item.orderItemSerial);
                  },
                ),
                SizedBox(
                  height: 400,
                  child: modifiersGrid(context,
                      modifiers[currentModifiersindex.value], item.orderItemSerial),
                ),
              ],
            ),
          ),
        );
      }),
          elevation: 20.0,
          enableDrag: false,
          backgroundColor: Colors.white,
          persistent: true,
          isDismissible: false,
          useRootNavigator: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          )));
    });
  }

  void addItem(BuildContext context, Item item) async {
    if (createOrderLoading == true) return;
    if (config.headSerial == 0) {
      await createOrder(context , item);
      return ; 
    }
    if (item.withModifier) {
      createItem(item);
      getItemModifers(item, context);
      return;
    }
    createItem(item);
  }

  Future createOrder(BuildContext context , Item item) async {
    createOrderLoading = true;
    String imei = await DeviceInformation.deviceIMEINumber;
    Order order = new Order(
        tableSerial: config.serial,
        imei: imei,
        orderType: 2,
        waiterCode: config.waiterCode);
    orderProvider.createOrder(order).then((value) {
      DateTime now = new DateTime.now();
      config.headSerial = value.headSerial;
      config.docNo = value.docNo;
      config.openDateTime = "${now.hour} : ${now.minute}";
      createOrderLoading = false;
      addItem(context , item);
      
    });
  }


  void openItems(context) {

    Get.bottomSheet(
        Obx(() { 
          if (orderItemsLoading.value ) return LoadingWidget();
          if (orderItems == null || orderItems.value.length ==  0 ) return Container( height : 100, child: Center(child: Text("no_items".tr , style: TextStyle(color: Colors.black),) ));
          return widgets.orderItemsAndTotalsSide(
                context, orderItems, totalAmount.value, deletItem , config);}),
        elevation: 20.0,
        enableDrag: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )));
  }

  void createItemModifers(BuildContext context, int orderItemSerial) {
    // remove the first comma from modifiers serials string 
    // ",1,2,3" => "1,2,3"
    String sreials = modifersSerials.substring(1);
    print("done");
    Map insertItemModifersReq = {
      "ItemsSerials": sreials,
      "HeadSerial": config.headSerial,
      "OrderItemSerial": orderItemSerial
    };
    orderProvider.createOrderItemModifers(insertItemModifersReq).then((value) {
      modifersSerials = "";
      Navigator.pop(context);
    });
  }

  Widget modifiersGrid(context, items, orderItemSerial) {
    if (itemsLoading.value) {
      return LoadingWidget();
    }
    List<Widget> widget = [];
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      widget.add(GestureDetector(
        onTap: () {
          modifersSerials += ",${item.itemSerial}";
          item.mainModSerial = orderItemSerial;
          print(item.mainModSerial);
          orderItems.value.add(item);
          if (currentModifiersindex.value < modifiersScreens!) {
            currentModifiersindex.value++;
            return;
          }
          createItemModifers(context, orderItemSerial);
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor),
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
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: .8,
            padding: EdgeInsets.all(10),
            crossAxisCount: MediaQuery.of(context).size.width < 960 ? 4 :8,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widget));
  }

  void listSubGroups(int group) {
    subGroupsLoading.value = true;
    groupProvider.listSubGroups(group as int).then((value) {
      subGroups = value!.obs;
      activeSubGroup = subGroups!.value.first.groupCode;
      subGroupsLoading.value = false;

      loading.value = false;
      listItems(subGroups!.value.first.groupCode);
    });
  }
  void listItems(int subGroup) {
    itemsLoading.value = true;
    itemProvider.listItemsByGroup(subGroup).then((value) {
      items = value.obs;
      itemsLoading.value = false;
      loading.value = false;
    });
  }
  void listOrderItems(int headSerial) {
    // itemsLoading.value = true;
    orderItemsLoading.value = true;
    orderProvider.listOrderItems(headSerial).then((value) {
      orderItems = value.obs;
      orderItemsLoading.value = false;
    }).onError((error, stackTrace){
      print(error);
      Get.snackbar("error".tr, "connection_error".tr);
    });
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(duration: duration, vsync: this);
    listMainGroups();
  }

  @override
  void onReady() {
    super.onReady();

    totalAmount.value = config.totalCash;
    if (config.headSerial != 0) {
      listOrderItems(config.headSerial);
      return;
    }
    orderItemsLoading.value = false;
  }

  @override
  void onClose() {
    closeTable();
  }
}
