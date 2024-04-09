import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_manager.dart';

class settingsSection extends StatelessWidget {
  const settingsSection({
    super.key,
    required this.text,
  });

  final text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10.0),
        // Icon(Icons.wb_twilight),
        SizedBox(width: 10.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 17.0,
            color: Provider.of<ThemeProvider>(context).themeModeType ==
                ThemeModeType.dark
                ? Colors.greenAccent
                : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}