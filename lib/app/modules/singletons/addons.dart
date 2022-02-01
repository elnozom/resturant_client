import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Addons {
  static Addons? _instance;
  Rx<bool> loading = true.obs;
  List<String> addons = [];
  List<String> selectedAddons = [];
  int itemSerial = 0;
  OrderProvider provider = Get.put(new OrderProvider());
  Addons._internal() {
    _init();
  }
  static Addons get instance {
    if (_instance == null) {
      _instance = Addons._internal();
    }
    return _instance!;
  }
  void getAddons() async{
    provider.listAddons().then((value) => addons = value);
    loading.value = false;
  }
  void _init() async {
    getAddons();
  }
  void setItemSerial(BuildContext context , int serial) {
    itemSerial = serial;
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                   reset(context);
                  }),
              title:  Text("addons".tr),
              centerTitle: true,
            ),

            body: Container(child: Center(child: showAddons(context))),
            bottomNavigationBar: Container(padding: EdgeInsets.all(8),child: ElevatedButton(onPressed: (){ submit(context) ; }, child: Text('submit'.tr),),),
           
          );
        },
        fullscreenDialog: true));
  }

  Widget showAddons(BuildContext context){
    bool isMobile = MediaQuery.of(context).size.width > 960;
    List<Widget> widgets = [];
    for (var item in addons) {
      widgets.add(
        itemWidget(context, item),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            childAspectRatio: isMobile ? .8 : 1,
            padding: EdgeInsets.all(10),
            crossAxisCount: isMobile ? 8 : 4,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: widgets));
  }
  Widget itemWidget(BuildContext context, String item) {
    Rx<bool> isActive = false.obs;
    return GestureDetector(
      onTap: () {
        isActive.value = true;
        selectedAddons.add(item);
      },
      child: SizedBox(
          child: Obx(
        () => AnimatedContainer(
          duration: Duration(microseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isActive.value
                ? Colors.green.shade900
                : Theme.of(context).primaryColor,
            boxShadow: [
              if (isActive.value)
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 10, 0),
                  width: double.infinity,
                  child: Text(
                    item,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )),
              
            ],
          ),
        ),
      )),
    );
  }

  void submit(context) {
    String addonStr = "";
    for(var item in selectedAddons){
      addonStr += " - ${item}";
    }
    addonStr = addonStr.substring(1);
    provider.applyAddons(itemSerial , addonStr);
    reset(context);
  }

  void reset(BuildContext context){
    selectedAddons =[];
    itemSerial = 0;
    Navigator.pop(context);
  }
  
}
