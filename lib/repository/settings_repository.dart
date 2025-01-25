import 'package:shared_preferences/shared_preferences.dart';

/// SettingsRepositoryで使用するキーを定義。
class _SettingsKeys {
  _SettingsKeys._();

  static const isPlayingBGM = 'is_playing_bgm';
  static const isPlayingSE = 'is_playing_se';
}

/// 設定情報をSharedPreferenceから入出力するためのRepository。
class SettingsRepository {
  SettingsRepository._privateConstructor();

  static final SettingsRepository _instance =
      SettingsRepository._privateConstructor();
  static SettingsRepository get instance => _instance;

  late SharedPreferences _prefs;

  Future<void> init({SharedPreferences? prefs}) async {
    if (prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      _prefs = prefs;
    }
  }

  Future<void> writeIsPlayingBGM(bool isPlayingBGM) async {
    await instance._prefs.setBool(_SettingsKeys.isPlayingBGM, isPlayingBGM);
  }

  bool readIsPlayingBGM() {
    return instance._prefs.getBool(_SettingsKeys.isPlayingBGM) ?? true;
  }

  Future<void> writeIsPlayingSE(bool isPlayingSE) async {
    await instance._prefs.setBool(_SettingsKeys.isPlayingSE, isPlayingSE);
  }

  bool readIsPlayingSE() {
    return instance._prefs.getBool(_SettingsKeys.isPlayingSE) ?? true;
  }
}
