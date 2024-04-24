import 'package:flutter/material.dart';
import 'package:verbalize/themes/dark.dart';
import 'package:verbalize/themes/light.dart';


class ThemeProver extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;
}