import 'dart:math' as math;

import '../models/fortune.dart';

class OmikujiUtil {
  OmikujiUtil._();

  static Fortune generateFortune() {
    final rand = math.Random();
    final fortuneId = rand.nextInt(100) + 1;
    if (fortuneId == 1) {
      return Fortune.numa;
    } else if (fortuneId <= 10) {
      return Fortune.daikyo;
    } else if (fortuneId <= 25) {
      return Fortune.kyo;
    } else if (fortuneId <= 40) {
      return Fortune.suekichi;
    } else if (fortuneId <= 60) {
      return Fortune.kichi;
    } else if (fortuneId <= 75) {
      return Fortune.shokichi;
    } else if (fortuneId <= 90) {
      return Fortune.chukichi;
    } else if (fortuneId <= 99) {
      return Fortune.daikichi;
    } else if (fortuneId == 100) {
      return Fortune.gohun;
    } else {
      return Fortune.misprint;
    }
  }
}
