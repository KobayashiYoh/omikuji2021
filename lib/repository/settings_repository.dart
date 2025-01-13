import 'package:shared_preferences/shared_preferences.dart';

/// SettingsRepositoryで使用するキーを定義。
class _SettingsKeys {
  _SettingsKeys._();

  static const isMute = 'is_mute';
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

  Future<void> writeIsMute(bool isMute) async {
    await instance._prefs.setBool(_SettingsKeys.isMute, isMute);
  }

  bool readIsMute() {
    return instance._prefs.getBool(_SettingsKeys.isMute) ?? false;
  }
}
