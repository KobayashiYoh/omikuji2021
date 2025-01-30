import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:omikuji_app/extensions/build_context_extension.dart';

/// 広告に関するHelperクラス。
class AdHelper {
  AdHelper._();

  /// Ad Unit IDを取得する。
  ///
  /// OSごと、環境ごとにそれぞれ異なるAd Unit IDを取得する。
  ///
  /// [context] は[BuildContext]。
  /// [androidKey] はAndroid用のAd Unit IDのキー。
  /// [iosKey] はiOS用のAd Unit IDのキー。
  ///
  static String _getAdUnitId({
    required BuildContext context,
    required String androidKey,
    required String iosKey,
  }) {
    String? adUnitId;
    if (context.isAndroid) {
      adUnitId = dotenv.env[androidKey];
    } else if (context.isIOS) {
      adUnitId = dotenv.env[iosKey];
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    if (adUnitId == null) {
      throw StateError('Ad Unit ID is null. Please check your .env file.');
    }
    return adUnitId;
  }

  static String settingsPageBannerAdUnitId(BuildContext context) {
    return _getAdUnitId(
      context: context,
      androidKey: 'ANDROID_SETTINGS_PAGE_BANNER_AD_UNIT_ID',
      iosKey: 'IOS_SETTINGS_PAGE_BANNER_AD_UNIT_ID',
    );
  }

  static String omikujiPageBannerAdUnitId(BuildContext context) {
    return _getAdUnitId(
      context: context,
      androidKey: 'ANDROID_OMIKUJI_PAGE_BANNER_AD_UNIT_ID',
      iosKey: 'IOS_OMIKUJI_PAGE_BANNER_AD_UNIT_ID',
    );
  }

  /// バナー広告をロードする際に実行する共通のコールバック関数。
  static void onAdFailedToLoad(ad, err) {
    debugPrint('Failed to load a banner ad: ${err.message}');
    ad.dispose();
  }
}
