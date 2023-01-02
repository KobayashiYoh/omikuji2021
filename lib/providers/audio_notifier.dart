import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/constants/sound_path.dart';
import 'package:omikuji_app/models/audio_state.dart';

final audioProvider =
    StateNotifierProvider<AudioNotifier, AudioState>((ref) => AudioNotifier());

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayer bgmPlayer = AudioPlayer();
  final AudioPlayer sePlayer = AudioPlayer();
  AudioNotifier() : super(const AudioState(isMute: true)) {
    bgmPlayer.setReleaseMode(ReleaseMode.loop);
    bgmPlayer.setVolume(0.2);
    if (!kIsWeb) {
      switchMute();
    }
  }

  void _setMute(bool value) {
    state = state.copyWith(isMute: value);
  }

  void _playSe(String soundPath) {
    if (state.isMute) {
      return;
    }
    sePlayer.stop();
    sePlayer.play(AssetSource(soundPath));
  }

  void playTapSe() {
    _playSe(SoundPath.tap);
  }

  void playResultSE(String soundPath) {
    _playSe(soundPath);
  }

  void switchMute() {
    if (state.isMute) {
      bgmPlayer.play(AssetSource(SoundPath.bgm));
      _setMute(false);
      playTapSe();
    } else {
      bgmPlayer.stop();
      _setMute(true);
    }
  }
}
