import 'package:flutter/widgets.dart';
import 'package:website/widgets/buttons/responsive_button.dart';

class RectangularButton extends StatelessWidget {
  final GestureTapCallback onClicked;
  final Color backgroundColor;
  final Widget child;

  const RectangularButton({
    super.key,
    required this.onClicked,
    required this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveButton(
      onClicked: onClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: backgroundColor,
        ),
        child: child,
      ),
    );
  }
}
