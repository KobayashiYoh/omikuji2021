import 'package:flutter/material.dart';

class IndigoElevatedButton extends StatelessWidget {
  const IndigoElevatedButton({
    Key? key,
    required this.onPressed,
    required this.buttonText,
    this.fontSize,
  }) : super(key: key);
  final void Function()? onPressed;
  final String buttonText;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo[900],
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
