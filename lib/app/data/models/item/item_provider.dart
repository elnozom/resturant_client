import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_v3/app/data/models/item/item_model.dart';


class ItemProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['API_URL'];
  }

  Future<List<Item>> listItemsByGroup(int group) async {
    final response = await get('${dotenv.env['API_URL']}item/${group}');
    // var body = response.body != null ? jsonDecode(response.body) : [];
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<Item> items = [];
      if(response.body != null) response.body.forEach((item){
        Item i = Item.fromJson(item);
        items.add(i);
      });
       print(response.body);
      return items;
    }
  }


  Future< Map<int , List<Item>>> getItemModifers(int serial) async {
    final response = await get('${dotenv.env['API_URL']}item/modifiers/${serial}');
    // var body = response.body != null ? jsonDecode(response.body) : [];
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      Map<int , List<Item>> res = {};
        int screen = 1;
        response.body[0].forEach((index , val) {
        int currenIndex = int.parse(index);
        List<Item> items = [];
        if (screen != currenIndex){
          screen = currenIndex;
          items = [];
        }
        for (var i = 0; i < val.length; i++) {
          Item item = Item.fromJson(val[i]);
          items.add(item);
        }
          res.putIfAbsent(currenIndex , ()=> items);
      });

      return res;
    }
  }

}
