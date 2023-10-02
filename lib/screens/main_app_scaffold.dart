import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/screens/global_header.dart';
import 'package:website/screens/landing_page/landing_page.dart';

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  final PageController _pageController = PageController();
  bool _isPageAnimating = false;

  void _onScroll(direction) async {
    if (_isPageAnimating) return;

    _isPageAnimating = true;
    if (direction == AxisDirection.up && _pageController.offset != 0) {
      await _pageController.previousPage(
        duration: 1200.ms,
        curve: Curves.easeInOutQuart,
      );
    } else if (direction == AxisDirection.down && _pageController.offset !=
        _pageController.position.maxScrollExtent) {
      await _pageController.nextPage(
        duration: 1200.ms,
        curve: Curves.easeInOutQuart,
      );
    }
    _isPageAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              LandingPage(),
              LandingPage(),
            ]
                .map((page) => ScrollListener(onScroll: _onScroll, child: page))
                .toList(),
          ),
          Positioned(
            top: 30,
            right: 30,
            left: 30,
            child: GlobalHeader(),
          ),
        ],
      ),
    );
  }
}

class ScrollListener extends StatelessWidget {
  final void Function(AxisDirection direciton) onScroll;
  final Widget child;

  const ScrollListener({
    super.key,
    required this.onScroll,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragUpdate: (details) {
        final delta = details.delta.dy;
        final direction = delta > 0 ? AxisDirection.down : AxisDirection.up;
        onScroll(direction);
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (PointerSignalEvent signalEvent) {
          if (signalEvent is! PointerScrollEvent) return;

          final delta = signalEvent.scrollDelta.dy;
          final direction = delta > 0 ? AxisDirection.down : AxisDirection.up;

          onScroll(direction);
        },
        child: child,
      ),
    );
  }
}
