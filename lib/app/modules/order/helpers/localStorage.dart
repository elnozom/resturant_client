import 'package:shared_preferences/shared_preferences.dart';
class LocalStorage {
  String ip = "";
  String port = "";
  String logoPath = "";

  var prefs ;
  static LocalStorage? _instance ;

  LocalStorage._internal();
  Future init() async {
    prefs = await SharedPreferences.getInstance();

    if(prefs.getString("ip") != null) ip = prefs.getString("ip");
    if(prefs.getString("port") != null) port = prefs.getString("port");
    if(prefs.getString("logoPath") != null) logoPath = prefs.getString("logoPath");
  }

  void setIp(String i){
    ip = i;
    prefs.setString("ip" , i);
  }
  void setPort(String p){
    port = p;
    prefs.setString("port" , p);
  }
  void setLogo(String path){
    logoPath = path;
    prefs.setString("logoPath" , path);
  }
  String getApiUrl() {
    return "http://${ip}:${port}/api/";
  }
  String getLogoPath() {
    return "${ip}/${logoPath}";
  }
  static LocalStorage get instance {
    if (_instance == null) {
      _instance = LocalStorage._internal();
    }

    return _instance!;
  }
}