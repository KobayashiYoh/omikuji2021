import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omikuji_app/models/omikuji_state.dart';
import 'package:omikuji_app/repository/settings_repository.dart';
import 'package:omikuji_app/utils/omikuji_util.dart';

import '../models/fortune.dart';

class UseOmikuji {
  UseOmikuji({
    required this.state,
    required this.switchMute,
    required this.drawOmikuji,
  });

  final OmikujiState state;
  final void Function() switchMute;
  final Future<Fortune> Function() drawOmikuji;
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

  Future<void> generateMessage() async {
    final generatedMessage = await OmikujiUtil.generateMessage();
    setMessage(generatedMessage);
  }

  Future<Fortune> drawOmikuji() async {
    setOpacityLevel(0.0);
    generateFortune();
    generateKanjiYearText();
    setLoading(true);
    setError(false);
    try {
      await generateMessage();
    } catch (e) {
      setError(true);
    } finally {
      setLoading(false);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    setOpacityLevel(1.0);
    await Future.delayed(const Duration(milliseconds: 500));
    return state.value.fortune ?? Fortune.misprint;
  }

  return UseOmikuji(
    state: state.value,
    switchMute: switchMute,
    drawOmikuji: drawOmikuji,
  );
}

extension UseOmikujiExtention on UseOmikuji {
  int get animationDurationSeconds => state.opacityLevel == 0 ? 0 : 2;
}
