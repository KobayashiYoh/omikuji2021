import 'package:freezed_annotation/freezed_annotation.dart';

import 'fortune.dart';

part 'omikuji.freezed.dart';

@freezed
class Omikuji with _$Omikuji {
  const factory Omikuji({
    required Fortune fortune,
    required String subTitle,
    required String academiaAdvice,
    required String businessAdvice,
    required String loveAdvice,
    required String message,
  }) = _Omikuji;
}
