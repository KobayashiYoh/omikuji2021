import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/providers/audio_notifier.dart';
import 'package:omikuji_app/providers/omikuji_notifier.dart';
import 'package:omikuji_app/result_view.dart';
import 'package:omikuji_app/views/network_error_view.dart';

class OmikujiPage extends ConsumerWidget {
  const OmikujiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final omikujiState = ref.watch(omikujiProvider);
    final audioState = ref.watch(audioProvider);
    final omikujiNotifier = ref.watch(omikujiProvider.notifier);
    final audioNotifier = ref.watch(audioProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('おみくじアプリ'),
        actions: [
          IconButton(
            onPressed: audioNotifier.onPressedMuteButton,
            icon: audioState.isMute
                ? const Icon(Icons.volume_off_outlined)
                : const Icon(Icons.volume_up_outlined),
          ),
        ],
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
                        ? const NetworkErrorView()
                        : ResultPage(omikujiState: omikujiState),
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
