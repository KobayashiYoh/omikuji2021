import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omikuji_app/providers/omikuji_notifier.dart';
import 'package:omikuji_app/ui_components/web_initial_alert_dialog.dart';
import 'package:omikuji_app/views/loading_view.dart';
import 'package:omikuji_app/views/network_error_view.dart';
import 'package:omikuji_app/views/result_view.dart';

import '../constants/sound_path.dart';

class OmikujiPage extends ConsumerStatefulWidget {
  const OmikujiPage({Key? key}) : super(key: key);
  @override
  OmikujiPageState createState() => OmikujiPageState();
}

class OmikujiPageState extends ConsumerState<OmikujiPage> {
  final _bgmPlayer = AudioPlayer();
  final _sePlayer = AudioPlayer();

  Future<void> _playSe(String soundPath) async {
    final state = ref.read(omikujiProvider);
    if (state.isMute) return;
    await _sePlayer.stop();
    await _sePlayer.play(AssetSource(soundPath));
  }

  Future<void> _playBgm(String soundPath) async {
    final state = ref.read(omikujiProvider);
    if (state.isMute) return;
    await _bgmPlayer.stop();
    await _bgmPlayer.play(AssetSource(soundPath));
  }

  void _onPressedSwitchMute() {
    final notifier = ref.read(omikujiProvider.notifier);
    notifier.switchMute();
    final state = ref.read(omikujiProvider);
    if (state.isMute) {
      _bgmPlayer.stop();
      _sePlayer.stop();
      return;
    }
    _playBgm(SoundPath.bgm);
    _playSe(SoundPath.tap);
  }

  void _onPressedStartButton() {
    _playSe(SoundPath.tap);
    Navigator.pop(context);
  }

  void _onPressedDrawOmikuji() async {
    _playSe(SoundPath.tap);
    final notifier = ref.read(omikujiProvider.notifier);
    await notifier.drawOmikuji();
  }

  @override
  void initState() {
    super.initState();
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _bgmPlayer.setVolume(0.15);
    Future(() {
      if (kIsWeb) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WebInitialAlertDialog(
            onPressed: _onPressedStartButton,
          ),
        );
      }
      _playBgm(SoundPath.bgm);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bgmPlayer.dispose();
    _sePlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(omikujiProvider);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('へんなおみくじ'),
          actions: [
            IconButton(
              onPressed: _onPressedSwitchMute,
              icon: state.isMute
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
                  child: state.isLoading
                      ? const LoadingView()
                      : state.hasError
                          ? const NetworkErrorView()
                          : ResultView(omikujiState: state),
                ),
                const Spacer(),
                SizedBox(
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: _onPressedDrawOmikuji,
                    child: const Text('おみくじを引く'),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
