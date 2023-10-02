import 'dart:ui';

extension ColorUtils on Color {
  /// The red channel normalized to between 0 and 1
  double get redNorm => red / 255;

  /// The blue channel normalized to between 0 and 1
  double get blueNorm => blue / 255;

  /// The green channel normalized to between 0 and 1
  double get greenNorm => green / 255;
}