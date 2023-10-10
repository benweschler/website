import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/layout_utils.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/widgets/phone_frame.dart';
import 'package:website/widgets/staggered_parallax_view_delegate.dart';
import 'package:website/widgets/tag_chip.dart';

// Make this a stateful widget to store the current mouse position in a state
// variable that is persistent between rebuilds, even though the state is never
// explicitly mutated.
class AppPreviewPage extends StatelessWidget {
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;
  final String title;
  final List<TagChip> tagChips;
  final String description;
  final Widget bottomContent;

  const AppPreviewPage({
    super.key,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
    required this.title,
    required this.tagChips,
    required this.description,
    required this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isWideLayout()) {
          return _WideLayout(
            constraints: constraints,
            lightAssetPaths: lightAssetPaths,
            darkAssetPaths: darkAssetPaths,
            phoneFrameSizeMultipliers: phoneFrameSizeMultipliers,
            textContent: _TextContent(
              title: title,
              tagChips: tagChips,
              description: description,
              bottomContent: bottomContent,
            ),
          );
        }

        return _MobileLayout(
          constraints: constraints,
          lightAssetPaths: lightAssetPaths,
          darkAssetPaths: darkAssetPaths,
          phoneFrameSizeMultipliers: phoneFrameSizeMultipliers,
          textContent: _TextContent(
            title: title,
            tagChips: tagChips,
            description: description,
            bottomContent: bottomContent,
          ),
        );
      },
    );
  }
}

class _WideLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;
  final Widget textContent;

  const _WideLayout({
    required this.constraints,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
    required this.textContent,
  });

  @override
  State<_WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<_WideLayout> {
  // The portion of the total vertical space the mouse is at.
  final _mouseYPositionNotifier = ValueNotifier(0.0);

  void _updateMousePosition(
    PointerHoverEvent event,
    BoxConstraints constraints,
  ) {
    final newPosition = event.localPosition.dy / constraints.maxHeight;
    _mouseYPositionNotifier.value = newPosition;
  }

  @override
  void dispose() {
    _mouseYPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      hitTestBehavior: HitTestBehavior.translucent,
      onHover: (event) => _updateMousePosition(event, widget.constraints),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.constraints.maxWidth > 1500
              ? (widget.constraints.maxWidth - 1500) / 2
              : 0,
        ),
        child: Row(
          children: [
            Expanded(flex: 4, child: widget.textContent),
            Expanded(
              flex: 3,
              child: ListenableBuilder(
                listenable: _mouseYPositionNotifier,
                builder: (_, __) => _ScrollingAppFrames(
                  lightAssetPaths: widget.lightAssetPaths,
                  darkAssetPaths: widget.darkAssetPaths,
                  scrollPosition: _mouseYPositionNotifier.value,
                  phoneFrameSizeMultipliers: widget.phoneFrameSizeMultipliers,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;
  final Widget textContent;

  const _MobileLayout({
    required this.constraints,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
    required this.textContent,
  });

  @override
  State<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<_MobileLayout> {
  final _scrollPositionNotifier = ValueNotifier(0.0);

  @override
  void dispose() {
    _scrollPositionNotifier.dispose();
    super.dispose();
  }

  void _onScroll(double delta) {
    if (delta < 0 && _scrollPositionNotifier.value == 0) {
      context.goPrevious();
    } else if (delta > 0 && _scrollPositionNotifier.value == 1) {
      context.goNext();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    // Make the total scrollable length of the ScrollingAppFrames 2.5 times the
    // height of the screen.
    final scrollPortion = delta / (screenHeight * 2.5);
    _scrollPositionNotifier.value =
        clampDouble(_scrollPositionNotifier.value + scrollPortion, 0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return _ScrollDetector(
      onScroll: _onScroll,
      child: Stack(
        children: [
          Positioned.fill(child: widget.textContent),
          Positioned.fill(
            left: 15,
            right: 15,
            child: ListenableBuilder(
              listenable: _scrollPositionNotifier,
              builder: (_, __) {
                // Clip overflow phone frames
                return ClipRect(
                  child: _ScrollingAppFrames(
                    lightAssetPaths: widget.lightAssetPaths,
                    darkAssetPaths: widget.darkAssetPaths,
                    scrollPosition: _scrollPositionNotifier.value,
                    phoneFrameSizeMultipliers: widget.phoneFrameSizeMultipliers,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollDetector extends StatelessWidget {
  final void Function(double) onScroll;
  final Widget child;

  const _ScrollDetector({
    required this.onScroll,
    required this.child,
  });

  bool _isMobileBrowser(String userAgent) {
    return userAgent.contains('Mobile') ||
        userAgent.contains('Tablet') ||
        userAgent.contains('Android') ||
        userAgent.contains('iOS');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: (details) {
        if (!_isMobileBrowser(window.navigator.userAgent)) return;

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

class _TextContent extends StatelessWidget {
  final String title;
  final List<TagChip> tagChips;
  final String description;
  final Widget bottomContent;

  const _TextContent({
    required this.title,
    required this.tagChips,
    required this.description,
    required this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add top padding to avoid header
          const SizedBox(height: 60),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Libre Baskerville',
              fontSize: 36,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tagChips,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(
              fontSize: 24,
              height: 1.25,
              letterSpacing: 1.33,
            ),
          ),
          const SizedBox(height: 50),
          bottomContent,
        ],
      ),
    );
  }
}

class _ScrollingAppFrames extends StatefulWidget {
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final double scrollPosition;
  final List<double> phoneFrameSizeMultipliers;

  const _ScrollingAppFrames({
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.scrollPosition,
    required this.phoneFrameSizeMultipliers,
  }) : assert(
          lightAssetPaths.length == darkAssetPaths.length &&
              lightAssetPaths.length == phoneFrameSizeMultipliers.length,
          'The number of light asset paths, dark asset paths, and size multipliers must be equal',
        );

  @override
  State<_ScrollingAppFrames> createState() => _ScrollingAppFramesState();
}

class _ScrollingAppFramesState extends State<_ScrollingAppFrames>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);

  @override
  void didUpdateWidget(covariant _ScrollingAppFrames oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.scrollPosition,
      curve: Curves.easeOutQuart,
      duration: 700.ms,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomMultiChildLayout(
        delegate: StaggeredParallaxViewDelegate(
          positionAnimation: _controller,
          length: widget.lightAssetPaths.length,
          mobileLayout: !context.isWideLayout(),
          sizeMultipliers: widget.phoneFrameSizeMultipliers,
        ),
        // Reverse the list to ensure that children appearing first in the
        // scrolling list are painted on top of the children appearing later.
        children: [
          for (int i = widget.lightAssetPaths.length - 1; i >= 0; i--)
            LayoutId(
              id: i,
              child: PhoneFrame(
                child: Image.asset(widget.lightAssetPaths[i])
                    .animate(
                      target: AppColors.of(context).isDark ? 1 : 0,
                      onInit: (controller) => controller.value =
                          AppColors.of(context).isDark ? 1 : 0,
                    )
                    .crossfade(
                      builder: (_) => Image.asset(widget.darkAssetPaths[i]),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
