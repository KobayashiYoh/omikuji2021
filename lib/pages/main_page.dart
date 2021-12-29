import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:translator/translator.dart';
import 'dart:math' as math;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
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
  ];
  final _translator = GoogleTranslator();
  late String _englishWord;
  late String _fortune;
  late Future<Translation> _message;

  // 乱数から運勢を決定
  void _generateFortune() {
    var rand = new math.Random();
    int fortuneId = rand.nextInt(100);

    if (fortuneId == 99) {
      _fortune = _fortuneList[0];
    }
    else if (fortuneId > 90) {
      _fortune = _fortuneList[1];
    }
    else if (fortuneId > 80) {
      _fortune = _fortuneList[2];
    }
    else if (fortuneId > 65) {
      _fortune = _fortuneList[3];
    }
    else if (fortuneId > 50) {
      _fortune = _fortuneList[4];
    }
    else if (fortuneId > 35) {
      _fortune = _fortuneList[5];
    }
    else if (fortuneId > 20) {
      _fortune = _fortuneList[6];
    }
    else if (fortuneId > 10) {
      _fortune = _fortuneList[7];
    }
    else if (fortuneId == 0) {
      _fortune = _fortuneList[8];
    }
  }

  Future<Translation> _wordGenerate() async {
    _englishWord = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    print(_englishWord);
    Future<Translation> generatedWord = _translator.translate(_englishWord, from: 'en', to: 'ja');
    return generatedWord;
  }

  // おみくじを引く
  void _reload () {
    setState(() {
      _generateFortune();
      _message = _wordGenerate();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateFortune();
    _message = _wordGenerate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              FutureBuilder(
                future: _message,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  List<Widget> children = [];
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      children = [
                        Text(
                          '$_fortune\n\n2022年は\n「${snapshot.data.toString()}」\nな一年になるでしょう',
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      ];
                    }
                    else if (snapshot.hasError) {
                      children = [
                        Text(snapshot.error.toString()),
                      ];
                    }
                  }
                  else {
                    children = [
                      CircularProgressIndicator(),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
              FlatButton(
                onPressed: _reload,
                color: Colors.blue,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'おみくじを引く',
                    style: TextStyle(
                      color: Colors.white,
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
