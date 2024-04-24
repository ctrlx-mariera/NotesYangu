import 'package:flutter/material.dart';
import 'app_theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Dark Theme'),
            leading: Icon(Icons.nightlight_round),
            trailing: Switch(
              value: themeProvider.currentTheme == AppTheme.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
