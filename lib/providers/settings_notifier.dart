import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/repository/settings_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/settings_state.dart';

part 'settings_notifier.g.dart';

@riverpod

/// アプリのバージョンを管理するためのProvider。
///
/// アプリバージョンを取得するためだけにSettingsNotifierのstateをSettingsState型からFuture<SettingsState>型に変更するのを防ぐため、
/// appVersionだけSettingsNotifierのstateから切り離してappVersionProviderを作成している。
///
Future<String> appVersion(Ref ref) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  } catch (e) {
    return 'Unknown';
  }
}

@riverpod

/// 設定情報を管理するためのNotifier。
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() {
    final state = _readStateFromLocalStorage();
    return state;
  }

  SettingsState _readStateFromLocalStorage() {
    final repository = SettingsRepository.instance;
    return initialSettingsState.copyWith(
      isPlayingBGM: repository.readIsPlayingBGM(),
      isPlayingSE: repository.readIsPlayingSE(),
    );
  }

  Future<void> setIsPlayingBGM(bool isPlayingBGM) async {
    state = state.copyWith(isPlayingBGM: isPlayingBGM);
    await SettingsRepository.instance.writeIsPlayingBGM(isPlayingBGM);
  }

  Future<void> setIsPlayingSE(bool isPlayingSE) async {
    state = state.copyWith(isPlayingSE: !state.isPlayingSE);
    await SettingsRepository.instance.writeIsPlayingSE(isPlayingSE);
  }
}
