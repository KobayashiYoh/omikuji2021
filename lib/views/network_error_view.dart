import 'package:flutter/material.dart';

class NetworkErrorView extends StatelessWidget {
  const NetworkErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          '通信障害',
          style: TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 32.0),
        Text(
          '通信環境の良い場所で\n再度お試しください。',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32.0),
        ),
      ],
    );
  }
}
