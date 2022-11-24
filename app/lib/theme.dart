import 'package:app/constants.dart';
import 'package:flutter/material.dart';

TextTheme textTheme() {
  return TextTheme(
    headline1: TextStyle(fontSize: 34, fontFamily: 'MilkyBoba'),
    headline2: TextStyle(fontSize: 24, fontFamily: 'MilkyBoba'),
    headline3: TextStyle(fontSize: 16, fontFamily: 'MilkyBoba'),
    headline4: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
    headline5: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    subtitle2: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );
}

ThemeData theme() {
  return ThemeData(
    primaryColor: primaryColor,
    fontFamily: 'LotteMartDream',
    scaffoldBackgroundColor: Colors.white,
    textTheme: textTheme(),
  );
}
