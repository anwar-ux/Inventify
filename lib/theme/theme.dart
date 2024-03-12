import 'package:flutter/material.dart';
import 'package:inventify/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themedata => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveThemePreference(themeData); // Save the theme preference
    notifyListeners();
  }

  Future<void> _saveThemePreference(ThemeData themeData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', themeData == lightMode ? 'light' : 'dark');
  }

  Future<void> loadSavedTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedTheme = prefs.getString('theme') ?? 'light';
    themeData = savedTheme == 'light' ? lightMode : darkMode;
  }

  void toggleTheme() {
    if (_themeData == darkMode) {
      themeData = lightMode;
    } else {
      themeData = darkMode;
    }
  }
}
