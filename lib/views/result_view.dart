import 'package:flutter/material.dart';
import 'package:omikuji_app/models/omikuji_state.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key, required this.state}) : super(key: key);
  final OmikujiState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: state.opacityLevel,
      duration: Duration(
        seconds: state.animationDurationSeconds,
      ),
      child: Column(
        children: [
          Text(
            state.fortune?.text ?? '',
            style: const TextStyle(
              fontSize: 64.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            '${state.kanjiYearText}年は\n「${state.message}」\nな一年になるでしょう',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32.0),
          ),
          const SizedBox(height: 32.0),
          Text(
            '学問: ${state.academiaAdvice}',
            style: const TextStyle(fontSize: 20.0),
          ),
          Text(
            '商売: ${state.businessAdvice}',
            style: const TextStyle(fontSize: 20.0),
          ),
          Text(
            '恋愛: ${state.loveAdvice}',
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
