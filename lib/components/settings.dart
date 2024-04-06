import 'package:expense_jar/components/pages/privacy_policy.dart';
import 'package:expense_jar/mainScreen/home.dart';
import 'package:expense_jar/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import '../theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).themeModeType ==
              ThemeModeType.dark
          ? Colors.black // Set red background color for dark mode
          : Color(0xfff5f7ec),
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Provider.of<ThemeProvider>(context).themeModeType ==
                ThemeModeType.dark
            ? Colors.black // Set red background color for dark mode
            : Color(0xfff5f7ec),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10.0),
              // Icon(Icons.wb_twilight),
              SizedBox(width: 10.0),
              Text(
                'Appearance',
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
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Provider.of<ThemeProvider>(context).themeModeType ==
                                ThemeModeType.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'Theme',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile(
                              title: Text('Light Mode'),
                              value: ThemeModeType.light,
                              groupValue: Provider.of<ThemeProvider>(context)
                                  .themeModeType,
                              onChanged: (value) {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .setThemeMode(value!);
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              title: Text('Dark Mode'),
                              value: ThemeModeType.dark,
                              groupValue: Provider.of<ThemeProvider>(context)
                                  .themeModeType,
                              onChanged: (value) {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .setThemeMode(value!);
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              title: Text('System Mode'),
                              value: ThemeModeType.system,
                              groupValue: Provider.of<ThemeProvider>(context)
                                  .themeModeType,
                              onChanged: (value) {
                                Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .setThemeMode(value!);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Provider.of<ThemeProvider>(context).themeModeType ==
                              ThemeModeType.dark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Theme',
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10.0),
              // Icon(Icons.wb_twilight),
              SizedBox(width: 10.0),
              Text(
                'About us',
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
                  onPressed: () {},
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5.0),
                        Icon(
                          Icons.apps_rounded,
                          color: Provider.of<ThemeProvider>(context)
                                      .themeModeType ==
                                  ThemeModeType.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Apps',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Provider.of<ThemeProvider>(context)
                                        .themeModeType ==
                                    ThemeModeType.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              buildAboutUs(context),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    void _launchEmail() async {
                      final Uri _emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'akash@alphaxb.com',
                        queryParameters: {
                          'subject': 'Jar Feedback',
                        },
                      );

                      if (await canLaunch(_emailLaunchUri.toString())) {
                        await launch(_emailLaunchUri.toString());
                      } else {
                        throw 'Could not launch $_emailLaunchUri';
                      }
                    }
                  },
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5.0),
                        Icon(
                          Icons.mail_rounded,
                          color: Provider.of<ThemeProvider>(context)
                                      .themeModeType ==
                                  ThemeModeType.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Contact me',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Provider.of<ThemeProvider>(context)
                                        .themeModeType ==
                                    ThemeModeType.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicy(),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 5.0),
                        Icon(
                          Icons.security_rounded,
                          color: Provider.of<ThemeProvider>(context)
                                      .themeModeType ==
                                  ThemeModeType.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Provider.of<ThemeProvider>(context)
                                        .themeModeType ==
                                    ThemeModeType.dark
                                ? Colors.white
                                : Colors.black,
                          ),
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

  Expanded buildAboutUs(BuildContext context) {
    return Expanded(
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
                      child: Text('More features coming soon, stay tuned!'),
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
                color: Provider.of<ThemeProvider>(context).themeModeType ==
                        ThemeModeType.dark
                    ? Colors.white
                    : Colors.black,
              ),
              SizedBox(width: 10.0),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Provider.of<ThemeProvider>(context).themeModeType ==
                          ThemeModeType.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
