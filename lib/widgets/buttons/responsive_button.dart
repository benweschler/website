import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResponsiveButton extends StatefulWidget {
  final GestureTapCallback onClicked;
  final Widget child;

  const ResponsiveButton({
    super.key,
    required this.onClicked,
    required this.child,
  });

  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onClicked,
        onTapDown: (_) => setState(() => isHovered = true),
        onTapCancel: () => setState(() => isHovered = false),
        onTapUp: (_) => setState(() => isHovered = false),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: widget.child
              .animate(target: isHovered ? 1 : 0)
              .fade(end: 0.6, duration: 200.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}
