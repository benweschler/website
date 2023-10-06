import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final double _frameBorderRadius = 22;
  final double _frameThickness = 3;

  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Add a background color so that transparent children, such as children
        // that are cross fading, are backed by the proper color to prevent a
        // transparent hole behind the content.
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(_frameBorderRadius)),
        border: Border.all(
          color: DefaultTextStyle.of(context).style.color!,
          width: _frameThickness,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(_frameBorderRadius - _frameThickness),
        ),
        child: child,
      ),
    );
  }
}
