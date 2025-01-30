import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:omikuji_app/models/omikuji.dart';
import 'package:omikuji_app/models/omikuji_state.dart';
import 'package:omikuji_app/utils/omikuji_generator.dart';

import '../models/fortune.dart';

class UseOmikuji {
  UseOmikuji({
    required this.state,
    required this.drawOmikuji,
    required this.setBannerAd,
  });

  final OmikujiState state;
  final Future<Fortune> Function() drawOmikuji;
  final void Function(Ad ad) setBannerAd;
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

  void setOmikuji(Omikuji omikuji) {
    state.value = state.value.copyWith(omikuji: omikuji);
  }

  void setOpacityLevel(double opacityLevel) {
    state.value = state.value.copyWith(opacityLevel: opacityLevel);
  }

  void setBannerAd(Ad ad) {
    state.value = state.value.copyWith(bannerAd: ad as BannerAd);
  }

  Future<Fortune> drawOmikuji() async {
    setOpacityLevel(0.0);
    setLoading(true);
    setError(false);
    final generatedFortune = OmikujiGenerator.generateFortune();
    final generatedAcademiaAdvice = OmikujiGenerator.generateAdvice(
      generatedFortune,
    );
    final generatedBusinessAdvice = OmikujiGenerator.generateAdvice(
      generatedFortune,
    );
    final generatedLoveAdvice = OmikujiGenerator.generateAdvice(
      generatedFortune,
    );
    String generatedSubTitle = '';
    String generatedMessage = '';
    try {
      generatedSubTitle = await OmikujiGenerator.generateSubTitle();
      generatedMessage = await OmikujiGenerator.generateMessage(
        fortuneText: generatedFortune.text,
        subTitle: generatedSubTitle,
        academicMessage: generatedAcademiaAdvice,
        businessMessage: generatedBusinessAdvice,
        loveMessage: generatedLoveAdvice,
      );
    } catch (e) {
      print(e);
      setError(true);
    } finally {
      setLoading(false);
    }
    final omikuji = Omikuji(
      fortune: generatedFortune,
      subTitle: generatedSubTitle,
      academiaAdvice: generatedAcademiaAdvice,
      businessAdvice: generatedBusinessAdvice,
      loveAdvice: generatedLoveAdvice,
      message: generatedMessage,
    );
    setOmikuji(omikuji);
    await Future.delayed(const Duration(milliseconds: 500));
    setOpacityLevel(1.0);
    await Future.delayed(const Duration(milliseconds: 500));
    if (state.value.isFirstDrawing) {
      setFirstDrawing(false);
    }
    return state.value.omikuji?.fortune ?? Fortune.misprint;
  }

  return UseOmikuji(
    state: state.value,
    drawOmikuji: drawOmikuji,
    setBannerAd: setBannerAd,
  );
}

extension UseOmikujiExtention on UseOmikuji {
  int get animationDurationSeconds => state.opacityLevel == 0 ? 0 : 2;
}
