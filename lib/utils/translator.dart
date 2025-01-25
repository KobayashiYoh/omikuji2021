import 'dart:io';

import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:translator/translator.dart';

class Translator {
  Translator._();

  static Future<String> _translateEnglishIntoJapaneseByGoogleTranslator(
    String englishText,
  ) async {
    final translator = GoogleTranslator();
    final translation = await translator.translate(
      englishText,
      from: 'en',
      to: 'ja',
    );
    return translation.text;
  }

  static Future<String> _translateEnglishIntoJapaneseOnDevice(
    String englishText,
  ) async {
    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.japanese,
    );
    final response = await onDeviceTranslator.translateText(englishText);
    return response;
  }

  /// 英語を日本語に翻訳する。
  ///
  /// プラットフォームがAndroidまたはiOSの場合、Google MLKitを用いてon deviceで翻訳する。
  /// それ以外のプラットフォームの場合、Google翻訳を用いて翻訳する。
  static Future<String> translateEnglishIntoJapanese(
    String englishText,
  ) async {
    String japaneseText;
    if (Platform.isAndroid || Platform.isIOS) {
      japaneseText = await _translateEnglishIntoJapaneseOnDevice(
        englishText,
      );
    } else {
      japaneseText = await _translateEnglishIntoJapaneseByGoogleTranslator(
        englishText,
      );
    }
    return japaneseText;
  }
}
