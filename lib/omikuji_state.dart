import 'package:freezed_annotation/freezed_annotation.dart';

part 'omikuji_state.freezed.dart';

@freezed
class OmikujiState with _$OmikujiState {
  const factory OmikujiState({
    required bool isLoading,
    required bool hasError,
    required String fortune,
    required String message,
    required double opacityLevel,
  }) = _OmikujiState;
}

extension OmikujiStateExtention on OmikujiState {
  int get animationDurationSeconds => opacityLevel == 0 ? 0 : 2;
}

const OmikujiState kInitialOmikujiState = OmikujiState(
  isLoading: false,
  hasError: false,
  fortune: '',
  message: '',
  opacityLevel: 0.0,
);
