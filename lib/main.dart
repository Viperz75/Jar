import 'package:jar_app/mainScreen/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'components/biometric_provider.dart';
import 'components/currencies.dart';
import 'components/pages/login_page.dart';
import 'theme/theme_manager.dart';

void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(JarAdapter());
  await Hive.openBox('jar_box');

  runApp(const Jar());
}

class Jar extends StatefulWidget {
  const Jar({super.key});

  @override
  State<Jar> createState() => _JarState();
}

class _JarState extends State<Jar> {

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(context)),
        ChangeNotifierProvider(create: (_) => CurrencyNotifier()),
        ChangeNotifierProvider(create: (_) => BiometricProvider()),
      ],
      child: Consumer2<ThemeProvider, BiometricProvider>(
        builder: (context, themeProvider, biometricProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeModeType == ThemeModeType.system
                ? ThemeMode.system
                : themeProvider.themeModeType == ThemeModeType.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: themeProvider.themeData,
            home: biometricProvider.biometricEnabled
                ? LoginPage()
                : const Home(),
          );
        },
      ),
    );
  }
}


