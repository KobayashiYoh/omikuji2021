import 'dart:math' as math;

import 'package:english_words/english_words.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji2021/omikuji_state.dart';
import 'package:translator/translator.dart';

final omikujiProvider = StateNotifierProvider<OmikujiNotifier, OmikujiState>(
    (ref) => OmikujiNotifier());

class OmikujiNotifier extends StateNotifier<OmikujiState> {
  OmikujiNotifier() : super(kInitialOmikujiState);

  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void _setError(bool value) {
    state = state.copyWith(hasError: value);
  }

  void _setOpacityLevel(double value) {
    state = state.copyWith(opacityLevel: value);
  }

  // 1〜100までのFortune IDを生成
  int _generateFortuneId() {
    final rand = math.Random();
    return rand.nextInt(100) + 1;
  }

  // Fortune IDを元に運勢を判定
  String _getFortune(int fortuneId) {
    if (fortuneId == 1) {
      return '沼'; // 1
    } else if (fortuneId <= 10) {
      return '大凶'; // 2 ~ 10
    } else if (fortuneId <= 25) {
      return '凶'; // 11 ~ 25
    } else if (fortuneId <= 40) {
      return '末吉'; // 26 ~ 40
    } else if (fortuneId <= 60) {
      return '吉'; // 41 ~ 60
    } else if (fortuneId <= 75) {
      return '小吉'; // 61 ~ 75
    } else if (fortuneId <= 90) {
      return '中吉'; // 76 ~ 90
    } else if (fortuneId <= 99) {
      return '大吉'; // 91 ~ 99
    } else if (fortuneId == 100) {
      return '豪運'; // 100
    } else {
      return '印刷ミス';
    }
  }

  // スネークケースで英単語のペアを生成（アンダーバーを半角スペースに置き換える）
  String _generateRandomWordPair() {
    return WordPair.random().asSnakeCase.replaceAll('_', ' ');
  }

  Future<String> _translateEnWordToJa(String englishWord) async {
    final translator = GoogleTranslator();
    final Translation translation;
    _setLoading(true);
    _setError(false);
    try {
      translation =
          await translator.translate(englishWord, from: 'en', to: 'ja');
    } catch (e) {
      _setError(true);
      throw Exception(e);
    } finally {
      _setLoading(false);
    }
    return translation.toString();
  }

  Future<void> drawOmikuji() async {
    _setOpacityLevel(0.0);
    final int fortuneId = _generateFortuneId();
    final String fortune = _getFortune(fortuneId);
    final String randomWordPair = _generateRandomWordPair();
    final String message = await _translateEnWordToJa(randomWordPair);
    state = state.copyWith(
      fortune: fortune,
      message: message,
    );
    await Future.delayed(const Duration(seconds: 1));
    _setOpacityLevel(1.0);
  }
}
