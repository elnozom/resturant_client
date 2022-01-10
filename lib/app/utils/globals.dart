import 'package:device_information/device_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:permission_handler/permission_handler.dart';

class Globals {
 @override
  BoxShadow shadow = BoxShadow(
    color: Colors.black.withOpacity(0.5),
    spreadRadius: 1,
    blurRadius: 1,
    offset: Offset(0, 3), // changes position of shadow
  );
  BoxShadow shadowLight = BoxShadow(
    color: Colors.grey.shade600.withOpacity(0.5),
    spreadRadius: 1,
    blurRadius: 1,
    offset: Offset(0, 1), // changes position of shadow
  );

  BorderRadius radius = BorderRadius.all(
    Radius.circular(5),
  );
}
