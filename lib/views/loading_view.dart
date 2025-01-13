import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omikuji_app/extensions/build_context_extension.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.isIOS) {
      return const CupertinoActivityIndicator();
    }
    return CircularProgressIndicator(color: Colors.indigo[900]);
  }
}
