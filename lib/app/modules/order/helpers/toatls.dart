import 'package:client_v3/app/data/settings_provider.dart';
import 'package:client_v3/app/data/totals_model.dart';
import 'package:client_v3/app/modules/order/helpers/options.dart';
import 'package:get/state_manager.dart';

class Totals {
  Rx<double> amount = 0.0.obs;
  Rx<double> tax = 0.0.obs;
  double taxPercent = 0;
  Rx<double> discount = 0.0.obs;
  Rx<double> minimum = 0.0.obs;
  Rx<double> total = 0.0.obs;
  Rx<int> percent = 0.obs;
  int guests = 0;
  bool? useMinimum;
  Options options = Options.instance;

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
  void init({required double val , required int percent , required int guestCount , required bool hasMinimum,required bool hasTax}){
    useMinimum = hasMinimum;
    guests = guestCount;
    taxPercent = hasTax ?  options.taxPercent() : 0;
    percent = percent;
    amount.value = val;
    _calc();
  }
  void setGuests(int no){
    guests = no;
    _calc();
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
    print("useMinimum");
    print(useMinimum);
    tax.value = amount.value * taxPercent / 100;
    discount.value = amount.value * percent.value / 100;
    var cTotal = amount.value + tax.value - discount.value;
    var cMinimum =  (useMinimum != null  && useMinimum!) ? guests.toDouble() * options.minmumBon()  : 0.0;
    var minmumRest =  cMinimum -  cTotal;
    total.value = cTotal < cMinimum ? cMinimum : cTotal ;
    minimum.value = minmumRest < 0 ? 0 : minmumRest;
  }

  TotalsModel getTotals(){
    return new TotalsModel(amount: amount , tax: tax , discount: discount , percent:percent,total:total , minimum: minimum ,taxPercent :taxPercent);
  }
}