import 'dart:async';

import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

const _imageAssetPaths = [
  'assets/images/github-invertocat-logo.png',
  'assets/images/sportvue/light/calendar-light.png',
  'assets/images/sportvue/light/dashboard-light.png',
  'assets/images/sportvue/light/data-import-light.mp4',
  'assets/images/sportvue/light/login-light.png',
  'assets/images/sportvue/light/no-data-light.png',
  'assets/images/sportvue/light/profile-light.png',
  'assets/images/sportvue/light/session-data-light.png',
  'assets/images/sportvue/light/trends-light.png',
  'assets/images/sportvue/dark/calendar-dark.png',
  'assets/images/sportvue/dark/dashboard-dark.png',
  'assets/images/sportvue/dark/data-import-dark.mp4',
  'assets/images/sportvue/dark/login-dark.png',
  'assets/images/sportvue/dark/no-data-dark.png',
  'assets/images/sportvue/dark/profile-dark.png',
  'assets/images/sportvue/dark/session-data-dark.png',
  'assets/images/sportvue/dark/trends-dark.png',
];

class MediaCache {
  final Map<String, Uint8List> _imageCache = {};

  //final Map<String, VideoPlayerController> _videoCache = {};

  Uint8List getImageBytes(String path) => _imageCache[path]!;

  VideoPlayerController getVideoController(String path) {
    throw UnimplementedError();
    //return _videoCache[path]!;
  }

  late final initializationController =
      StreamController<int>(onListen: initialize);

  /// Cache all media to memory.
  ///
  /// Returns a stream that yields the percent of total assets that have been
  /// loaded on a scale of 0-100;
  void initialize() async {
    for (int i = 0; i < _imageAssetPaths.length; i++) {
      final path = _imageAssetPaths[i];
      final imageBytes = await rootBundle.load(path);
      _imageCache[path] = imageBytes.buffer.asUint8List();
      initializationController.add(
        (i / (_imageAssetPaths.length - 1) * 100).ceil(),
      );
    }
    // Add a small delay between when initialization completes and closing the
    // login screen to ensure the user sees some frames where the app is 100%
    // loaded.
    await Future.delayed(const Duration(milliseconds: 150));
    initializationController.close();
  }
}
