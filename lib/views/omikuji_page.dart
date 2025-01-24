import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omikuji_app/hooks/use_omikuji.dart';
import 'package:omikuji_app/ui_components/web_initial_alert_dialog.dart';
import 'package:omikuji_app/views/loading_view.dart';
import 'package:omikuji_app/views/network_error_view.dart';
import 'package:omikuji_app/views/result_view.dart';

import '../constants/sound_path.dart';

class OmikujiPage extends HookWidget {
  OmikujiPage({Key? key}) : super(key: key);

  final _bgmPlayer = AudioPlayer();
  final _sePlayer = AudioPlayer();

  Future<void> _playSe(String soundPath, bool isMute) async {
    if (isMute) return;
    await _sePlayer.stop();
    await _sePlayer.play(AssetSource(soundPath));
  }

  Future<void> _playBgm(bool isMute) async {
    if (isMute) return;
    await _bgmPlayer.stop();
    await _bgmPlayer.play(AssetSource(SoundPath.bgm));
  }

  void _onPressedSwitchMute(UseOmikuji useOmikuji) {
    useOmikuji.switchMute();
    final isMute = !useOmikuji.state.isMute;
    if (isMute) {
      _bgmPlayer.stop();
      _sePlayer.stop();
      return;
    }
    _playBgm(isMute);
    _playSe(SoundPath.tap, isMute);
  }

  Future<void> _onPressedStartButton(BuildContext context, bool isMute) async {
    await _playSe(SoundPath.tap, isMute);
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> _onPressedDrawOmikuji(UseOmikuji useOmikuji) async {
    await _playSe(SoundPath.tap, useOmikuji.state.isMute);
    final generatedFortune = await useOmikuji.drawOmikuji();
    await _playSe(generatedFortune.soundPath, useOmikuji.state.isMute);
  }

  Future<void> _initialize(BuildContext context, bool isMute) async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(0.15);
    Future(() async {
      if (kIsWeb) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WebInitialAlertDialog(
            onPressed: () => _onPressedStartButton(context, isMute),
          ),
        );
      }
      await _playBgm(isMute);
    });
  }

  void _dispose() {
    _bgmPlayer.dispose();
    _sePlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useState = useOmikuji();
    final state = useState.state;
    useEffect(() {
      _initialize(context, state.isMute);
      return _dispose;
    }, []);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('へんなおみくじ'),
          actions: [
            IconButton(
              onPressed: () => _onPressedSwitchMute(useState),
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
                          : ResultView(state: state),
                ),
                const Spacer(),
                SizedBox(
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () => _onPressedDrawOmikuji(useState),
                    child: Text(state.isFirstDrawing ? 'おみくじを引く' : 'もう一度引いちゃう'),
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
