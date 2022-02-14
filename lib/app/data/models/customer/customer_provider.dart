import 'package:client_v3/app/data/models/customer/customer_model.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';

import 'package:client_v3/app/modules/order/helpers/localStorage.dart';

class CustomerProvider extends GetConnect {
  final localStorage = LocalStorage.instance;
  @override
  void onInit() {
    // httpClient.baseUrl = localStorage.getApiUrl();
  }


  Future<List<Customer>> listCustomersByName(String name) async{
    final response = await get('${localStorage.getApiUrl()}customers?name${name}');
    if (response.status.hasError) {
      
      return Future.error(response.statusText.toString());
    }
    List<Customer> customers = [];
    if(response.body != null) response.body.forEach((item){
      Customer group = Customer.fromJson(item);
      customers.add(group);
    });
    return customers;
  }

}
