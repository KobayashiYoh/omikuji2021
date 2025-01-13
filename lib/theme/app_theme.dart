import 'package:flutter/material.dart';

class _FontFamilies {
  _FontFamilies._();

  static const String yujiSyuku = 'YujiSyuku';
}

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  fontFamily: _FontFamilies.yujiSyuku,
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
          fontFamily: _FontFamilies.yujiSyuku,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);
