import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:omikuji_app/pages/omikuji_page.dart';
import 'package:omikuji_app/repository/settings_repository.dart';
import 'package:omikuji_app/theme/app_theme.dart';
import 'package:omikuji_app/utils/bgm_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SettingsRepository.instance.init();
  await BGMPlayer.initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'おみくじ',
      theme: appTheme,
      home: const OmikujiPage(),
    );
  }
}
