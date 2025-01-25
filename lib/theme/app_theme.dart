import 'package:flutter/material.dart';

import '../constants/font_families.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: FontFamilies.yujiSyuku,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.indigo[900],
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.indigo[900]),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontFamily: FontFamilies.yujiSyuku,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStatePropertyAll(Colors.indigo[900]),
  ),
);
