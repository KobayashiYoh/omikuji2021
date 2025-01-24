import 'package:flutter/material.dart';
import 'package:omikuji_app/extensions/date_time_extension.dart';
import 'package:omikuji_app/models/omikuji_state.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key, required this.state}) : super(key: key);
  final OmikujiState state;

  @override
  Widget build(BuildContext context) {
    if (state.omikuji.fortune == null) {
      return _EmptyResultView();
    }
    final now = DateTime.now();
    return AnimatedOpacity(
      opacity: state.opacityLevel,
      duration: Duration(
        seconds: state.animationDurationSeconds,
      ),
      child: Column(
        children: [
          Text(
            state.omikuji.fortune?.text ?? '',
            style: const TextStyle(
              fontSize: 64.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            now.isNewYear
                ? '${state.kanjiYearText}年は\n「${state.omikuji.message}」\nな一年になるでしょう'
                : 'あなたの運勢は\n「${state.omikuji.message}」な\n感じになるでしょう',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32.0),
          ),
          const SizedBox(height: 32.0),
          Text(
            '学問: ${state.omikuji.academiaAdvice}',
            style: const TextStyle(fontSize: 20.0),
          ),
          Text(
            '商売: ${state.omikuji.businessAdvice}',
            style: const TextStyle(fontSize: 20.0),
          ),
          Text(
            '恋愛: ${state.omikuji.loveAdvice}',
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

class _EmptyResultView extends StatelessWidget {
  const _EmptyResultView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'ボタンをタップして\nおみくじを引く',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 8.0),
        Icon(Icons.arrow_downward),
      ],
    );
  }
}
