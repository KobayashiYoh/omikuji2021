import 'package:freezed_annotation/freezed_annotation.dart';

import 'fortune.dart';

part 'omikuji_state.freezed.dart';

@freezed
class OmikujiState with _$OmikujiState {
  const factory OmikujiState({
    required bool isLoading,
    required bool hasError,
    required Fortune? fortune,
    required String message,
    required String kanjiYearText,
    required double opacityLevel,
    required bool isMute,
  }) = _OmikujiState;
}

extension OmikujiStateExtention on OmikujiState {
  int get animationDurationSeconds => opacityLevel == 0 ? 0 : 2;
}

OmikujiState initialOmikujiState = const OmikujiState(
  isLoading: false,
  hasError: false,
  fortune: null,
  message: '',
  kanjiYearText: '',
  opacityLevel: 0.0,
  isMute: false,
);
