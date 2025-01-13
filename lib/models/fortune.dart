import '../constants/sound_path.dart';

enum Fortune {
  daidaikyo('大々凶', SoundPath.daidaikyo),
  daikyo('大凶', SoundPath.kyoDaikyo),
  kyo('凶', SoundPath.kyoDaikyo),
  suekichi('末吉', SoundPath.shamisen),
  kichi('吉', SoundPath.shamisen),
  shokichi('小吉', SoundPath.shamisen),
  chukichi('中吉', SoundPath.chukichiDaikichi),
  daikichi('大吉', SoundPath.chukichiDaikichi),
  daidaikichi('大々吉', SoundPath.daidaikichi),
  misprint('印刷ミス', SoundPath.shamisen);

  final String text;
  final String soundPath;

  const Fortune(this.text, this.soundPath);
}
