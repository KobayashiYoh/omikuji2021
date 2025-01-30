import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omikuji_app/extensions/build_context_extension.dart';

/// 広告に関するHelperクラス。
class AdHelper {
  AdHelper._();

  /// バナー広告の読み込みに失敗した際に実行する共通のコールバック関数。
  static void _onAdFailedToLoad(ad, err) {
    debugPrint('Failed to load a banner ad: ${err.message}');
    ad.dispose();
  }

  /// バナー広告の読み込みを行う共通の関数。
  static Future<void> loadBannerAd({
    required String adUnitId,
    required void Function(Ad)? onAdLoaded,
  }) async {
    await BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: _onAdFailedToLoad,
      ),
    ).load();
  }

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
}
