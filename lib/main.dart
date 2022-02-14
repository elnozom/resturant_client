import 'package:client_v3/LocaleString.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final LocalStorage localStorage = LocalStorage.instance;
  await  localStorage.init();
  
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Color(0xff1e90ff),
        backgroundColor:Color(0xffffffff),
        fontFamily: 'Ar',
        dividerColor: Colors.black,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText2: TextStyle(fontSize: 12.0,color: Colors.black),
          bodyText1: TextStyle(fontSize: 14.0,color: Colors.black),
        ),
      ),
      locale: Locale('ar', 'AE'),
      translations: LocaleString(),
      title: "Rms",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
