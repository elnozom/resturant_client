import 'package:client_v3/app/data/models/options_model.dart';
import 'package:client_v3/app/data/settings_provider.dart';

class Options {
  static Options? _instance ;
  OptionsModel? _options;
  static Options get instance {
    if (_instance == null) {
      _instance = Options._internal();
    }

    return _instance!;
  }
  Options._internal() {
    init();
  }
  OptionsModel? getOptions(){
    return _options;
  }
  double taxPercent(){
    return _options == null ? 0.00 : _options!.saleTax;
  }
  double minmumBon(){
    return _options == null ? 0.00 : _options!.minimumBon;
  }
  void init(){
    SettingsProvider provider =  new SettingsProvider();
    provider.getOptions().then((value) {
      _options = value;
    } );
  }
}