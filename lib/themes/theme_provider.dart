import 'package:flutter/material.dart';
import 'package:verbalize/themes/dark.dart';
import 'package:verbalize/themes/light.dart';


class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
  if (_themeData == lightMode) {
    // Use setter method to update themeData
    themeData = darkMode;
  } else {
    // Use setter method to update themeData
    themeData = lightMode;
  }
}
}