import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_state.freezed.dart';

@freezed
class AudioState with _$AudioState {
  const factory AudioState({
    required bool isMute,
  }) = _AudioState;
}
