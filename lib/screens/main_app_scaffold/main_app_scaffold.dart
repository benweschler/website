import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/constants.dart';
import 'package:website/screens/allynd_page.dart';
import 'package:website/screens/dragonator_page.dart';
import 'package:website/screens/layover_party_page.dart';
import 'package:website/screens/main_app_scaffold/global_header.dart';
import 'package:website/screens/landing_page/landing_page.dart';
import 'package:website/screens/sportvue_page.dart';
import 'package:website/style/theme.dart';
import 'package:website/theme_config.dart';
import 'package:website/utils/layout_utils.dart';
import 'package:website/utils/maintain_state.dart';
import 'package:website/utils/navigation_utils.dart';

import 'header_messenger.dart';

typedef ScrollCallback = void Function(AxisDirection);

class MainAppScaffold extends StatefulWidget {
  const MainAppScaffold({super.key});

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  final _headerMessengerKey = GlobalKey<HeaderMessengerState>();
  late final RootPageController _pageController = RootPageController(
    length: _appPages.length,
  )..addScrollListener(_updateDarkModeLock);
  bool _isAnimatingFromScroll = false;

  final _appPages = [
    const LandingPage(),
    const SportVuePage(),
    const DragonatorPage(),
    const LayoverPartyPage(),
    const AllyndPage(),
  ];

  void _onScroll(AxisDirection direction) async {
    // If the page controller is between pages
    if (_isAnimatingFromScroll) return;

    // App preview pages handle their own scrolling in mobile layout.
    if (!context.isWideLayout() && _pageController.page > 0) return;

    _isAnimatingFromScroll = true;
    if (direction == AxisDirection.up && _pageController.offset != 0) {
      await _pageController.previousPage();
    } else if (direction == AxisDirection.down &&
        _pageController.offset != _pageController.position.maxScrollExtent) {
      await _pageController.nextPage();
    }

    // Debounce
    await Future.delayed(const Duration(milliseconds: 500));
    _isAnimatingFromScroll = false;
  }

  void _updateDarkModeLock(int nextPage) {
    if (darkModeUnsupportedPages.containsKey(nextPage)) {
      final themeConfig = context.read<ThemeConfig>();
      if (themeConfig.themeType == ThemeType.dark) {
        final appName = darkModeUnsupportedPages[nextPage];
        _headerMessengerKey.currentState!
            .showPopup('$appName doesn\'t have dark mode');
      }

      themeConfig.lockDarkMode();
    } else {
      context.read<ThemeConfig>().unlockDarkMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double headerPadding = context.isWideLayout() ? 45 : 30;

    return ChangeNotifierProvider.value(
      value: _pageController,
      child: Scaffold(
        body: Stack(
          children: [
            _PageScrollListener(
              onScroll: _onScroll,
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: _appPages.map((page) {
                  // Add maintain state for now so that expensive pages with lots
                  // of images aren't rebuilt everytime they are navigated to.
                  return MaintainState(child: Page(child: page));
                }).toList(),
              ),
            ),
            Positioned(
              top: headerPadding,
              right: headerPadding,
              left: headerPadding,
              child: GlobalHeader(messengerKey: _headerMessengerKey),
            ),
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget {
  final Widget child;

  const Page({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (context.isWideLayout()) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: child,
        ),
      );
    }

    return child;
  }
}

class _PageScrollListener extends StatelessWidget {
  final void Function(AxisDirection direciton) onScroll;
  final Widget child;

  const _PageScrollListener({
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

        // Ignore small swipes for app scrolling
        if (delta.abs() < 20) return;

        // This is opposite to what is intuitive since up -> previous. On mobile
        // if you drag up you want to scroll down.
        final direction = delta > 0 ? AxisDirection.up : AxisDirection.down;
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
