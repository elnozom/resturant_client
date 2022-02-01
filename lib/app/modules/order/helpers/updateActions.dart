import 'package:client_v3/app/data/models/order/order_provider.dart';
import 'package:client_v3/app/data/models/table/table_model.dart';
import 'package:get/instance_manager.dart';

class UpdateActions {
  late final TableModel config ;
  final OrderProvider orderProvider = Get.put(OrderProvider());
  UpdateActions(TableModel config) {
    this.config = config;
  }
}

