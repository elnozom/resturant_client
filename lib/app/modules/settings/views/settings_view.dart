import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:client_v3/app/widgets/loading.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SettingsView'),
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
