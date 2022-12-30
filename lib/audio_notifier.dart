import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/audio_state.dart';
import 'package:omikuji_app/constants/sound_path.dart';

final audioProvider =
    StateNotifierProvider<AudioNotifier, AudioState>((ref) => AudioNotifier());

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayer bgmPlayer = AudioPlayer();
  AudioNotifier() : super(const AudioState(isPlaying: false)) {
    bgmPlayer.setReleaseMode(ReleaseMode.loop);
    bgmPlayer.setVolume(0.1);
  }

  void _setPlaying() {
    bgmPlayer.onPlayerStateChanged.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState == PlayerState.playing,
      );
    });
  }

  void onPressedBgmButton() {
    if (state.isPlaying) {
      bgmPlayer.stop();
    } else {
      bgmPlayer.play(AssetSource(SoundPath.bgm));
    }
    _setPlaying();
  }
}
