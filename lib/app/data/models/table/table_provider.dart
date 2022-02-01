import 'dart:convert';

import 'package:client_v3/app/utils/globals.dart';
import 'package:device_information/device_information.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/table/open_order_resp_model.dart';
import 'package:client_v3/app/data/models/table/table_group_model.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
  @override

class TableProvider extends GetConnect {
  void onInit() async {
    httpClient.baseUrl = "";
  }

  Future<List<TableGroup>> groupTablesList(int empCode) async {
    String url = "${dotenv.env['API_URL']}tables/groups?EmpCode=${empCode}";
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


  Future<List<TableModel>> tablesListByGroupNo(int group) async {
    final response = await get('${dotenv.env['API_URL']}tables/${group}');
    print("response.status.hasError");
    print(response.status.hasError);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<TableModel> tables = [];
      if(response.body != null) response.body.forEach((item){
        print(item);
        TableModel table = TableModel.fromJson(item);
        tables.add(table);
      });
      return tables;
    }
  }


  Future<TableOpenOrderResp> tablesOpenOrder(int serial , int empCode) async {
    String imei = await DeviceInformation.deviceIMEINumber;
    Map request = {
      "Serial" : serial,
      "Imei" : imei,
      "EmpCode" : empCode,
    };
    final response = await put('${dotenv.env['API_URL']}tables/open' , request);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
        TableOpenOrderResp resp = TableOpenOrderResp.fromJson(response.body);
      return resp;
    }
  }


  Future<bool> tablesCloseOrder(int serial) async {
    String imei = await DeviceInformation.deviceIMEINumber;
    Map request = {
      "Serial" : serial,
      "Imei" : imei,
    };
    final response = await put('${dotenv.env['API_URL']}tables/close' , request);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }
}
