import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xfff5f7ec),
  // shadowColor: Color(0xffA1AAFF),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),)
);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  brightness: Brightness.dark,
  cardColor: const Color(0xff303030),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ), colorScheme: const ColorScheme.highContrastDark(primary: Colors.black, onBackground: Colors.black).copyWith(background: Colors.black),
);
