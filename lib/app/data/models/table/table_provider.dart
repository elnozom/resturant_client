import 'package:client_v3/app/data/models/notification_model.dart';
import 'package:device_information/device_information.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/table/open_order_resp_model.dart';
import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';
  @override

class TableProvider extends GetConnect {
  final localStorage = LocalStorage.instance;
  void onInit() async {
    httpClient.baseUrl = "";
  }

  Future<List<TableGroup>> groupTablesList(int empCode) async {
    String url = "${localStorage.getApiUrl()}tables/groups?EmpCode=${empCode}";
    final response = await get(url);
    // var body = response.body != null ? jsonDecode(response.body) : [];
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<TableGroup> groups = [];
      if(response.body != null) response.body.forEach((item){
        TableGroup group = TableGroup.fromJson(item);
        groups.add(group);
      });
      return groups;
    }
  }

  Future<bool> repondCalls(String carts , int code) async {
    Map request = {
      "Serials" : carts,
      "WaiterCode" : code
    };
    final response = await put('${localStorage.getApiUrl()}cart/call/respond' , request);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }
  Future<int> getNotificationsCount(String url) async {
    // String imei = await DeviceInformation.deviceIMEINumber;
    final response = await get(url);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      print('repsonse');
      print(response.body);
      return response.body;
    }
  }

  Future<List<NotificationModel>> getNotifications() async {
    String imei = await DeviceInformation.deviceIMEINumber;
    final response = await get("${localStorage.getApiUrl()}cart/call/${imei}/list");
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<NotificationModel> notifications = [];
      if(response.body != null) response.body.forEach((item){
        NotificationModel group = NotificationModel.fromJson(item);
        notifications.add(group);
      });
      return notifications;
    }
  }


  Future<List<TableModel>> tablesListByGroupNo(int group) async {
    final response = await get('${localStorage.getApiUrl()}tables/${group}');
  
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<TableModel> tables = [];
      if(response.body != null) response.body.forEach((item){
        TableModel table = TableModel.fromJson(item);
        tables.add(table);
      });
      return tables;
    }
  }


  Future<TableOpenOrderResp> tablesOpenOrder(int serial , int empCode , int headSerial) async {
    String imei = await DeviceInformation.deviceIMEINumber;
    Map request = {
      "Serial" : serial,
      "Imei" : imei,
      "EmpCode" : empCode,
      "HeadSerial" : headSerial,
    };
    final response = await put('${localStorage.getApiUrl()}tables/open' , request);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      TableOpenOrderResp resp = TableOpenOrderResp.fromJson(response.body);
      return resp;
    }
  }


  Future<bool> tablesCloseOrder(int serial , int headSerial) async {
    String imei = await DeviceInformation.deviceIMEINumber;
    Map request = {
      "Serial" : serial,
      "Imei" : imei,
      "HeadSerial" : headSerial
    };
    final response = await put('${localStorage.getApiUrl()}tables/close' , request);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }
}
