import 'package:english_words/english_words.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omikuji_app/constants/sound_path.dart';
import 'package:omikuji_app/models/omikuji_state.dart';
import 'package:omikuji_app/utils/omikuji_util.dart';
import 'package:translator/translator.dart';

import '../models/fortune.dart';

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

  void _setFortune(Fortune fortune) {
    state = state.copyWith(fortune: fortune);
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

  void _generateFortune() {
    final generatedFortune = OmikujiUtil.generateFortune();
    _setFortune(generatedFortune);
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
