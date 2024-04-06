import 'package:expense_jar/components/settings.dart';
import 'package:expense_jar/mainScreen/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData.light(),
    //   darkTheme: ThemeData.dark(),
    //   home: SettingsPage(),
    // );
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeModeType == ThemeModeType.system
                ? ThemeMode.system
                : themeProvider.themeModeType == ThemeModeType.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: themeProvider.themeData,
            home: Home(),
          );
        },
      ),
    );
  }
}


