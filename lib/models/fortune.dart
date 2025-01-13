import '../constants/sound_path.dart';

enum Fortune {
  numa('沼', SoundPath.numa),
  daikyo('大凶', SoundPath.kyoDaikyo),
  kyo('凶', SoundPath.kyoDaikyo),
  suekichi('末吉', SoundPath.shamisen),
  kichi('吉', SoundPath.shamisen),
  shokichi('小吉', SoundPath.shamisen),
  chukichi('中吉', SoundPath.chukichiDaikyo),
  daikichi('大吉', SoundPath.chukichiDaikyo),
  gohun('豪運', SoundPath.gohun),
  misprint('印刷ミス', SoundPath.shamisen);

  final String text;
  final String soundPath;

  const Fortune(this.text, this.soundPath);
}
