import 'dart:async';

import 'package:flutter/widgets.dart';

const _imageAssetPaths = [
  // GitHub logo
  'assets/github-invertocat-logo.png',
  'assets/devpost-logo.png',
  'assets/shadertoy-logo.png',

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

  // Layover Party Images
  'assets/showcase-media/layover-party/images/onboarding-one.png',
  'assets/showcase-media/layover-party/images/onboarding-two.png',
  'assets/showcase-media/layover-party/images/onboarding-three.png',
  'assets/showcase-media/layover-party/images/search-bar.png',
  'assets/showcase-media/layover-party/images/trip-ticket.png',
  'assets/showcase-media/layover-party/images/trips.png',

  // Dragonator light
  'assets/showcase-media/dragonator/light/create-paddler-light.png',
  'assets/showcase-media/dragonator/light/roster-light.png',
  'assets/showcase-media/dragonator/light/edit-lineup-light.png',
  'assets/showcase-media/dragonator/light/paddler-details-light.png',
  'assets/showcase-media/dragonator/light/settings-light.png',

  // Dragonator dark
  'assets/showcase-media/dragonator/dark/create-paddler-dark.png',
  'assets/showcase-media/dragonator/dark/roster-dark.png',
  'assets/showcase-media/dragonator/dark/edit-lineup-dark.png',
  'assets/showcase-media/dragonator/dark/paddler-details-dark.png',
  'assets/showcase-media/dragonator/dark/settings-dark.png',

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
  await Future.delayed(const Duration(milliseconds: 100));
  controller.close();
}
