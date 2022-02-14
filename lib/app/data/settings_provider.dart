import 'package:get/get.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';
class SettingsProvider extends GetConnect {
  // final _globals = Globals;
  final localStorage = LocalStorage.instance;

  @override
  void onInit(){
    // httpClient.baseUrl = localStorage.getApiUrl();
  }
 
  Future<dynamic> getOptions() async {
    final response = await get('${localStorage.getApiUrl()}options');
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    return response.body;
  }
}
