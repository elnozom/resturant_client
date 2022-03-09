import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/discount/discount_model.dart';
import 'package:device_information/device_information.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/order/create_order_response_model.dart';
import 'package:client_v3/app/data/models/order/order_model.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';

class OrderProvider extends GetConnect {
  final localStorage = LocalStorage.instance;
  @override
  void onInit() {
    // httpClient.baseUrl = localStorage.getApiUrl();
  }

  Future<CreateOrderResp> createOrder(Order order) async {
    final response =
        await post('${localStorage.getApiUrl()}order', order.toJson());
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return CreateOrderResp.fromJson(response.body);
  }

  Future<List<String>> listAddons() async {
    final response = await get('${localStorage.getApiUrl()}item/addons');
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    // print(response.body.runtimeType);
    return response.body.cast<String>();
  }
  Future<bool> applyAddons(int serial , String addons) async {
    Map req = {
      "Serial" :serial,
      "Addons" : addons
    };
    final response = await put('${localStorage.getApiUrl()}order/addons' , req);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    return response.body;
  }
  Future<int> createOrderItem(Map item) async {
    final response = await post('${localStorage.getApiUrl()}order/item', item);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return response.body;
  }

  Future<bool> createOrderItemModifers(Map insertItemModifersReq) async {
    final response = await post(
        '${localStorage.getApiUrl()}order/item/modifers', insertItemModifersReq);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return response.body;
  }

  Future<bool> deleteOrderItem(int serial , int emp) async {
    final response =
        await delete('${localStorage.getApiUrl()}order/item/${serial}?EmpCode=${emp}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return response.body;
  }



  Future<bool> changeTable(int oldSerial , int newSerial , String computerName) async{
    Map req = {
      "NewSerial" :newSerial,
      "OldSerial" : oldSerial,
      "ComputerName"  : computerName
    };
    final response = await put('${localStorage.getApiUrl()}order/table' , req);
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
    final response = await put('${localStorage.getApiUrl()}order/transfer' , req);
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

    final response = await put('${localStorage.getApiUrl()}order/customer' , req);
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
    final response = await put('${localStorage.getApiUrl()}order/waiter' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }

  Future<bool> changeNoOfGuests(Map req) async{
    final response = await put('${localStorage.getApiUrl()}order/guests' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }
  
  Future<bool> applyDiscount(Map req) async{
    final response = await put('${localStorage.getApiUrl()}order/discount' , req);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }

    return response.body;
  }
  Future<List<Item>> listOrderItems(int headSerial) async {
    final response = await get('${localStorage.getApiUrl()}order/${headSerial}');
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
    final response = await get('${localStorage.getApiUrl()}order/print/${headSerial}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    
    return response.body;
  }



  Future<List<Discount>> listDiscounts() async {
    final response = await get('${localStorage.getApiUrl()}discounts');
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
    final response = await get('${localStorage.getApiUrl()}employee/waiters');
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


