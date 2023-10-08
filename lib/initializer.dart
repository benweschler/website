import 'dart:async';

import 'package:flutter/widgets.dart';

const _imageAssetPaths = [
  // GitHub logo
  'assets/github-invertocat-logo.png',

  // SportVue light
  'assets/showcase-media/sportvue/light/calendar-light.png',
  'assets/showcase-media/sportvue/light/dashboard-light.png',
  'assets/showcase-media/sportvue/light/login-light.png',
  'assets/showcase-media/sportvue/light/no-data-light.png',
  'assets/showcase-media/sportvue/light/profile-light.png',
  'assets/showcase-media/sportvue/light/session-data-light.png',
  'assets/showcase-media/sportvue/light/trends-light.png',

  // SportVue dark
  'assets/showcase-media/sportvue/dark/calendar-dark.png',
  'assets/showcase-media/sportvue/dark/dashboard-dark.png',
  'assets/showcase-media/sportvue/dark/login-dark.png',
  'assets/showcase-media/sportvue/dark/no-data-dark.png',
  'assets/showcase-media/sportvue/dark/profile-dark.png',
  'assets/showcase-media/sportvue/dark/session-data-dark.png',
  'assets/showcase-media/sportvue/dark/trends-dark.png',

  // Layover Party
  'assets/showcase-media/layover-party/images/onboarding-one.png',
  'assets/showcase-media/layover-party/images/onboarding-two.png',
  'assets/showcase-media/layover-party/images/onboarding-three.png',
  'assets/showcase-media/layover-party/images/search-bar.png',
  'assets/showcase-media/layover-party/images/trip-ticket.png',
  'assets/showcase-media/layover-party/images/trips.png',

  // Allynd
  'assets/showcase-media/allynd/login.png',
  'assets/showcase-media/allynd/onboarding-one.png',
  'assets/showcase-media/allynd/onboarding-two.png',
  'assets/showcase-media/allynd/onboarding-three.png',
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
