import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'settings_state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required bool isPlayingBGM,
    required bool isPlayingSE,
    required BannerAd? bannerAd,
  }) = _SettingsState;
}

const SettingsState initialSettingsState = SettingsState(
  isPlayingBGM: true,
  isPlayingSE: true,
  bannerAd: null,
);
