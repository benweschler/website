import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/screens/main_app_scaffold/main_app_scaffold.dart';
import 'package:website/style/theme.dart';
import 'package:website/theme_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final platformBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  final themeConfig = ThemeConfig(initialBrightness: platformBrightness);

  runApp(
    ChangeNotifierProvider.value(
      value: themeConfig,
      child: const WebApp(),
    ),
  );
}

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ben Weschler',
      debugShowCheckedModeBanner: false,
      theme: AppColors.fromType(
        context.watch<ThemeConfig>().themeType,
      ).toThemeData(),
      home: const MainAppScaffold(),
    );
  }
}
