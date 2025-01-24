import 'package:omikuji_app/constants/advices.dart';

import '../constants/sound_path.dart';

enum Fortune {
  daidaikyo(
    text: '大々凶',
    soundPath: SoundPath.daidaikyo,
    advices: Advices.worstList,
  ),
  daikyo(
    text: '大凶',
    soundPath: SoundPath.kyoDaikyo,
    advices: [...Advices.worstList, ...Advices.badList],
  ),
  kyo(
    text: '凶',
    soundPath: SoundPath.kyoDaikyo,
    advices: Advices.badList,
  ),
  suekichi(
    text: '末吉',
    soundPath: SoundPath.shamisen,
    advices: [...Advices.badList, ...Advices.neutralList],
  ),
  kichi(
    text: '吉',
    soundPath: SoundPath.shamisen,
    advices: Advices.neutralList,
  ),
  shokichi(
    text: '小吉',
    soundPath: SoundPath.shamisen,
    advices: [...Advices.goodList, ...Advices.neutralList],
  ),
  chukichi(
    text: '中吉',
    soundPath: SoundPath.chukichiDaikichi,
    advices: Advices.goodList,
  ),
  daikichi(
    text: '大吉',
    soundPath: SoundPath.chukichiDaikichi,
    advices: [...Advices.bestList, ...Advices.goodList],
  ),
  daidaikichi(
    text: '大々吉',
    soundPath: SoundPath.daidaikichi,
    advices: Advices.bestList,
  ),
  misprint(
    text: '印刷ミス',
    soundPath: SoundPath.shamisen,
    advices: [],
  );

  final String text;
  final String soundPath;
  final List<String> advices;

  const Fortune({
    required this.text,
    required this.soundPath,
    required this.advices,
  });
}
