import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:translator/translator.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _translator = GoogleTranslator();
  late String _englishWord;
  late Future<Translation> _message;

  Future<Translation> _wordGenerate() async {
    _englishWord = WordPair.random().asPascalCase;
    print(_englishWord);
    Future<Translation> generatedWord = _translator.translate(_englishWord, from: 'en', to: 'ja');
    return generatedWord;
  }

  // おみくじを引く
  void _reload () {
    setState(() {
      _message = _wordGenerate();
    });
  }

  @override
  void initState() {
    super.initState();
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
                          '2022年は\n「${snapshot.data.toString()}」\nな一年になるでしょう',
                          style: TextStyle(
                            fontSize: 35.0,
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
