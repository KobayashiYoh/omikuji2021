import 'dart:math' as math;

import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String _fortune;
  late Future<Translation> _message;
  Color? _fortuneTextColor;

  String _generateFortune() {
    final rand = math.Random();
    final fortuneId = rand.nextInt(100) + 1;
    if (fortuneId == 1) {
      return '沼'; // 1
    } else if (fortuneId <= 10) {
      return '大凶'; // 2 ~ 10
    } else if (fortuneId <= 25) {
      return '凶'; // 11 ~ 25
    } else if (fortuneId <= 40) {
      return '末吉'; // 26 ~ 40
    } else if (fortuneId <= 60) {
      return '吉'; // 41 ~ 60
    } else if (fortuneId <= 75) {
      return '小吉'; // 61 ~ 75
    } else if (fortuneId <= 90) {
      return '中吉'; // 76 ~ 90
    } else if (fortuneId <= 99) {
      return '大吉'; // 91 ~ 99
    } else if (fortuneId == 100) {
      return '豪運'; // 100
    } else {
      return '印刷ミス';
    }
  }

  Future<Translation> _generateWord() async {
    final translator = GoogleTranslator();
    final String englishWord =
        WordPair.random().asSnakeCase.replaceAll('_', ' ');
    Future<Translation> generatedWord =
        translator.translate(englishWord, from: 'en', to: 'ja');
    return generatedWord;
  }

  // テキストスタイルを初期化
  void _initTextStyle() {
    setState(() {
      _fortuneTextColor = Colors.transparent;
    });
  }

  // テキストスタイルを変更
  void _changeTextStyle() {
    setState(() {
      _fortuneTextColor = Colors.black;
    });
  }

  // おみくじを引く
  Future<void> _reload() async {
    _initTextStyle();
    print('\n--- おみくじを引く ---');
    setState(() {
      _fortune = _generateFortune();
      _message = _generateWord();
    });
    await Future.delayed(const Duration(seconds: 3));
    _changeTextStyle();
  }

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text('おみくじアプリ'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(),
              SizedBox(
                height: 250.0,
                child: FutureBuilder(
                  future: _message,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Widget> children = [];
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        children = [
                          AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize: 32.0,
                              color: _fortuneTextColor,
                              fontFamily: 'YujiSyuku',
                            ),
                            duration: const Duration(seconds: 3),
                            child: Text(
                                '$_fortune\n\n二〇二二年は\n「${snapshot.data.toString()}」\nな一年になるでしょう'),
                          ),
                        ];
                      } else if (snapshot.hasError) {
                        children = [
                          Text(snapshot.error.toString()),
                        ];
                      }
                    } else {
                      children = [
                        const CupertinoActivityIndicator(),
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _reload,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.indigo[900],
                  foregroundColor: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'おみくじを引く',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
