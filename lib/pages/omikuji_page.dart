import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/components/loading_view.dart';
import 'package:omikuji_app/components/network_error_view.dart';
import 'package:omikuji_app/components/result_view.dart';
import 'package:omikuji_app/hooks/use_omikuji.dart';
import 'package:omikuji_app/pages/settings_page.dart';
import 'package:omikuji_app/providers/settings_notifier.dart';
import 'package:omikuji_app/utils/bgm_player.dart';
import 'package:omikuji_app/utils/se_player.dart';

import '../components/web_initial_alert_dialog.dart';
import '../constants/sound_path.dart';

class OmikujiPage extends HookConsumerWidget {
  const OmikujiPage({Key? key}) : super(key: key);

  Future<void> _onPressedStartButton(
      BuildContext context, bool isPlayingSE) async {
    await SEPlayer.play(SoundPath.tap, isPlayingSE);
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> _onPressedSettings(
    BuildContext context,
    bool isPlayingSE,
  ) async {
    await SEPlayer.play(SoundPath.tap, isPlayingSE);
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }

  Future<void> _onPressedDrawOmikuji(
    UseOmikuji useOmikuji,
    bool isPlayingSE,
  ) async {
    await SEPlayer.play(SoundPath.tap, isPlayingSE);
    final generatedFortune = await useOmikuji.drawOmikuji();
    await SEPlayer.play(generatedFortune.soundPath, isPlayingSE);
  }

  Future<void> _initialize(
    BuildContext context,
    bool isPlayingBGM,
    isPlayingSE,
  ) async {
    Future(() async {
      if (kIsWeb) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WebInitialAlertDialog(
            onPressed: () => _onPressedStartButton(context, isPlayingSE),
          ),
        );
      }
      await BGMPlayer.play(isPlayingBGM);
    });
  }

  void _dispose() {
    BGMPlayer.dispose();
    SEPlayer.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.read(settingsNotifierProvider);
    final useState = useOmikuji();
    final state = useState.state;
    useEffect(() {
      _initialize(
        context,
        settingsState.isPlayingBGM,
        settingsState.isPlayingSE,
      );
      return _dispose;
    }, []);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('へんなおみくじ'),
          actions: [
            IconButton(
              onPressed: () => _onPressedSettings(
                context,
                settingsState.isPlayingSE,
              ),
              icon: const Icon(Icons.settings_outlined),
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
                    onPressed: () => _onPressedDrawOmikuji(
                      useState,
                      settingsState.isPlayingSE,
                    ),
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
