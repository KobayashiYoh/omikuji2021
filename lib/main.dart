import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omikuji_app/theme/app_theme.dart';
import 'package:omikuji_app/views/omikuji_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'おみくじ',
      theme: appTheme,
      home: const OmikujiPage(),
    );
  }
}
