import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IconSwitch extends StatelessWidget {
  final VoidCallback onSwitch;
  final double animationTarget;
  final Color color;
  final IconData firstIcon;
  final IconData secondIcon;
  final bool isDisabled;
  final VoidCallback? onDisabledClick;

  const IconSwitch({
    super.key,
    required this.onSwitch,
    required this.animationTarget,
    required this.color,
    required this.firstIcon,
    required this.secondIcon,
    this.isDisabled = false,
    this.onDisabledClick,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isDisabled ? onDisabledClick : onSwitch,
        child: Container(
          decoration: ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(color: color),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(firstIcon, size: 17),
                      const SizedBox(width: 15),
                      Icon(secondIcon, size: 17),
                    ],
                  ),
                  Positioned.fill(
                    child: RepaintBoundary(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ).animate(target: animationTarget).custom(
                            begin: -1,
                            end: 1,
                            curve: Curves.easeInOut,
                            duration: 150.ms,
                            builder: (_, value, child) => Align(
                              alignment: Alignment(value, 0),
                              child: child,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            .animate(target: isDisabled ? 0.25 : 1)
            .fade(curve: Curves.easeOut),
      ),
    );
  }
}
