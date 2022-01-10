import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/nocashtray_controller.dart';

class NocashtrayView extends GetView<NocashtrayController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/lock.png',
                width: 150.0,
                height: 50.0,
              ),
              // "يبدو لنا ان الجهاز لم يتم تفعيله بعد علي قواعد بيناتنا لتفعيل الجهاز يرجي التواصل مع الدعم الفني"
              Text(
                "no_cashtray".tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            "reload".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            controller.reload();
                          },
                        ),
                      ),
                    ),
              
            ],
          ),
        ),
      ),
    );
  }
}
