import 'package:flutter/material.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(color:Colors.black , fontSize: 50, fontFamily: 'En' , fontWeight: FontWeight.bold),
      headline2: TextStyle(color:Colors.black , fontSize: 34, fontFamily: 'En' , fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color:Colors.black , fontSize: 18.0, fontFamily: 'En'),
    ).apply(
      fontFamily: 'En', 
    ),
    primaryColor: Color(0xff1e90ff)
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    textTheme: TextTheme(
      headline1: TextStyle(color:Colors.black , fontSize: 50, fontFamily: 'En' , fontWeight: FontWeight.bold),
      headline2: TextStyle(color:Colors.black , fontSize: 34, fontFamily: 'En' , fontWeight: FontWeight.bold),
      bodyText1: TextStyle(color:Colors.black , fontSize: 18.0, fontFamily: 'En'),
    ).apply(
      fontFamily: 'En', 
    ),
    primaryColor: Color(0xff1e90ff)
  );
}