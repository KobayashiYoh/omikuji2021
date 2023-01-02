import 'package:flutter/material.dart';
import 'package:omikuji_app/ui_components/indigo_elevated_button.dart';

class WebInitialAlertDialog extends StatelessWidget {
  const WebInitialAlertDialog({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: const Text('おみくじ'),
        content: const Text('ボタンをタップしておみくじを引こう'),
        actions: [
          IndigoElevatedButton(
            onPressed: onPressed,
            buttonText: 'はじめる',
          ),
        ],
      ),
    );
  }
}
