import 'package:expense_jar/components/settings.dart';
import 'package:expense_jar/mainScreen/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsPage(),
    );
  }
}


