import 'package:flutter/material.dart';
import 'package:omikuji_app/models/omikuji_state.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.omikujiState}) : super(key: key);
  final OmikujiState omikujiState;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: omikujiState.opacityLevel,
      duration: Duration(
        seconds: omikujiState.animationDurationSeconds,
      ),
      child: Text(
        '${omikujiState.fortune}\n\n${omikujiState.kanjiYearText}年は\n「${omikujiState.message}」\nな一年になるでしょう',
        style: const TextStyle(fontSize: 32.0),
      ),
    );
  }
}
