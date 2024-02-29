import 'package:expense_jar/mainScreen/home.dart';
import 'package:expense_jar/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f7ec),
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xfff5f7ec),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10.0),
              // Icon(Icons.wb_twilight),
              SizedBox(width: 10.0),
              Text(
                'About the app',
                style: TextStyle(
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('About the App'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('App Name: Jar'),
                              SizedBox(height: 5.0),
                              Text('Version: 1.0.0'),
                              SizedBox(height: 5.0),
                              Text('Developer: Niaz Mahmud Akash'),
                              SizedBox(height: 5.0),
                              Text(
                                  'Description: Jar is a saving tracker app where you can save your goals and savings all together.'),
                              SizedBox(height: 15.0),
                              Center(
                                child: Text(
                                    'More features coming soon, stay tuned!'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5.0),
                        Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'About',
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
