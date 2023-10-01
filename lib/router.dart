import 'package:go_router/go_router.dart';
import 'package:website/screens/home.dart';

abstract class RoutePaths {
  static const home = '/';
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RoutePaths.home,
      builder: (_, __) => const Home(),
    ),
  ],
);
