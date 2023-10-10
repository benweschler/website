import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class StaggeredParallaxViewDelegate extends MultiChildLayoutDelegate {
  final Animation<double> positionAnimation;
  final int length;
  final bool mobileLayout;

  /// Each size multiplier must be between 0 and 0.2 because I haven't bothered
  /// to make it more standard or abstracted.
  final List<double> sizeMultipliers;

  StaggeredParallaxViewDelegate({
    required this.positionAnimation,
    required this.length,
    required this.mobileLayout,
    required this.sizeMultipliers,
  })  : assert(sizeMultipliers.length == length),
        super(relayout: positionAnimation);

  @override
  void performLayout(Size size) {
    if(mobileLayout) return performMobileLayout(size);

    final position = positionAnimation.value;

    List<Size> sizes = [];
    for (int i = 0; i < length; i++) {
      final width =
          (size.width * 0.9 / 2) * (1 + (2 * sizeMultipliers[i] - 0.2));
      sizes.add(layoutChild(i, BoxConstraints.tightFor(width: width)));
    }

    // The portion of the previous child's height that the top of this child is
    // aligned to.
    const heightScalar = 0.6;
    final totalHeight =
        sizes.fold(0.0, (value, size) => value += size.height * heightScalar) +
            sizes.last.height * (1 - heightScalar);

    double heightSum = 0;
    for (int i = 0; i < length; i++) {
      final xPos = i % 2 == 0 ? 0.0 : size.width - sizes[i].width;

      // Total height from first element to this element
      double yPos = heightSum;

      // Translated up based on scroll position
      yPos -= position * (totalHeight - size.height);

      // Add padding to top and bottom of scroll view. Add 50% more padding at
      // the top since the global header makes it harder to reach the top of the
      // screen.
      final yPadding = 150 * (1.5 - 2 * position);
      yPos += yPadding;

      // This is some tomfoolery right here. It adds parallax, but it's way too
      // janky and it's way too late right now to justify me writing a nice
      // explanation. Make it better later if needed.
      yPos -= (0.2 - sizeMultipliers[i]) *
          Curves.easeIn
              .transform(clampDouble(yPos / size.height * 2, 0, 2) / 2) *
          2 *
          (totalHeight - size.height);

      positionChild(i, Offset(xPos, yPos));

      // Multiply by a factor > 1 to add spacing in between each child
      heightSum += heightScalar * sizes[i].height;
    }
  }

  void performMobileLayout(Size size) {
    final position = positionAnimation.value;

    List<Size> sizes = [];
    for (int i = 0; i < length; i++) {
      final width =
          (size.width * 0.9 / 2) * (1 + (2 * sizeMultipliers[i] - 0.2));
      sizes.add(layoutChild(i, BoxConstraints.tightFor(width: width)));
    }

    // The portion of the previous child's height that the top of this child is
    // aligned to.
    const heightScalar = 0.6;
    final totalHeight =
        sizes.fold(0.0, (value, size) => value += size.height * heightScalar) +
            sizes.last.height * (1 - heightScalar);

    double heightSum = 0;
    for (int i = 0; i < length; i++) {
      final xPos = i % 2 == 0 ? 0.0 : size.width - sizes[i].width;

      // Total height from first element to this element, translated down the
      // height of the screen so that the first element is initially off screen.
      double yPos = heightSum + size.height;

      // Add a small amount of additional padding so that the user has to scroll
      // a small distance the first child comes into view. This also adds a
      // buffer between scrolling the a child out of view triggering the page
      // scroll animation. Interpolate this value from positive to negative,
      // since it should increase the child's y position to push it off the
      // bottom of the screen and increase it to push it off the top of the
      // screen.
      double yPadding = 100 * (1 - 2 * position);
      // Subtract the height of the screen when the position is fully scrolled
      // so that all children are positioned past the top of the screen.
      yPadding -= size.height * position;
      yPos += yPadding;

      // Translated up based on scroll position
      yPos -= position * totalHeight;

      // This is some tomfoolery right here. It adds parallax, but it's way too
      // janky and it's way too late right now to justify me writing a nice
      // explanation. Make it better later if needed.
      yPos -= (0.2 - sizeMultipliers[i]) *
          Curves.easeIn
              .transform(clampDouble(yPos / size.height * 2, 0, 2) / 2) *
          2 *
          (totalHeight - size.height);

      positionChild(i, Offset(xPos, yPos));

      // Multiply by a factor > 1 to add spacing in between each child
      heightSum += heightScalar * sizes[i].height;
    }
  }

  @override
  bool shouldRelayout(StaggeredParallaxViewDelegate oldDelegate) {
    return positionAnimation != oldDelegate.positionAnimation;
  }
}
