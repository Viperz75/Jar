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
        _themeData = ThemeData.light();
        break;
      case ThemeModeType.dark:
        _themeData = ThemeData.dark();
        print(_themeData);
        break;
      case ThemeModeType.system:
        _themeData = ThemeData();
        break;
    }
    notifyListeners();
  }

  void _setSystemThemeMode() {
    final brightness = MediaQuery.platformBrightnessOf(context);
    _themeData = brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
  }
}
