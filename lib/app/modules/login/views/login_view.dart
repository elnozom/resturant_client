import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
              body: Container(
                
                              child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: controller.tabC,
                    children: [
                      controller.qrTab(context),
                      controller.binCodeTab(context),
                ]),
              ))),
    );
  }
}
