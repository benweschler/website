import 'package:flutter/material.dart';
import 'package:website/utils/iterable_utils.dart';
import 'package:website/widgets/technology_tag_chip.dart';

class SportVuePage extends StatelessWidget {
  const SportVuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SportVue Mobile App',
                  style: TextStyle(
                    fontFamily: 'Libre Baskerville',
                    fontSize: 36,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    const TechnologyTagChip(label: 'Flutter'),
                    const TechnologyTagChip(label: 'Firebase'),
                    const TechnologyTagChip(label: 'Bluetooth Low Energy'),
                  ].separate(const SizedBox(width: 10)).toList(),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Making sports safer and training more effective. Integrates with custom hardware to track athlete performance metrics. Prevents injury through in-game feedback during dangerous movements and supercharges training with targeted recommendations and detailed analysis, shared with each player\'s coach.',
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.25,
                    letterSpacing: 1.33,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
