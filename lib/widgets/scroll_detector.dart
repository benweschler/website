import 'dart:html' as html;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// Detects conventional scrolling on desktop and vertical drag-based scrolling
/// on mobile.
class ScrollDetector extends StatelessWidget {
  final ValueChanged<double> onScroll;
  final ValueChanged<double> onDragEnd;
  final VoidCallback stopScrollInertia;
  final Widget child;

  const ScrollDetector({
    super.key,
    required this.onScroll,
    required this.onDragEnd,
    required this.stopScrollInertia,
    required this.child,
  });

  bool _isMobileBrowser() {
    final userAgent = html.window.navigator.userAgent;
    return userAgent.contains('Mobile') ||
        userAgent.contains('Tablet') ||
        userAgent.contains('Android') ||
        userAgent.contains('iOS');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => stopScrollInertia(),
      onVerticalDragEnd: (details) {
        if (!_isMobileBrowser()) return;
        onDragEnd(details.velocity.pixelsPerSecond.dy / 60);
      },
      onVerticalDragUpdate: (details) {
        if (!_isMobileBrowser()) return;
        // Mobile scrolling has opposite delta as trackpad scrolling for a given
        // direction.
        onScroll(-1 * details.delta.dy);
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (PointerSignalEvent signalEvent) {
          if (signalEvent is! PointerScrollEvent) return;

          onScroll(signalEvent.scrollDelta.dy);
        },
        child: child,
      ),
    );
  }
}
