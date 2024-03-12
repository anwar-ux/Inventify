import 'package:flutter/material.dart';

class AppColors {
  static const Color secondaryColor = Color.fromRGBO(35, 35, 35, 1);
  static const Color thirdcolor = Colors.white;
  static const primaryColor = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(35, 35, 35, 1),
        Color.fromRGBO(35, 35, 35, 1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.0, 1.0],
    ),
  );
}

class Appfont {
  static const primaryFont = 'JosefinSans';
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Colors.white,
    primary: Color.fromRGBO(35, 35, 35, 1),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromRGBO(35, 35, 35, 1),
    primary: Colors.white,
  ),
);
