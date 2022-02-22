import 'package:client_v3/app/data/settings_provider.dart';
import 'package:client_v3/app/data/totals_model.dart';
import 'package:get/state_manager.dart';

class Totals {
  Rx<double> amount = 0.0.obs;
  Rx<double> tax = 0.0.obs;
  double taxPercent = 0;
  Rx<double> discount = 0.0.obs;
  Rx<double> total = 0.0.obs;
  Rx<int> percent = 0.obs;
  static Totals? _instance ;
  // Totals(double amount , int percent) {
  //   tax.value = amount * .14;
  //   discount.value = amount * percent / 100;
  //   total.value = amount + tax.value - discount.value;
  //   percent = percent;
  //   amount = amount;
  // }

  Totals._internal() {
    
  }
  static Totals get instance {
    if (_instance == null) {
      _instance = Totals._internal();
    }

    return _instance!;
  }
  void init(double val , int percent){
    SettingsProvider provider =  new SettingsProvider();
    provider.getOptions().then((value) {
      taxPercent = value['SaleTax'] is int ? value['SaleTax'].toDouble() : value['SaleTax'];
      percent = percent;
      amount.value = val;
      _calc();
    } );
  }

  void append(double val){
    amount.value += val;
    _calc();
  }
  void remove(double val){
    amount.value -= val;
    _calc();
  }

  void applyDiscount(int val){
    percent.value = val;
    _calc();
  }

  void _calc(){
    tax.value = amount.value * taxPercent / 100;
    discount.value = amount.value * percent.value / 100;
    total.value = amount.value + tax.value - discount.value;
  }

  TotalsModel getTotals(){
    return new TotalsModel(amount: amount , tax: tax , discount: discount , percent:percent,total:total , taxPercent :taxPercent);
  }
}