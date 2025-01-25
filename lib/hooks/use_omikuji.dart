import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omikuji_app/models/omikuji_state.dart';
import 'package:omikuji_app/utils/omikuji_util.dart';

import '../models/fortune.dart';

class UseOmikuji {
  UseOmikuji({
    required this.state,
    required this.drawOmikuji,
  });

  final OmikujiState state;
  final Future<Fortune> Function() drawOmikuji;
}

UseOmikuji useOmikuji() {
  final state = useState<OmikujiState>(initialOmikujiState);

  void setLoading(bool isLoading) {
    state.value = state.value.copyWith(isLoading: isLoading);
  }

  void setError(bool hasError) {
    state.value = state.value.copyWith(hasError: hasError);
  }

  void setFirstDrawing(bool isFirstDrawing) {
    state.value = state.value.copyWith(isFirstDrawing: isFirstDrawing);
  }

  void setFortune(Fortune fortune) {
    state.value = state.value.copyWith(
      omikuji: state.value.omikuji.copyWith(fortune: fortune),
    );
  }

  void setMessage(String message) {
    state.value = state.value.copyWith(
      omikuji: state.value.omikuji.copyWith(message: message),
    );
  }

  void setAcademiaAdvice(String academiaAdvice) {
    state.value = state.value.copyWith(
      omikuji: state.value.omikuji.copyWith(academiaAdvice: academiaAdvice),
    );
  }

  void setBusinessAdvice(String businessAdvice) {
    state.value = state.value.copyWith(
      omikuji: state.value.omikuji.copyWith(businessAdvice: businessAdvice),
    );
  }

  void setLoveAdvice(String loveAdvice) {
    state.value = state.value.copyWith(
      omikuji: state.value.omikuji.copyWith(loveAdvice: loveAdvice),
    );
  }

  void setKanjiYearText(String kanjiYearText) {
    state.value = state.value.copyWith(kanjiYearText: kanjiYearText);
  }

  void setOpacityLevel(double opacityLevel) {
    state.value = state.value.copyWith(opacityLevel: opacityLevel);
  }

  void generateKanjiYearText() {
    final generatedKanjiYearText = OmikujiUtil.generateKanjiYearText();
    setKanjiYearText(generatedKanjiYearText);
  }

  Fortune generateFortune() {
    final generatedFortune = OmikujiUtil.generateFortune();
    setFortune(generatedFortune);
    return generatedFortune;
  }

  Future<void> generateMessage() async {
    final generatedMessage = await OmikujiUtil.generateMessage();
    setMessage(generatedMessage);
  }

  void generateAdvice(Fortune fortune) {
    final generatedAcademiaAdvice = OmikujiUtil.generateAdvice(fortune);
    setAcademiaAdvice(generatedAcademiaAdvice);
    final generatedBusinessAdvice = OmikujiUtil.generateAdvice(fortune);
    setBusinessAdvice(generatedBusinessAdvice);
    final generatedLoveAdvice = OmikujiUtil.generateAdvice(fortune);
    setLoveAdvice(generatedLoveAdvice);
  }

  Future<Fortune> drawOmikuji() async {
    setOpacityLevel(0.0);
    final fortune = generateFortune();
    generateKanjiYearText();
    generateAdvice(fortune);
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
    if (state.value.isFirstDrawing) {
      setFirstDrawing(false);
    }
    return state.value.omikuji.fortune ?? Fortune.misprint;
  }

  return UseOmikuji(
    state: state.value,
    drawOmikuji: drawOmikuji,
  );
}

extension UseOmikujiExtention on UseOmikuji {
  int get animationDurationSeconds => state.opacityLevel == 0 ? 0 : 2;
}
