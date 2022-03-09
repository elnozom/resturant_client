import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Obx(() => !controller.printing.loading.value
              ? controller.printing.devicesDropDown()
              : LoadingWidget()),
          SizedBox(height: 10),
          TextFormField(
              controller: controller.ipInput,
              decoration: InputDecoration(hintText: "url".tr)),
          SizedBox(height: 10),

          TextFormField(
            controller: controller.portInput,
             decoration: InputDecoration(hintText: "port".tr),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: controller.logoInput,
             decoration: InputDecoration(hintText: "logo".tr),
          ),
          SizedBox(height: 10),

          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  controller.save();
                },
                child: Text('save')),
          ),
        ]),
      )),
    );
  }
}
