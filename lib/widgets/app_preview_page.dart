import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/iterable_utils.dart';
import 'package:website/utils/layout_utils.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/widgets/buttons/responsive_button.dart';
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

class _MobileLayoutState extends State<_MobileLayout>
    with SingleTickerProviderStateMixin {
  final _scrollPositionNotifier = ValueNotifier(0.0);
  late final _inertiaController =
      AnimationController.unbounded(value: 0, vsync: this);

  @override
  void initState() {
    super.initState();
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

    // Cancel scroll inertia to start a new scroll
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
      // In mobile layout, easing really only takes effect when the user stops
      // scrolling, since the scroll inertia controller takes care of easing the
      // rest of the time. Only use a small amount of easing to maintain a
      // responsive feel.
      duration: context.isWideLayout() ? 700.ms : 300.ms,
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
              child: AppPreviewFrame(
                lightAssetPath: widget.lightAssetPaths[i],
                darkAssetPath: widget.darkAssetPaths[i],
              ),
            ),
        ],
      ),
    );
  }
}

class AppPreviewFrame extends StatefulWidget {
  final String lightAssetPath;
  final String darkAssetPath;

  const AppPreviewFrame({
    super.key,
    required this.lightAssetPath,
    required this.darkAssetPath,
  });

  @override
  State<AppPreviewFrame> createState() => _AppPreviewFrameState();
}

class _AppPreviewFrameState extends State<AppPreviewFrame> {
  late final bool _isDark;

  @override
  void didChangeDependencies() {
    // AppColors must be depended on here rather than in the build method. This
    // is because if dependOnInheritedWidgetOfExactType is called in the build
    // method, when the screen changes whether it is in the wide layout or not,
    // its context becomes stale and using a stale build context is unsafe and
    // throws an error. didChangeDependencies fires when the context becomes
    // stale and dependOnInheritedWidgetOfExactType is called in its body.
    setState(() => _isDark = AppColors.of(context).isDark);
    super.didChangeDependencies();
  }
  Widget _imageFrameBuilder(
    BuildContext context,
    Widget child,
    int? frame,
    bool? wasSynchronouslyLoaded,
  ) {
    if (frame != null) return child;

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        // The exact aspect ratio of the media showcase images
        height: constraints.maxWidth * 2.164,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Hero(
      tag: widget.lightAssetPath,
      // No clue why this is required, but it prevents jumps in the rounded
      // clipping around images.
      // See https://github.com/flutter/flutter/issues/100903/
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      child: PhoneFrame(
        child: Image.asset(
          widget.lightAssetPath,
          frameBuilder: _imageFrameBuilder,
        )
            .animate(
              target: _isDark ? 1 : 0,
              onInit: (controller) =>
                  controller.value = _isDark ? 1 : 0,
            )
            .crossfade(
              builder: (_) => Image.asset(
                widget.darkAssetPath,
                frameBuilder: _imageFrameBuilder,
              ),
            ),
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).push(HeroDialogRoute(
        child: _FullScreenPreview(child: child),
      )),
      child: child,
    );
  }
}

class _FullScreenPreview extends StatelessWidget {
  final Widget child;

  const _FullScreenPreview({required this.child});

  @override
  Widget build(BuildContext context) {
    final closeButton = ResponsiveButton(
      onClicked: Navigator.of(context).pop,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.of(context).container,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close_rounded,
          color: AppColors.of(context).onContainer,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: constraints.maxHeight * 0.05,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: context.isWideLayout()
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              if (context.isWideLayout())
                closeButton,
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                  child: child,
                ),
              ),
              if (!context.isWideLayout())
                ...[
                  const SizedBox(height: 20),
                  closeButton,
                ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A dialog route that mimics showDialog when pushed. This is required since
/// showDialog does not support [Hero].
class HeroDialogRoute<T> extends PageRoute<T> {
  final Widget child;

  HeroDialogRoute({required this.child}) : super();

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => 'Full screen app preview';

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }
}
