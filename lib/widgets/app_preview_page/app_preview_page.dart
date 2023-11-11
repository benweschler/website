import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';
import 'package:website/utils/iterable_utils.dart';
import 'package:website/utils/layout_utils.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/widgets/app_preview_page/scrolling_app_frames.dart';
import 'package:website/widgets/tag_chip.dart';

import 'app_preview_frame.dart';

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
            textContent: _PageTextContent(
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
          textContent: _PageTextContent(
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
    // Define children here to prevent them from rebuilding when the
    // ListenableBuilder fires.
    final appPreviewFrames = [
      for (int i = widget.lightAssetPaths.length - 1; i >= 0; i--)
        LayoutId(
          id: i,
          child: AppPreviewFrame(
            lightAssetPath: widget.lightAssetPaths[i],
            darkAssetPath: widget.darkAssetPaths[i],
          ),
        ),
    ];

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
                builder: (_, __) => ScrollingAppFrames(
                  lightAssetPaths: widget.lightAssetPaths,
                  darkAssetPaths: widget.darkAssetPaths,
                  scrollPosition: _mouseYPositionNotifier.value,
                  phoneFrameSizeMultipliers: widget.phoneFrameSizeMultipliers,
                  children: appPreviewFrames,
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

class _MobileLayoutState extends State<_MobileLayout>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<double> _scrollPositionNotifier;
  late final AnimationController _inertiaController;

  @override
  void initState() {
    super.initState();

    final pageController = context.read<RootPageController>();
    _scrollPositionNotifier = ValueNotifier(
        pageController.page > pageController.lastPage ? 0.0 : 1.0);

    _inertiaController = AnimationController.unbounded(vsync: this);
    _inertiaController.addListener(_updateScrollInertia);
  }

  @override
  void dispose() {
    _scrollPositionNotifier.dispose();
    _inertiaController.dispose();
    super.dispose();
  }

  /// Converts a global scroll position to a proportion scrolled of the total
  /// scrollable height amount.
  double _scrollPositionToRelative(double scrollPosition) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Make the total scrollable length 2.5 times the height of the screen.
    return scrollPosition / (screenHeight * 2.5);
  }

  void _onScroll(double delta) {
    if (delta < 0 && _scrollPositionNotifier.value == 0) {
      context.goPrevious();
    } else if (delta > 0 && _scrollPositionNotifier.value == 1) {
      context.goNext();
    }

    // Cancel scroll inertia to start a new scroll.
    _inertiaController.stop();

    final scrollPortion = _scrollPositionToRelative(delta);
    _scrollPositionNotifier.value =
        clampDouble(_scrollPositionNotifier.value + scrollPortion, 0, 1);
  }

  void _onDragEnd(double velocity) {
    final simulation = FrictionSimulation(
      0.05,
      _scrollPositionNotifier.value * MediaQuery.of(context).size.height * 2.5,
      -1 * velocity * 60,
    );
    _inertiaController.animateWith(simulation);
  }

  void _updateScrollInertia() {
    _scrollPositionNotifier.value =
        clampDouble(_scrollPositionToRelative(_inertiaController.value), 0, 1);

    if (_scrollPositionNotifier.value == 0) {
      context.goPrevious();
      _inertiaController.stop();
    } else if (_scrollPositionNotifier.value == 1) {
      context.goNext();
      _inertiaController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define children here to prevent them from rebuilding when the
    // ListenableBuilder fires.
    final appPreviewFrames = [
      for (int i = widget.lightAssetPaths.length - 1; i >= 0; i--)
        LayoutId(
          id: i,
          child: AppPreviewFrame(
            lightAssetPath: widget.lightAssetPaths[i],
            darkAssetPath: widget.darkAssetPaths[i],
          ),
        ),
    ];

    return _ScrollDetector(
      stopScrollInertia: _inertiaController.stop,
      onScroll: _onScroll,
      onDragEnd: _onDragEnd,
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
                  child: ScrollingAppFrames(
                    lightAssetPaths: widget.lightAssetPaths,
                    darkAssetPaths: widget.darkAssetPaths,
                    scrollPosition: _scrollPositionNotifier.value,
                    phoneFrameSizeMultipliers: widget.phoneFrameSizeMultipliers,
                    children: appPreviewFrames,
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

class _PageTextContent extends StatelessWidget {
  final String title;
  final List<TagChip> tagChips;
  final String description;
  final Widget bottomContent;

  const _PageTextContent({
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
          if (context.isWideLayout())
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: tagChips,
            )
          else
            //TODO: not always apparent that the user should scroll
            SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[...tagChips]
                    .separate(const SizedBox(width: 10))
                    .toList(),
              ),
            ),
          const SizedBox(height: 15),
          Text(
            description,
            style: TextStyle(
              // This is necessary to make the text fit on small phones.
              fontSize: context.isWideLayout() ? 24 : 20,
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

/// Detects conventional scrolling on desktop and vertical drag-based scrolling
/// on mobile.
class _ScrollDetector extends StatelessWidget {
  final ValueChanged<double> onScroll;
  final ValueChanged<double> onDragEnd;
  final VoidCallback stopScrollInertia;
  final Widget child;

  const _ScrollDetector({
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
