import 'dart:math' as math;

import 'package:english_words/english_words.dart';
import 'package:omikuji_app/utils/translator.dart';

import '../models/fortune.dart';

class OmikujiUtil {
  OmikujiUtil._();

  static Fortune generateFortune() {
    final rand = math.Random();
    final fortuneId = rand.nextInt(100) + 1;
    if (fortuneId == 1) {
      return Fortune.daidaikyo;
    } else if (fortuneId <= 10) {
      return Fortune.daikyo;
    } else if (fortuneId <= 25) {
      return Fortune.kyo;
    } else if (fortuneId <= 40) {
      return Fortune.suekichi;
    } else if (fortuneId <= 60) {
      return Fortune.kichi;
    } else if (fortuneId <= 75) {
      return Fortune.shokichi;
    } else if (fortuneId <= 90) {
      return Fortune.chukichi;
    } else if (fortuneId <= 99) {
      return Fortune.daikichi;
    } else if (fortuneId == 100) {
      return Fortune.daidaikichi;
    } else {
      return Fortune.misprint;
    }
  }

  /// ランダムなメッセージを生成する。
  ///
  /// ランダムな英単語のペアを日本語に翻訳して変な日本語を生成することにより、
  /// 変な日本語を生成している。
  static Future<String> generateMessage() async {
    // ランダムな英単語のペアを生成（アンダーバーで区切られているので半角スペースに置き換え）
    final englishWordPair = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    final japaneseMessage = await Translator.translateEnglishIntoJapanese(
      englishWordPair,
    );
    return japaneseMessage;
  }

  static String generateAdvice(Fortune fortune) {
    final rand = math.Random();
    final adviceIndex = rand.nextInt(fortune.advices.length);
    final advice = fortune.advices.elementAt(adviceIndex);
    return advice;
  }

  static String generateKanjiYearText() {
    final DateTime now = DateTime.now();
    final String yearText = now.year.toString();
    final String kanjiYearText = yearText
        .replaceAll('0', '〇')
        .replaceAll('1', '一')
        .replaceAll('2', '二')
        .replaceAll('3', '三')
        .replaceAll('4', '四')
        .replaceAll('5', '五')
        .replaceAll('6', '六')
        .replaceAll('7', '七')
        .replaceAll('8', '八')
        .replaceAll('9', '九');
    return kanjiYearText;
  }
}
