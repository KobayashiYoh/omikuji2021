import 'dart:math' as math;

import 'package:english_words/english_words.dart';
import 'package:omikuji_app/extensions/date_time_extension.dart';
import 'package:omikuji_app/services/gemini_client.dart';
import 'package:omikuji_app/utils/translator.dart';

import '../models/fortune.dart';

/// おみくじの生成に関するクラス。
class OmikujiGenerator {
  OmikujiGenerator._();

  /// ランダムで運勢を生成する。
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

  /// ランダムな単語を含むおみくじのサブタイトルを生成する。
  ///
  /// ランダムな英単語のペアを日本語に翻訳して変な日本語を生成することにより、
  /// 変な日本語を生成している。
  static Future<String> generateSubTitle({
    DateTime? now,
  }) async {
    now ??= DateTime.now();
    // ランダムな英単語のペアを生成（アンダーバーで区切られているので半角スペースに置き換え）
    final englishWordPair = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    final japaneseMessage = await Translator.translateEnglishIntoJapanese(
      englishWordPair,
    );
    // 新年のみ今年の運勢を占う。
    final message = now.isNewYear
        ? '${generateKanjiYearText(now)}年は\n「${japaneseMessage}」\nな一年になるでしょう'
        : 'あなたの運勢は\n「${japaneseMessage}」な\n感じになるでしょう';
    return message;
  }

  /// 引数に与えられた運勢を元に事前に定義したランダムなアドバイスのテキストを返す。
  static String generateAdvice(Fortune fortune) {
    final rand = math.Random();
    final adviceIndex = rand.nextInt(fortune.advices.length);
    final advice = fortune.advices.elementAt(adviceIndex);
    return advice;
  }

  /// おみくじの内容を踏まえたメッセージを生成する。
  static Future<String> generateMessage({
    required String fortuneText,
    required String subTitle,
    required String academicMessage,
    required String businessMessage,
    required String loveMessage,
  }) async {
    final omikujiOverviewText = '''
      運勢：$fortuneText
      サブタイトル：$subTitle
      学問：$academicMessage
      商売：$businessMessage
      恋愛：$loveMessage
    ''';
    final message = await GeminiClient.instance.generateMessage(
      inputText: omikujiOverviewText,
    );
    return message.replaceAll('\n', ' ');
  }

  /// DateTimeの数字部分を漢数字に変換したテキストを生成する。
  static String generateKanjiYearText(DateTime dateTime) {
    final String yearText = dateTime.year.toString();
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
