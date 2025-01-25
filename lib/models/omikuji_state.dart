import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:omikuji_app/models/omikuji.dart';

part 'omikuji_state.freezed.dart';

@freezed
class OmikujiState with _$OmikujiState {
  const factory OmikujiState({
    required bool isLoading,
    required bool hasError,
    required bool isFirstDrawing,
    required Omikuji? omikuji,
    required double opacityLevel,
  }) = _OmikujiState;
}

extension OmikujiStateExtention on OmikujiState {
  int get animationDurationSeconds => opacityLevel == 0 ? 0 : 2;
}

OmikujiState initialOmikujiState = const OmikujiState(
  isLoading: false,
  hasError: false,
  isFirstDrawing: true,
  omikuji: null,
  opacityLevel: 0.0,
);
