import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Get.offAllNamed('/tables');
          controller.authorizeDevice();
        },
        child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/main-bg-2.jpg"),
                    fit: BoxFit.cover)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Image(
                    image: AssetImage("assets/images/logo.png"),
                    width: 100,
                  ),
                ),
                Container(
                    color: context.theme.primaryColor,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/images/icon.png"),
                          width: 50,
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                                                  child: Text(
                            "touch_any_where".tr,textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white , fontFamily: "En" ,fontSize: 18),
                          ),
                        ),
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
