import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    textTheme: AppTextTheme().lightTextTheme,
    colorSchemeSeed: Colors.deepOrange,
  );

  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    textTheme: AppTextTheme().darkTextTheme,
    colorSchemeSeed: Colors.cyan,
  ); // Text Theme
}

class AppTextTheme {
  AppTextTheme();

  TextTheme lightTextTheme = const TextTheme();

  TextTheme darkTextTheme = const TextTheme();
}
