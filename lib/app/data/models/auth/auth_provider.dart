import 'package:client_v3/app/modules/order/helpers/localStorage.dart';
import 'package:device_information/device_information.dart';
import 'package:get/get.dart';
import 'package:client_v3/app/data/models/auth/emp_model.dart';
import 'package:client_v3/app/data/models/auth/setting_model.dart';
import 'package:permission_handler/permission_handler.dart';
class AuthProvider extends GetConnect {
  // final _globals = Globals;
  final localStorage = LocalStorage.instance;
  @override
  void onInit(){
    // httpClient.baseUrl = dotenv.env['API_URL'];
  }
  Future<Emp?> _handleEmpResponse(response) async {
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    if(response.body == null){
      return null;
    }
      final Emp? employee = Emp.fromJson(response.body);
      return employee;
  }
  Future<Emp?> empGetByCode(int code) async {
    final response = await get('${localStorage.getApiUrl()}employee/${code}');
    return _handleEmpResponse(response);
  }

  Future<Emp?> empGetByBarCode(int code) async {
    print("asd");
    final response = await get('${localStorage.getApiUrl()}employee/barcode/${code}');
    // print(response.body);
    Emp? emp = await  _handleEmpResponse(response);
    return emp;
  }


  Future<Setting?> checkDeviceAuthorization() async {
    await Permission.phone.request();
    String imei = await DeviceInformation.deviceIMEINumber;
    var url = "${localStorage.getApiUrl()}authorize/${imei}";
    final response = await get(url);
   
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    if(response.body == null){
      return null;
    }
      final Setting? setting = Setting.fromJson(response.body);
      return setting;
  }




  Future<bool?> insertDevice(String name) async {
    String imei = await DeviceInformation.deviceIMEINumber;

    var data = {
      "Imei" : imei,
      "ComName" : name
    };
    final response = await post('${localStorage.getApiUrl()}authorize' , data);
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } 
    return response.body;
  }
}
