import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color(0xffEFF3F5),
  // shadowColor: Color(0xffA1AAFF),
    textTheme: TextTheme(
      headline1: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),)
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.highContrastDark(primary: Colors.black, onBackground: Colors.black),
  scaffoldBackgroundColor: Colors.black,
  backgroundColor: Colors.black,
  brightness: Brightness.dark,
  cardColor: Color(0xff303030),
  textTheme: TextTheme(
    headline1: TextStyle(color: Colors.white),
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.white),
  ),
);
