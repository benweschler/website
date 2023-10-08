import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/screens/layover_party_page.dart';
import 'package:website/screens/main_app_scaffold/global_header.dart';
import 'package:website/screens/landing_page/landing_page.dart';
import 'package:website/screens/sportvue_page.dart';
import 'package:website/utils/maintain_state.dart';
import 'package:website/utils/navigation_utils.dart';

typedef ScrollCallback = void Function(AxisDirection);

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  final RootPageController _pageController = RootPageController();
  bool _isPageAnimating = false;

  void _onScroll(direction) async {
    if (_isPageAnimating) return;

    _isPageAnimating = true;
    if (direction == AxisDirection.up && _pageController.offset != 0) {
      await _pageController.previousPage();
    } else if (direction == AxisDirection.down &&
        _pageController.offset != _pageController.position.maxScrollExtent) {
      await _pageController.nextPage();
    }

    _isPageAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _pageController,
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const LandingPage(),
                const SportVuePage(),
                const LayoverPartyPage(),
              ].map((page) {
                // Add maintain state for now so that expensive pages with lots
                // of images aren't rebuilt everytime they are navigated to.
                return MaintainState(
                  child: Page(onScroll: _onScroll, child: page),
                );
              }).toList(),
            ),
            Positioned(
              top: 45,
              right: 45,
              left: 45,
              child: GlobalHeader(),
            ),
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final ScrollCallback onScroll;
  final Widget child;

  const Page({super.key, required this.onScroll, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScrollListener(
      onScroll: onScroll,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: child,
        ),
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
