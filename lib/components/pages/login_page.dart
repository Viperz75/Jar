import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:jar_app/mainScreen/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _authenticateBiometrically();
  }

  Future<void> _authenticateBiometrically() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    if (!canCheckBiometrics) {
      // Biometric authentication is not available on this device.
      return;
    }

    List<BiometricType> availableBiometrics =
    await _localAuthentication.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      // No biometric methods available on this device.
      return;
    }

    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to login',
      );
    } catch (e) {
      print('Error authenticating: $e');
    }

    if (isAuthenticated) {
      // Navigate to the home page upon successful authentication.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: (){
            _authenticateBiometrically();
          },
          icon: FaIcon(FontAwesomeIcons.lock)
        ),
      ),
    );
  }
}
