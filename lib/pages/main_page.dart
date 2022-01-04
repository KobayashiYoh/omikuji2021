import 'package:flutter/cupertino.dart';
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

  // 進行に関するフィールド
  int _numberOfDraws = 0;

  // メッセージ生成に関するフィールド
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
  late Future<Translation> _futureMessage;
  String _generatedEnglishWord = '';
  String _fortune = '';
  String _message = '';

  // UIに関するフィールド
  static const String yujiSyuku = 'YujiSyuku';
  double _fortuneOpacity = 0;
  double _messageOpacity = 0;
  String _buttonText = 'おみくじを引く';

  // opacityを透明に初期化
  void _initOpacity() {
    setState(() {
      _fortuneOpacity = 0;
      _messageOpacity = 0;
    });
  }

  // _fortuneのopacityを変更
  void _changeFortuneOpacity() {
    setState(() {
      _fortuneOpacity = 1.0;
    });
  }

  // _messageのopacityを変更
  void _changeMessageOpacity() {
    setState(() {
      _messageOpacity = 1.0;
    });
  }

  // 乱数から運勢を決定
  void _generateFortune() {
    var rand = new math.Random();
    int fortuneId = rand.nextInt(100);
    print('Fortune ID: $fortuneId');

    if (fortuneId == 99) {
      _fortune = _fortuneList[0];
    }
    else if (fortuneId > 90) {
      _fortune = _fortuneList[1];
    }
    else if (fortuneId > 74) {
      _fortune = _fortuneList[2];
    }
    else if (fortuneId > 58) {
      _fortune = _fortuneList[3];
    }
    else if (fortuneId > 42) {
      _fortune = _fortuneList[4];
    }
    else if (fortuneId > 26) {
      _fortune = _fortuneList[5];
    }
    else if (fortuneId > 10) {
      _fortune = _fortuneList[6];
    }
    else if (fortuneId > 0) {
      _fortune = _fortuneList[7];
    }
    else if (fortuneId == 0) {
      _fortune = _fortuneList[8];
    }
    else {
      _fortune = _fortuneList[9];
    }
    print(_fortune);
  }

  // ボタンのテキストを変更
  void _changeButtonText() {
    if (_numberOfDraws % 1000 == 0) {
      _buttonText = '楽しんでくれてありがとう';
    }
    else if (_numberOfDraws % 777 == 0) {
      _buttonText = 'おしょくじを引き直す';
    }
    else if (_numberOfDraws % 100 == 0) {
      _buttonText = 'まだ引くの？';
    }
    else if (_numberOfDraws % 77 == 0) {
      _buttonText = 'おくみじを引き直す';
    }
    else if (_numberOfDraws % 50 == 0) {
      _buttonText = 'おじくみを引き直す';
    }
    else if (_numberOfDraws % 20 == 0) {
      _buttonText = 'おみくじをもっと引いちゃう';
    }
    else if (_numberOfDraws > 0) {
      _buttonText = 'おみくじを引き直す';
    }

    setState(() {
      _buttonText = _buttonText;
    });
  }

  // 英単語を生成して日本語に翻訳
  Future<Translation> _generateWord() async {
    _generatedEnglishWord = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    Future<Translation> generatedWord = _translator.translate(_generatedEnglishWord, from: 'en', to: 'ja');
    print(_generatedEnglishWord);
    return generatedWord;
  }

  // おみくじを引く
  Future<void> _drawAnOmikuji() async {
    _numberOfDraws++;
    print('\n--- おみくじ（$_numberOfDraws回目） ---');
    _initOpacity();
    setState(() {
      _generateFortune();
      _futureMessage = _generateWord();
    });

    await Future.delayed(Duration(seconds: 2));
    _changeFortuneOpacity();
    _changeMessageOpacity();

    await Future.delayed(Duration(seconds: 3));
    _changeButtonText();
  }

  @override
  void initState() {
    super.initState();
    _futureMessage = _generateWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text(
          'おみくじアプリ',
          style: TextStyle(
            fontFamily: yujiSyuku,
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
              Container(
                height: 400.0,
                child: FutureBuilder(
                  future: _futureMessage,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    List<Widget> children = [];
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && _numberOfDraws == 0) {
                        children = [
                          const Text(
                            '↓ボタンをタップでおみくじを引く',
                            style: TextStyle(
                              fontFamily: yujiSyuku,
                              fontSize: 20.0,
                            ),
                          ),
                        ];
                      }
                      else if (snapshot.hasData) {
                        children = [
                          AnimatedOpacity(
                            opacity: _messageOpacity,
                            child: Text(
                              '$_fortune\n\n二〇二二年は\n「${snapshot.data.toString()}」\nな一年になるでしょう',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: yujiSyuku,
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        ];
                        print(snapshot.data);
                      }
                      else if (snapshot.hasError) {
                        print(snapshot.error);
                        children = [
                          Text(snapshot.error.toString()),
                        ];
                      }
                    }
                    else if(_numberOfDraws != 0) {
                      children = [
                        CupertinoActivityIndicator(),
                      ];
                    }
                    else {
                      children = [
                        Container(
                          child: const Text(
                            '↓ボタンをタップでおみくじを引く',
                            style: TextStyle(
                              fontFamily: yujiSyuku,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
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
              FlatButton(
                onPressed: _drawAnOmikuji,
                color: Colors.indigo[900],
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: yujiSyuku,
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
