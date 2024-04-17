// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// enum ThemeModeType { light, dark, system }
//
// class ThemeProvider extends ChangeNotifier {
//   ThemeData _themeData = ThemeData.light(); // Initialize with default theme
//   ThemeModeType _themeModeType = ThemeModeType.light;
//
//   ThemeData get themeData => _themeData;
//   ThemeModeType get themeModeType => _themeModeType;
//
//   ThemeProvider() {
//     _loadTheme();
//   }
//
//   Future<void> _loadTheme() async {
//     final prefs = await SharedPreferences.getInstance();
//     final themeMode = ThemeModeType.values[prefs.getInt('themeMode') ?? 0];
//     _setThemeMode(themeMode);
//   }
//
//   Future<void> setThemeMode(ThemeModeType mode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('themeMode', mode.index);
//     _setThemeMode(mode);
//   }
//
//   void _setThemeMode(ThemeModeType mode) {
//     _themeModeType = mode;
//     switch (mode) {
//       case ThemeModeType.light:
//         _themeData = ThemeData.light();
//         break;
//       case ThemeModeType.dark:
//         _themeData = ThemeData.dark();
//         break;
//       case ThemeModeType.system:
//         _themeData = ThemeData();
//         break;
//     }
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType { light, dark, system }

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  ThemeModeType _themeModeType = ThemeModeType.light;

  ThemeData get themeData => _themeData;
  ThemeModeType get themeModeType => _themeModeType;

  final BuildContext context;

  ThemeProvider(this.context) {
    _loadTheme();
    SystemChannels.platform.invokeMethod<void>('SystemChrome.setPreferredOrientations', <String>['portrait']);
    SystemChannels.platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'SystemUiOverlayStyleChanged') {
        _setSystemThemeMode();
      }
    });
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedModeIndex = prefs.getInt('themeMode');
    if (savedModeIndex != null) {
      final themeMode = ThemeModeType.values[savedModeIndex];
      _setThemeMode(themeMode);
    } else {
      // If no saved theme mode, default to system theme
      _setSystemThemeMode();
    }
  }

  Future<void> setThemeMode(ThemeModeType mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    _setThemeMode(mode);
  }

  void _setThemeMode(ThemeModeType mode) {
    _themeModeType = mode;
    switch (mode) {
      case ThemeModeType.light:
        _setLightTheme();
        break;
      case ThemeModeType.dark:
        _setDarkTheme();
        print(_themeData);
        break;
      case ThemeModeType.system:
        _setSystemThemeMode();
        break;
    }
    notifyListeners();
  }

  void _setLightTheme() {
    _themeData = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Color(0xfff5f7ec),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
        ),
      ),

      iconTheme: IconThemeData(
          color: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xfff5f7ec),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.white
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xfffcd9c3),
      ),
      cardTheme: CardTheme(
        color: Color(0xffdbdbdb),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }

  void _setDarkTheme(){
    _themeData = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        ),
      ),
      textTheme: TextTheme(
        button: TextStyle(
          color: Colors.white,
        ),
      ),
      iconTheme: IconThemeData(
          color: Colors.white
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Color(0xff000c15),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xff5e5c6a),
      ),
      cardTheme: CardTheme(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _setSystemThemeMode() {
    final brightness = MediaQuery.platformBrightnessOf(context);
    _themeData = brightness == Brightness.dark ? ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Color(0xff000c15),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xff5e5c6a),
      ),
      cardTheme: CardTheme(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    ) : ThemeData.light().copyWith(
      scaffoldBackgroundColor: Color(0xfff5f7ec),
      textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
        ),
      ),

      iconTheme: IconThemeData(
          color: Colors.black
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xfff5f7ec),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.white
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xfffcd9c3),
      ),
      cardTheme: CardTheme(
        color: Color(0xffdbdbdb),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
    notifyListeners();
  }
}
