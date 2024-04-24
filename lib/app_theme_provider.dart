import 'package:flutter/material.dart';

enum AppTheme { light, dark }

class AppThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  late AppTheme _currentTheme;

  ThemeData get themeData => _themeData;
  AppTheme get currentTheme => _currentTheme;

  AppThemeProvider() {
    _currentTheme = AppTheme.light; // Start with light theme by default
    _themeData = _buildLightTheme();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.light(
        secondary: Colors.green, // accentColor for light theme
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      colorScheme: ColorScheme.dark(
        secondary: Colors.yellow, // accentColor for dark theme
      ),
    );
  }

  void toggleTheme() {
    _currentTheme = _currentTheme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    _themeData = _currentTheme == AppTheme.light ? _buildLightTheme() : _buildDarkTheme();
    notifyListeners();
  }
}
