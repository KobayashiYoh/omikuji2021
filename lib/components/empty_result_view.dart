import 'package:flutter/material.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'ボタンをタップして\nへんなおみくじを引く',
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
