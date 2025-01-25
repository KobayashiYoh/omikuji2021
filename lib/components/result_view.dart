import 'package:flutter/material.dart';
import 'package:omikuji_app/models/omikuji_state.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key, required this.state}) : super(key: key);
  final OmikujiState state;

  @override
  Widget build(BuildContext context) {
    final omikuji = state.omikuji!;
    return AnimatedOpacity(
      opacity: state.opacityLevel,
      duration: Duration(
        seconds: state.animationDurationSeconds,
      ),
      child: Column(
        children: [
          Text(
            omikuji.fortune!.text,
            style: const TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            omikuji.subTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 16.0),
          Text('学問: ${omikuji.academiaAdvice}'),
          Text('商売: ${omikuji.businessAdvice}'),
          Text('恋愛: ${omikuji.loveAdvice}'),
          const SizedBox(height: 16.0),
          Text(omikuji.message),
        ],
      ),
    );
  }
}
