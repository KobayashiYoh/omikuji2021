import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji2021/omikuji_notifier.dart';

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final omikujiState = ref.watch(omikujiProvider);
    final omikujiNotifier = ref.watch(omikujiProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text('おみくじアプリ'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              Center(
                child: omikujiState.isLoading
                    ? const CupertinoActivityIndicator()
                    : omikujiState.hasError
                        ? const Icon(Icons.error_outline)
                        : AnimatedOpacity(
                            opacity: omikujiState.opacityLevel,
                            duration: Duration(
                              seconds: omikujiState.opacityLevel == 0 ? 0 : 2,
                            ),
                            child: Text(
                              '${omikujiState.fortune}\n\n二〇二二年は\n「${omikujiState.message}」\nな一年になるでしょう',
                              style: const TextStyle(
                                fontSize: 32.0,
                                fontFamily: 'YujiSyuku',
                              ),
                            ),
                          ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: omikujiNotifier.drawOmikuji,
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
