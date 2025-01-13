import 'package:english_words/english_words.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omikuji_app/models/omikuji_state.dart';
import 'package:omikuji_app/repository/settings_repository.dart';
import 'package:omikuji_app/utils/omikuji_util.dart';
import 'package:translator/translator.dart';

import '../models/fortune.dart';

class UseOmikuji {
  UseOmikuji({required this.state});

  final OmikujiState state;
}

UseOmikuji useOmikuji() {
  final initialState = initialOmikujiState.copyWith(
    isMute: SettingsRepository.instance.readIsMute(),
  );
  final state = useState<OmikujiState>(initialState);

  void setLoading(bool isLoading) {
    state.value = state.value.copyWith(isLoading: isLoading);
  }

  void setError(bool hasError) {
    state.value = state.value.copyWith(hasError: hasError);
  }

  void setFortune(Fortune fortune) {
    state.value = state.value.copyWith(fortune: fortune);
  }

  void setMessage(String message) {
    state.value = state.value.copyWith(message: message);
  }

  void setKanjiYearText(String kanjiYearText) {
    state.value = state.value.copyWith(kanjiYearText: kanjiYearText);
  }

  void setOpacityLevel(double opacityLevel) {
    state.value = state.value.copyWith(opacityLevel: opacityLevel);
  }

  void setMute(bool isMute) {
    state.value = state.value.copyWith(isMute: isMute);
  }

  void switchMute() {
    setMute(!state.value.isMute);
    SettingsRepository.instance.writeIsMute(state.value.isMute);
  }

  void generateKanjiYearText() {
    final generatedKanjiYearText = OmikujiUtil.generateKanjiYearText();
    setKanjiYearText(generatedKanjiYearText);
  }

  void generateFortune() {
    final generatedFortune = OmikujiUtil.generateFortune();
    setFortune(generatedFortune);
  }

  Future<String> generateMessage() async {
    final translator = GoogleTranslator();
    final Translation translation;
    // スネークケースで英単語のペアを生成（アンダーバーを半角スペースに置き換える）
    final String wordPair = WordPair.random().asSnakeCase.replaceAll('_', ' ');
    setLoading(true);
    setError(false);
    try {
      translation = await translator.translate(wordPair, from: 'en', to: 'ja');
    } catch (e) {
      setError(true);
      throw Exception(e);
    } finally {
      setLoading(false);
    }
    return translation.toString();
  }

  Future<void> drawOmikuji() async {
    setOpacityLevel(0.0);
    generateFortune();
    generateKanjiYearText();
    final String message = await generateMessage();
    setMessage(message);
    await Future.delayed(const Duration(milliseconds: 500));
    setOpacityLevel(1.0);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  return UseOmikuji(
    state: state.value.copyWith(
      switchMute: switchMute,
      drawOmikuji: drawOmikuji,
    ),
  );
}

extension UseOmikujiExtention on UseOmikuji {
  int get animationDurationSeconds => state.opacityLevel == 0 ? 0 : 2;
}
