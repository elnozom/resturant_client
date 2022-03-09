import 'package:client_v3/app/data/models/notification_model.dart';
import 'package:client_v3/app/data/models/table/table_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/state_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notify {
  List<NotificationModel> notifications = [];
  AudioPlayer player = AudioPlayer();
  int count = 0;
  int empCode = 0;
  List<int> selectedSerials = [];
  static Notify? _instance;
  final TableProvider provider = new TableProvider();
  String url = "";
  Notify._internal();

  static Notify get instance {
    if (_instance == null) {
      _instance = Notify._internal();
    }

    return _instance!;
  }

  List<NotificationModel> list() {
    return this.notifications;
  }

  int countItems() {
    return this.count;
  }

  Future getNotifications() async {
      await provider.getNotifications().then((value) async  {
        this.notifications = value;
        this.count = value.length;
    });
  }
  Future getNotificationsCount() async {
    if(this.url == ""){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      this.url = "http://${prefs.getString("ip")}:${prefs.getString("port")}/api/cart/call/${prefs.getString("imei")}";
    }
    await provider.getNotificationsCount(this.url).then((value) async  {
      this.count = value;
    });
  }

  Future<bool> respondNotifications(String serials) async {
    return true;
  }

  Widget notificationWidget(BuildContext context , int count) {
    return GestureDetector(
      onTap: () async{
        await this.getNotifications();
        openModal(context);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.emoji_people,
              color: Colors.white,
              size: 30,
            ),
          ),
           Positioned(
                top: 0,
                right: 0,
                width:20.0,
                height:20.0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffc32c37),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                )),
          
        ],
      ),
    );
  }

  Widget tableWidget(NotificationModel notification, context) {
    Rx<bool> isActive = false.obs;
    bool isMobile = MediaQuery.of(context).size.width > 960;
    return GestureDetector(
      onTap: () async {
        isActive.value = !isActive.value;
        isActive.value ? selectedSerials.add(notification.tableSerial) : selectedSerials.remove(notification.tableSerial);
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Obx(() => Container(
          width: isMobile ? 100 : 80,
          height: isMobile ? 100 : 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive.value
                ? Colors.green.shade900
                : notification.type == 0
                    ? Theme.of(context).primaryColor
                    : Colors.orange.shade900,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
              mainAxisAlignment:true ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 if(true) Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                      Icon(Icons.schedule , color:Colors.white , size: 12,),
                      
                        Text(notification.count.toString() , style : TextStyle(color : Colors.white, fontSize: 10)),
                      ],
                    )
                    
                    ,Text(notification.type == 1 ? 'chequq_call'.tr : 'waiter_call'.tr , style : TextStyle(color : Colors.white, fontSize: 10))],
                ),
                
                Text(notification.tableNo.toString() , style: TextStyle(color : Colors.white, fontSize: 22 , fontWeight: FontWeight.bold),),
                Text(notification.groupTableName , style: TextStyle(color : Colors.white, fontSize: 16 ),),
                
              ]),
        ),
        ),)
      ),
    );
  }

  Widget tablesWidget(BuildContext context) {
    List<Widget> list = [];
    print(this.notifications);
    this.notifications.forEach((NotificationModel notification) {
      list.add(GestureDetector(
          onTap: () {
           print("asd");
          },
          child: tableWidget(notification, context)));
    });
    return GridView.count(
      childAspectRatio: 2.5,
      crossAxisCount: 1,
      crossAxisSpacing: 1.0,
      mainAxisSpacing: 1.0,
      children: list,
    );
  }

  Future<int> checkForNewCalls() async {
    int count = this.countItems();
    await this.getNotificationsCount();
    int count2 = this.countItems();
    if(count < count2) {
      await player.setAsset('assets/audio/notify.mp3');
      player.play();
      HapticFeedback.heavyImpact();
    }
    return count2;
  }
  Future respond(BuildContext context) async {
    String selected = "";
    this.selectedSerials.forEach((element) {
      selected += ",${element}";
    });
    provider.repondCalls(selected , this.empCode).then((res) {
      this.selectedSerials = [];
      Navigator.pop(context);
    });
  }
  Future openModal(context) async {
    this.selectedSerials = [];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              contentPadding: EdgeInsets.all(0),
              elevation: 2,
              content: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    toolbarHeight: 120,
                    elevation: 0,
                    title: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      height: 100,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.emoji_people,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          Text(
                            "someone_calls_waiter".tr,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                  body: this.tablesWidget(context),
                  bottomNavigationBar: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        child: Text("got_it".tr),
                        onPressed: () {
                          this.respond(context);
                        },
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
