import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      title: 'Omikuji App',
      theme: ThemeData(
        fontFamily: 'YujiSyuku',
        colorScheme:
            ThemeData().colorScheme.copyWith(primary: Colors.indigo[900]),
      ),
      debugShowCheckedModeBanner: false,
      home: const OmikujiPage(),
    );
  }
}
