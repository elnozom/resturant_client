import 'package:client_v3/app/modules/order/helpers/action.dart';
import 'package:get/state_manager.dart';

class TotalsModel {
  late Rx<double> amount = 0.0.obs;
  late Rx<double> tax = 0.0.obs;
  late Rx<double> discount = 0.0.obs;
  late Rx<double> minimum = 0.0.obs;
  late Rx<double> total = 0.0.obs;
  late Rx<int> percent = 0.obs;
  late double taxPercent = 0;
  TotalsModel(
      {required this.amount,
      required this.tax,
      required this.discount,
      required this.minimum,
      required this.total,
      required this.percent,
      required this.taxPercent});
}
