import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/providers/audio_notifier.dart';
import 'package:omikuji_app/providers/omikuji_notifier.dart';
import 'package:omikuji_app/ui_components/indigo_elevated_button.dart';
import 'package:omikuji_app/ui_components/web_initial_alert_dialog.dart';
import 'package:omikuji_app/views/loading_view.dart';
import 'package:omikuji_app/views/network_error_view.dart';
import 'package:omikuji_app/views/result_view.dart';

class OmikujiPage extends ConsumerStatefulWidget {
  const OmikujiPage({Key? key}) : super(key: key);
  @override
  OmikujiPageState createState() => OmikujiPageState();
}

class OmikujiPageState extends ConsumerState<OmikujiPage> {
  void _onPressedStartButton() {
    final notifier = ref.read(audioProvider.notifier);
    notifier.onPressedMuteButton();
    Navigator.pop(context);
  }

  void _showWebInitialAlertDialog() {
    Future(() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WebInitialAlertDialog(
          onPressed: _onPressedStartButton,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _showWebInitialAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final omikujiState = ref.watch(omikujiProvider);
    final audioState = ref.watch(audioProvider);
    final omikujiNotifier = ref.watch(omikujiProvider.notifier);
    final audioNotifier = ref.watch(audioProvider.notifier);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('おみくじ'),
          backgroundColor: Colors.indigo[900],
          actions: [
            IconButton(
              onPressed: audioNotifier.onPressedMuteButton,
              icon: audioState.isMute
                  ? const Icon(Icons.volume_off_outlined)
                  : const Icon(Icons.volume_up_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(),
                Center(
                  child: omikujiState.isLoading
                      ? const LoadingView()
                      : omikujiState.hasError
                          ? const NetworkErrorView()
                          : ResultView(omikujiState: omikujiState),
                ),
                const Spacer(),
                SizedBox(
                  height: 48.0,
                  child: IndigoElevatedButton(
                    onPressed: omikujiNotifier.drawOmikuji,
                    buttonText: 'おみくじを引く',
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
