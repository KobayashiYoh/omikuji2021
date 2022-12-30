import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji2021/omikuji_notifier.dart';
import 'package:omikuji2021/omikuji_state.dart';

class OmikujiPage extends ConsumerWidget {
  const OmikujiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final omikujiState = ref.watch(omikujiProvider);
    final omikujiNotifier = ref.watch(omikujiProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('おみくじアプリ'),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
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
                              seconds: omikujiState.animationDurationSeconds,
                            ),
                            child: Text(
                              '${omikujiState.fortune}\n\n二〇二二年は\n「${omikujiState.message}」\nな一年になるでしょう',
                              style: const TextStyle(fontSize: 32.0),
                            ),
                          ),
              ),
              const Spacer(),
              SizedBox(
                height: 48.0,
                child: ElevatedButton(
                  onPressed: omikujiNotifier.drawOmikuji,
                  child: const Text(
                    'おみくじを引く',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
