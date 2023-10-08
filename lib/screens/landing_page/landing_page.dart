import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import 'animated_gradient_background.dart';
import 'pointer_move_notifier.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final _pointerMoveNotifier = PointerMoveNotifier();
  late final Ticker _mouseUpdateTicker;
  late final Ticker _touchUpdateTicker;
  // The number of milliseconds for which the background gradient reacts after a
  // pointer update. This means that if the user is getting at least 20fps, they
  // will see at least one reactive frame after a pointer event.
  final _backgroundReactionDuration = (1000/20).ms;

  @override
  void initState() {
    super.initState();
    _mouseUpdateTicker =
        createTicker((_) => _pointerMoveNotifier.notifyMouseUpdate());
    _touchUpdateTicker =
        createTicker((_) => _pointerMoveNotifier.notifyTouchUpdate());
  }

  @override
  void dispose() {
    _mouseUpdateTicker.dispose();
    _touchUpdateTicker.dispose();
    super.dispose();
  }

  void notifyMouseUpdate() async {
    if (!_mouseUpdateTicker.isActive) {
      _mouseUpdateTicker.start();
      await Future.delayed(_backgroundReactionDuration);
      _mouseUpdateTicker.stop();
    }
  }

  void notifyTouchUpdate() async {
    if (!_touchUpdateTicker.isActive) {
      _touchUpdateTicker.start();
      await Future.delayed((1000/5).ms);
      _touchUpdateTicker.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider.value(
      value: _pointerMoveNotifier,
      child: Listener(
        onPointerMove: (event) => event.kind != PointerDeviceKind.touch
            ? notifyMouseUpdate()
            : notifyTouchUpdate(),
        onPointerHover: (_) => notifyMouseUpdate(),
        child: Stack(
          children: [
            const Positioned.fill(child: AnimatedGradientBackground()),
            // Allow the text to fill the available space for small screen
            // sizes and constrain it to a fixed size in the center of the
            // screen for large screen sizes.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 900
                      ? 900
                      : double.infinity,
                  child: _buildTextContent(),
                ),
              ),
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: ScrollPromptText(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey;',
          style: TextStyle(
            fontFamily: 'Libre Baskerville',
            color: Colors.white,
            fontSize: 36,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'I\'m Ben. I\'m a software engineer and UI/UX designer in Los Angeles. I love creating delightful and accessible experiences that enrich people\'s lives.',
          style: TextStyle(
            fontFamily: 'Libre Baskerville',
            color: Colors.white,
            fontSize: 30,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class ScrollPromptText extends StatelessWidget {
  const ScrollPromptText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'See my work',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(width: 5),
        const Icon(Icons.arrow_downward_rounded, color: Colors.white)
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .slideY(
              begin: -0.15,
              end: 0.05,
              duration: 700.ms,
              curve: Curves.easeOut,
            )
            .then(duration: 200.ms)
            .slideY(
              begin: 0.15,
              end: -0.05,
              curve: Curves.easeOut,
              duration: 700.ms,
            )
            .then(duration: 350.ms),
      ],
    );
  }
}
