import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';
import 'package:client_v3/app/data/models/order/create_order_response_model.dart';
import 'package:client_v3/app/data/models/order/order_model.dart';

class OrderProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_URL'];
  }

  Future<CreateOrderResp> createOrder(Order order) async {
    final response =
        await post('${dotenv.env['API_URL']}order', order.toJson());
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    return CreateOrderResp.fromJson(response.body);
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
    final response = await put('${dotenv.env['API_URL']}order/changetable' , req);
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
}
