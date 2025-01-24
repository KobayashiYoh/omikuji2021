import 'package:freezed_annotation/freezed_annotation.dart';

import 'fortune.dart';

part 'omikuji.freezed.dart';

@freezed
class Omikuji with _$Omikuji {
  const factory Omikuji({
    required Fortune? fortune,
    required String message,
    required String academiaAdvice,
    required String businessAdvice,
    required String loveAdvice,
  }) = _Omikuji;
}

const Omikuji initialOmikuji = Omikuji(
  fortune: null,
  message: '',
  academiaAdvice: '',
  businessAdvice: '',
  loveAdvice: '',
);
