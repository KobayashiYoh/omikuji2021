import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/constants/sound_path.dart';
import 'package:omikuji_app/providers/settings_notifier.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/font_families.dart';
import '../utils/bgm_player.dart';
import '../utils/se_player.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  SettingsNotifier get _notifier => ref.read(settingsNotifierProvider.notifier);

  Future<void> _onToggleIsPlayingBGM(bool isPlayingBGM) async {
    if (isPlayingBGM) {
      await BGMPlayer.play(isPlayingBGM);
    } else {
      await BGMPlayer.stop();
    }
    await _notifier.setIsPlayingBGM(isPlayingBGM);
  }

  Future<void> _onToggleIsPlayingSE(bool isPlayingSE) async {
    if (isPlayingSE) {
      await SEPlayer.play(SoundPath.tap, isPlayingSE);
    } else {
      await SEPlayer.stop();
    }
    await _notifier.setIsPlayingSE(isPlayingSE);
  }

  Future<void> _onPressedPrivacyPolicy(BuildContext context) async {
    final url = dotenv.env['PRIVACY_POLICY_URL'];
    if (url == null) {
      throw Exception('dotenv.env[\'PRIVACY_POLICY_URL\'] is null.');
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  Future<void> _onTapBack(bool isPlayingSE) async {
    await SEPlayer.play(SoundPath.tap, isPlayingSE);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsNotifierProvider);
    final appVersion = ref.watch(appVersionProvider).value;
    final appVersionText = 'v $appVersion';
    final contentPadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _onTapBack(state.isPlayingSE),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('設定'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SettingsList(
            contentPadding: contentPadding.copyWith(
              bottom: contentPadding.bottom,
            ),
            sections: [
              SettingsSection(
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: _onToggleIsPlayingBGM,
                    initialValue: state.isPlayingBGM,
                    title: const Text(
                      'BGM',
                      style: TextStyle(fontFamily: FontFamilies.yujiSyuku),
                    ),
                  ),
                  SettingsTile.switchTile(
                    onToggle: _onToggleIsPlayingSE,
                    initialValue: state.isPlayingSE,
                    title: const Text(
                      '効果音',
                      style: TextStyle(fontFamily: FontFamilies.yujiSyuku),
                    ),
                  ),
                  SettingsTile.navigation(
                    onPressed: _onPressedPrivacyPolicy,
                    title: const Text(
                      'プライバシーポリシー',
                      style: TextStyle(fontFamily: FontFamilies.yujiSyuku),
                    ),
                  ),
                  SettingsTile.navigation(
                    title: const Text(
                      'アプリバージョン',
                      style: TextStyle(fontFamily: FontFamilies.yujiSyuku),
                    ),
                    trailing: Text(appVersionText),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
