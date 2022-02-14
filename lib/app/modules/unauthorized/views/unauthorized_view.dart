import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/unauthorized_controller.dart';

class UnauthorizedView extends GetView<UnauthorizedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Loader Animation Widget

                Obx(() {
                  return controller.wrongKey.value == true
                      ? Text("لقد ادخلت كود تفعيل غير صحيح",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black))
                      : SizedBox(height: 0);
                }),
                Image.asset(
                  'assets/images/lock.png',
                  width: 150.0,
                  height: 50.0,
                ),
                // "يبدو لنا ان الجهاز لم يتم تفعيله بعد علي قواعد بيناتنا لتفعيل الجهاز يرجي التواصل مع الدعم الفني"
                Text(
                  "unauthorized_msg".tr,
                  textAlign: TextAlign.center,
                ),
                // ":الرقم التعريفي للجهاز "
                Text(
                  "imei".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                ),
                // Text(
                //   controller.key,
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                // ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    controller.encrypt(controller.key),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black),
                  ),
                ),
                Form(
                    key: new GlobalKey<FormState>(),
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(children: <Widget>[
                      // Text(controller.config.partInv.toString()),
                      TextFormField(
                        controller: controller.keyController,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "encryption_key".tr,
                        ),
                      ),
                       TextFormField(
                            controller: controller.nameController,
                            textInputAction: TextInputAction.done,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: "device_name".tr,
                            ),
                            onSaved: (data) => {controller.submit(context)},
                            // valueTransformer: (text) => num.tryParse(text),
                          ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "activate".tr,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              controller.submit(context);
                            },
                          ),
                        ),
                      ),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
