import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/screens/main_app_scaffold/main_app_scaffold.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/theme_config.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatefulWidget {
  const WebApp({super.key});

  @override
  State<WebApp> createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  final ThemeConfig _themeConfig = ThemeConfig();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeConfig,
      child: ListenableBuilder(
        listenable: _themeConfig,
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppColors.fromType(_themeConfig.themeType).toThemeData(),
          home: const MainAppScaffold(),
        ),
      ),
    );
  }
}
