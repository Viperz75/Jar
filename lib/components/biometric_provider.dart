import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricProvider with ChangeNotifier {
  bool _biometricEnabled = false;

  BiometricProvider() {
    _loadBiometricSettings();
  }

  bool get biometricEnabled => _biometricEnabled;

  void _loadBiometricSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _biometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    notifyListeners();
  }

  void setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    notifyListeners();
    _saveBiometricSettings(value);
  }

  Future<void> _saveBiometricSettings(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', value);
  }
}
