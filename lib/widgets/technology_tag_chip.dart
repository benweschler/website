import 'package:flutter/widgets.dart';
import 'package:website/style/theme.dart';

class TechnologyTagChip extends StatelessWidget {
  final String label;

  const TechnologyTagChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
        color: AppColors.of(context).transparentContainer.withOpacity(0.15),
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: TextStyle(color: DefaultTextStyle.of(context).style.color!.withOpacity(0.8)),
      ),
    );
  }
}
