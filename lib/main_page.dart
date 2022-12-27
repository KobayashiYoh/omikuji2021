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
  final _fortuneList = [
    '豪運',
    '大吉',
    '中吉',
    '小吉',
    '吉',
    '末吉',
    '凶',
    '大凶',
    '沼',
    '印刷ミス',
  ];
  final _translator = GoogleTranslator();
  late String _englishWord;
  late String _fortune;
  late Future<Translation> _message;

  TextStyle _fortuneTextStyle = const TextStyle(
    fontSize: 30.0,
    fontFamily: 'YujiSyuku',
    color: Colors.red,
  );

  // 乱数から運勢を決定
  void _generateFortune() {
    var rand = math.Random();
    int fortuneId = rand.nextInt(100);
    print('Fortune ID: $fortuneId');

    if (fortuneId == 99) {
      _fortune = _fortuneList[0];
    } else if (fortuneId > 90) {
      _fortune = _fortuneList[1];
    } else if (fortuneId > 74) {
      _fortune = _fortuneList[2];
    } else if (fortuneId > 58) {
      _fortune = _fortuneList[3];
    } else if (fortuneId > 42) {
      _fortune = _fortuneList[4];
    } else if (fortuneId > 26) {
      _fortune = _fortuneList[5];
    } else if (fortuneId > 10) {
      _fortune = _fortuneList[6];
    } else if (fortuneId > 0) {
      _fortune = _fortuneList[7];
    } else if (fortuneId == 0) {
      _fortune = _fortuneList[8];
    } else {
      _fortune = _fortuneList[9];
    }
    print(_fortune);
  }

  Future<Translation> _wordGenerate() async {
    _englishWord = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    print(_englishWord);
    Future<Translation> generatedWord =
        _translator.translate(_englishWord, from: 'en', to: 'ja');
    return generatedWord;
  }

  // テキストスタイルを初期化
  void _initTextStyle() {
    setState(() {
      _fortuneTextStyle = const TextStyle(
        fontSize: 30.0,
        fontFamily: 'YujiSyuku',
        color: Colors.transparent,
      );
    });
  }

  // テキストスタイルを変更
  void _changeTextStyle() {
    setState(() {
      _fortuneTextStyle = const TextStyle(
        fontSize: 30.0,
        fontFamily: 'YujiSyuku',
        color: Colors.black,
      );
    });
  }

  // おみくじを引く
  Future<void> _reload() async {
    _initTextStyle();
    setState(() {
      print('\n--- おみくじを引く ---');
      _generateFortune();
      _message = _wordGenerate();
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
        title: const Text(
          'おみくじアプリ',
          style: TextStyle(
            fontFamily: 'YujiSyuku',
          ),
        ),
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
                            style: _fortuneTextStyle,
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
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'おみくじを引く',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'YujiSyuku',
                      fontSize: 20.0,
                    ),
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
