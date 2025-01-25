import 'package:audioplayers/audioplayers.dart';

class SEPlayer {
  SEPlayer._();

  static final _player = AudioPlayer();

  static Future<void> initialize() async {
    await _player.setVolume(0.15);
  }

  static void dispose() {
    _player.dispose();
  }

  static Future<void> play(String soundPath, bool enable) async {
    if (!enable) return;
    await _player.stop();
    await _player.play(AssetSource(soundPath));
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
