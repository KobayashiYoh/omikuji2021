import 'dart:math' as math;

import 'package:english_words/english_words.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omikuji_app/constants/sound_path.dart';
import 'package:omikuji_app/models/omikuji_state.dart';
import 'package:translator/translator.dart';

final omikujiProvider = StateNotifierProvider<OmikujiNotifier, OmikujiState>(
    (ref) => OmikujiNotifier(ref: ref));

class OmikujiNotifier extends StateNotifier<OmikujiState> {
  OmikujiNotifier({required this.ref}) : super(kInitialOmikujiState) {
    _setKanjiYearText();
  }
  final Ref ref;
  String resultSoundPath = SoundPath.shamisen;

  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void _setError(bool value) {
    state = state.copyWith(hasError: value);
  }

  void _setOpacityLevel(double value) {
    state = state.copyWith(opacityLevel: value);
  }

  void _setMute(bool value) {
    state = state.copyWith(isMute: value);
  }

  void switchMute() {
    _setMute(!state.isMute);
  }

  void _setKanjiYearText() {
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
    state = state.copyWith(
      kanjiYearText: kanjiYearText,
    );
  }

  // 1〜100までのFortune IDを生成
  int _generateFortuneId() {
    final rand = math.Random();
    return rand.nextInt(100) + 1;
  }

  // Fortune IDを元に運勢を判定
  void _generateFortune() {
    final String fortune;
    final int fortuneId = _generateFortuneId();
    if (fortuneId == 1) {
      // 沼: ID 1
      fortune = '沼';
      resultSoundPath = SoundPath.numa;
    } else if (fortuneId <= 10) {
      // 大凶: ID 2 ~ 10
      fortune = '大凶';
      resultSoundPath = SoundPath.kyoDaikyo;
    } else if (fortuneId <= 25) {
      // 凶: ID 11 ~ 25
      fortune = '凶';
      resultSoundPath = SoundPath.kyoDaikyo;
    } else if (fortuneId <= 40) {
      // 末吉: ID 26 ~ 40
      fortune = '末吉';
      resultSoundPath = SoundPath.shamisen;
    } else if (fortuneId <= 60) {
      // 吉: ID 41 ~ 60
      fortune = '吉';
      resultSoundPath = SoundPath.shamisen;
    } else if (fortuneId <= 75) {
      // 小吉: ID 61 ~ 75
      fortune = '小吉';
      resultSoundPath = SoundPath.shamisen;
    } else if (fortuneId <= 90) {
      // 中吉: ID 76 ~ 90
      fortune = '中吉';
      resultSoundPath = SoundPath.chukichiDaikyo;
    } else if (fortuneId <= 99) {
      // 大吉: ID 91 ~ 99
      fortune = '大吉';
      resultSoundPath = SoundPath.chukichiDaikyo;
    } else if (fortuneId == 100) {
      // 豪運: ID 100
      fortune = '豪運';
      resultSoundPath = SoundPath.gohun;
    } else {
      // その他
      fortune = '印刷ミス';
      resultSoundPath = SoundPath.shamisen;
    }
    state = state.copyWith(
      fortune: fortune,
    );
  }

  Future<String> _generateMessage() async {
    final translator = GoogleTranslator();
    final Translation translation;
    // スネークケースで英単語のペアを生成（アンダーバーを半角スペースに置き換える）
    final String wordPair = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    _setLoading(true);
    _setError(false);
    try {
      translation = await translator.translate(wordPair, from: 'en', to: 'ja');
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
    _generateFortune();
    final String message = await _generateMessage();
    state = state.copyWith(
      message: message,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    _setOpacityLevel(1.0);
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
