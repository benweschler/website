import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/widgets/buttons/responsive_button.dart';

import 'animated_gradient_background.dart';
import 'pointer_move_notifier.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _pointerMoveNotifier = PointerMoveNotifier();
  Timer? _pointerStopTimer;

  void _notifyMouseUpdate() async {
    _pointerStopTimer?.cancel();
    _pointerMoveNotifier.notifyMouseUpdate();
    _resetTimer();
  }

  void _notifyTouchUpdate() async {
    _pointerStopTimer?.cancel();
    _pointerMoveNotifier.notifyTouchUpdate();
    _resetTimer();
  }

  void _resetTimer() {
    _pointerStopTimer = Timer(
      // The number of milliseconds for which the background gradient reacts after a
      // pointer update. This means that if the user is getting at least 20fps, they
      // will see at least one reactive frame after a pointer event.
      (1000 / 20).ms,
      _pointerMoveNotifier.notifyPointerStop,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider.value(
      value: _pointerMoveNotifier,
      child: Listener(
        onPointerMove: (event) => event.kind != PointerDeviceKind.touch
            ? _notifyMouseUpdate()
            : _notifyTouchUpdate(),
        onPointerHover: (_) => _notifyMouseUpdate(),
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
              child: ScrollPrompt(),
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

class ScrollPrompt extends StatelessWidget {
  const ScrollPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onClicked: context.goNext,
      child: Row(
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
      ),
    );
  }
}
