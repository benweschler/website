import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:website/screens/main_app_scaffold.dart';

void main() {
  runApp(const WebApp());
}

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const MainAppScaffold(),
    ),
  ],
);
