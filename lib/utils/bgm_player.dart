import 'package:audioplayers/audioplayers.dart';

import '../constants/sound_path.dart';

class BGMPlayer {
  BGMPlayer._();

  static final _player = AudioPlayer();

  static Future<void> initialize() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(0.15);
  }

  static void dispose() {
    _player.dispose();
  }

  static Future<void> play(bool enable) async {
    if (!enable) return;
    await _player.stop();
    await _player.play(AssetSource(SoundPath.bgm));
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
