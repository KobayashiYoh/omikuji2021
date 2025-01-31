import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required bool isPlayingBGM,
    required bool isPlayingSE,
  }) = _SettingsState;
}

const SettingsState initialSettingsState = SettingsState(
  isPlayingBGM: true,
  isPlayingSE: true,
);
