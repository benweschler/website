import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/style/theme.dart';

class HeaderMessenger extends StatefulWidget {
  const HeaderMessenger({
    required GlobalKey<HeaderMessengerState> messengerKey,
  }) : super(key: messengerKey);

  @override
  State<HeaderMessenger> createState() => HeaderMessengerState();
}

class HeaderMessengerState extends State<HeaderMessenger> {
  final _animationSegmentDuration = 250.ms;
  bool _visible = false;
  String message = '';

  void showPopup(String message) async {
    // Hide the current message and wait for the animation to complete.
    if (_visible) {
      setState(() => _visible = false);
      await Future.delayed(
        (2 * _animationSegmentDuration.inMilliseconds + 100).ms,
      );
    }

    this.message = message;
    setState(() => _visible = true);
    await Future.delayed(4000.ms);
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.of(context).transparentContainer,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          )
              .animate(target: _visible ? 1 : 0)
              .visibility(duration: _animationSegmentDuration)
              .then(duration: _animationSegmentDuration),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Animate(target: _visible ? 1 : 0)
                        .custom(
                      duration: _animationSegmentDuration,
                      begin: 1,
                      end: 0,
                      curve: Curves.fastEaseInToSlowEaseOut,
                      builder: (_, value, __) => SizedBox(
                        width: constraints.maxWidth * value,
                      ),
                    )
                        .then(duration: _animationSegmentDuration),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.of(context).onBackground,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Animate(target: _visible ? 1 : 0).custom(
                      delay: _animationSegmentDuration,
                      duration: _animationSegmentDuration,
                      begin: 0,
                      end: 1,
                      curve: Curves.fastEaseInToSlowEaseOut,
                      builder: (_, value, __) => SizedBox(
                        width: constraints.maxWidth * value,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
