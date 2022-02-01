import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/nocashtray/bindings/nocashtray_binding.dart';
import '../modules/nocashtray/views/nocashtray_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/tables/bindings/tables_binding.dart';
import '../modules/tables/views/tables_view.dart';
import '../modules/unauthorized/bindings/unauthorized_binding.dart';
import '../modules/unauthorized/views/unauthorized_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.TABLES,
      page: () => TablesView(),
      binding: TablesBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.UNAUTHORIZED,
      page: () => UnauthorizedView(),
      binding: UnauthorizedBinding(),
    ),
    GetPage(
      name: _Paths.NOCASHTRAY,
      page: () => NocashtrayView(),
      binding: NocashtrayBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
