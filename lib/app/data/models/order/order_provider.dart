import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/discount/discount_model.dart';
import 'package:device_information/device_information.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/order/create_order_response_model.dart';
import 'package:client_v3/app/data/models/order/order_model.dart';

class OrderProvider extends GetConnect {
  @override
  void onInit() {
    // httpClient.baseUrl = dotenv.env['API_URL'];
  }

  Future<CreateOrderResp> createOrder(Order order) async {
    final response =
        await post('${dotenv.env['API_URL']}order', order.toJson());
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return CreateOrderResp.fromJson(response.body);
  }

  Future<List<String>> listAddons() async {
    final response = await get('${dotenv.env['API_URL']}item/addons');
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    // print(response.body.runtimeType);
    return response.body.cast<String>();
  }
  Future<List<String>> applyAddons(int serial , String addons) async {
    Map req = {
      "Serial" :serial,
      "Addons" : addons
    };
    final response = await put('${dotenv.env['API_URL']}order/addons' , req);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    return response.body;
  }
  Future<int> createOrderItem(Map item) async {
    final response = await post('${dotenv.env['API_URL']}order/item', item);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return response.body;
  }

  Future<bool> createOrderItemModifers(Map insertItemModifersReq) async {
    final response = await post(
        '${dotenv.env['API_URL']}order/item/modifers', insertItemModifersReq);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return response.body;
  }

  Future<bool> deleteOrderItem(int serial) async {
    final response =
        await delete('${dotenv.env['API_URL']}order/item/${serial}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return response.body;
  }



  Future<bool> changeTable(int oldSerial , int newSerial) async{
    Map req = {
      "NewSerial" :newSerial,
      "OldSerial" : oldSerial
    };
    final response = await put('${dotenv.env['API_URL']}order/table' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }
 
  Future<bool> transferIems(String serials , int waiterCode , int tableSerial , bool isSplit) async{
    String imei = await DeviceInformation.deviceIMEINumber;

    Map req = {
      "TableSerial" :tableSerial,
      "ItemsSerials" : serials,
      "Imei" : imei,
      "WaiterCode" : waiterCode,
      "Split": isSplit
    };
    final response = await put('${dotenv.env['API_URL']}order/transfer' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }


  
  

  Future<bool> changeCustomer(int headSerial , int customerSerial) async{
    Map req = {
      "HeadSerial" :headSerial,
      "CustomerSerial" : customerSerial
    };

    print(req);
    final response = await put('${dotenv.env['API_URL']}order/customer' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }
  Future<bool> changeWaiter(int headSerial , int waiterCode) async{
    Map req = {
      "HeadSerial" :headSerial,
      "WaiterCode" : waiterCode
    };

    print(req);
    final response = await put('${dotenv.env['API_URL']}order/waiter' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }

  Future<bool> changeNoOfGuests(Map req) async{
    final response = await put('${dotenv.env['API_URL']}order/guests' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }
  
  Future<bool> applyDiscount(Map req) async{
    final response = await put('${dotenv.env['API_URL']}order/discount' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }
  Future<List<Item>> listOrderItems(int headSerial) async {
    final response = await get('${dotenv.env['API_URL']}order/${headSerial}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    List<Item> items = [];
    if (response.body != null) {
      response.body.forEach((item) {
        Item i = Item.fromJson(item);
        items.add(i);
      });
    }
    return items;
  }

  Future<dynamic> listItemFromPrint(int headSerial) async {
    final response = await get('${dotenv.env['API_URL']}order/print/${headSerial}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    
    return response.body;
  }



  Future<List<Discount>> listDiscounts() async {
    final response = await get('${dotenv.env['API_URL']}discounts');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    List<Discount> items = [];
    if (response.body != null) {
      response.body.forEach((item) {
        Discount i = Discount.fromJson(item);
        items.add(i);
      });
    }
    return items;
  }



  Future<List<Emp>> listWaiters() async {
    final response = await get('${dotenv.env['API_URL']}employee/waiters');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    List<Emp> items = [];
    if (response.body != null) {
      response.body.forEach((item) {
        Emp i = Emp.fromJson(item);
        items.add(i);
      });
    }
    return items;
  }
  


}


