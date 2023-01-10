import 'dart:async';

import 'package:client_v3/LocaleString.dart';
import 'package:client_v3/app/modules/order/helpers/localStorage.dart';
import 'package:client_v3/app/modules/order/helpers/notification.dart';
import 'package:client_v3/app/modules/order/helpers/options.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LocalStorage localStorage = LocalStorage.instance;
final service = FlutterBackgroundService();

Future<void> initializeService() async {
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() async {
  AudioPlayer player = AudioPlayer();
  WidgetsFlutterBinding.ensureInitialized();
  final notification = Notify.instance;
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );
    notification.checkForNewCalls().then((res) {
      print('main');
      print(res);
      service.sendData(
        {
          "count": res,
        },
      );
    });
  });
}

void main() async {
  await dotenv.load(fileName: ".env");
  await localStorage.init();
  String imei = await DeviceInformation.deviceIMEINumber;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("imei", imei);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Color(0xff1e90ff),
        backgroundColor: Color(0xffffffff),
        fontFamily: 'Ar',
        dividerColor: Colors.black,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline6: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText2: TextStyle(fontSize: 12.0, color: Colors.black),
          bodyText1: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ),
      onInit: () async {
        // init options singleton
        Options.instance;
        await initializeService();
        service.start();
      },
      onDispose: () async {
        service.stopBackgroundService();
      },
      locale: Locale('ar', 'AE'),
      translations: LocaleString(),
      title: "Rms",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
