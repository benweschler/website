import 'package:flutter/widgets.dart';
import 'package:website/style/theme.dart';

class TechnologyTagChip extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const TechnologyTagChip({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: color ??
            AppColors.of(context).transparentContainer.withOpacity(0.15),
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ??
              DefaultTextStyle.of(context).style.color!.withOpacity(0.8),
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}
