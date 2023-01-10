import 'package:client_v3/app/data/models/options_model.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';

class SettingsProvider extends GetConnect {
  // final _globals = Globals;
  final localStorage = LocalStorage.instance;

  @override
  void onInit() {
    // httpClient.baseUrl = localStorage.getApiUrl();
  }
  Future<OptionsModel> getOptions() async {
    final response = await get('${localStorage.getApiUrl()}options');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    }
    var options = OptionsModel.fromJson(response.body);
    print(options.minimumBon);
    return options;
  }
}
