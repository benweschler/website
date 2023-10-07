import 'dart:async';

import 'package:flutter/widgets.dart';

const _imageAssetPaths = [
  'assets/images/github-invertocat-logo.png',
  'assets/images/sportvue/light/calendar-light.png',
  'assets/images/sportvue/light/dashboard-light.png',
  'assets/images/sportvue/light/login-light.png',
  'assets/images/sportvue/light/no-data-light.png',
  'assets/images/sportvue/light/profile-light.png',
  'assets/images/sportvue/light/session-data-light.png',
  'assets/images/sportvue/light/trends-light.png',
  'assets/images/sportvue/dark/calendar-dark.png',
  'assets/images/sportvue/dark/dashboard-dark.png',
  'assets/images/sportvue/dark/login-dark.png',
  'assets/images/sportvue/dark/no-data-dark.png',
  'assets/images/sportvue/dark/profile-dark.png',
  'assets/images/sportvue/dark/session-data-dark.png',
  'assets/images/sportvue/dark/trends-dark.png',
];

/// Performs initialization logic and returns a stream that yields ints between
/// 0 and 100 represent the progress percentage of initialization.
Stream<int> initializeApp(BuildContext context) {
  final controller = StreamController<int>();
  controller.onListen = () => _precacheAssets(context, controller);
  return controller.stream;
}

void _precacheAssets(
  BuildContext context,
  StreamController controller,
) async {
  for (int i = 0; i < _imageAssetPaths.length; i++) {
    final path = _imageAssetPaths[i];
    await precacheImage(AssetImage(path), context);
    controller.add(
      (i / (_imageAssetPaths.length - 1) * 100).ceil(),
    );
  }

// Add a small delay between when initialization completes and closing the
// login screen to ensure the user sees some frames where the app is 100%
// loaded.
  await Future.delayed(const Duration(milliseconds: 700));
  controller.close();
}
