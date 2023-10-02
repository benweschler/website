import 'package:flutter/material.dart';
import 'package:website/screens/main_app_scaffold.dart';
import 'package:website/style/theme.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppColors.fromType(ThemeType.light).toThemeData(),
      home: const MainAppScaffold(),
    );
  }
}
