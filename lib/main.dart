import 'package:flutter/material.dart';
import 'package:website/screens/main_app_scaffold.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainAppScaffold(),
    );
  }
}
