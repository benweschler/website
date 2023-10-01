import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import 'animated_gradient_background.dart';
import 'pointer_move_notifier.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final pointerMoveNotifier = PointerMoveNotifier();

  @override
  Widget build(BuildContext context) {
    return InheritedProvider.value(
      value: pointerMoveNotifier,
      child: Listener(
        onPointerMove: (event) {
          if(event.kind != PointerDeviceKind.touch) {
            // For some reason, onPointerMove is triggered at around half the
            // frequency of onPointerHover when moving the pointer the
            // equivalent distance, so trigger two updates to compensate.
            pointerMoveNotifier.notifyMouseUpdate();
            pointerMoveNotifier.notifyMouseUpdate();
          } else {
            pointerMoveNotifier.notifyTouchUpdate();
          }
        },
        onPointerHover: (_) => pointerMoveNotifier.notifyMouseUpdate(),
        child: SizedBox.fromSize(
          size: Size.infinite,
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
            color: Colors.white,
            fontSize: 36,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 15),
        Text(
          "I'm Ben. I'm a software engineer and UI/UX designer in Los Angeles. I love creating delightful and accessible experiences that enrich people's lives.",
          style: TextStyle(
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
