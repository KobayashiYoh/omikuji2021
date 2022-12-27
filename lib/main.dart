import 'package:flutter/material.dart';
import 'package:omikuji2021/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'omikuji2021',
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
