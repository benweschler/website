import 'package:flutter/material.dart';
import 'package:website/widgets/app_preview_page.dart';
import 'package:website/widgets/tag_chip.dart';

class SportVuePage extends StatelessWidget {
  const SportVuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPreviewPage(
      lightAssetPaths: [
        'assets/showcase-media/sportvue/light/dashboard-light.jpg',
        'assets/showcase-media/sportvue/light/session-data-light.jpg',
        'assets/showcase-media/sportvue/light/login-light.jpg',
        'assets/showcase-media/sportvue/light/calendar-light.jpg',
        'assets/showcase-media/sportvue/light/trends-light.jpg',
        'assets/showcase-media/sportvue/light/no-data-light.jpg',
        'assets/showcase-media/sportvue/light/profile-light.jpg',
      ],
      darkAssetPaths: [
        'assets/showcase-media/sportvue/dark/dashboard-dark.jpg',
        'assets/showcase-media/sportvue/dark/session-data-dark.jpg',
        'assets/showcase-media/sportvue/dark/login-dark.jpg',
        'assets/showcase-media/sportvue/dark/calendar-dark.jpg',
        'assets/showcase-media/sportvue/dark/trends-dark.jpg',
        'assets/showcase-media/sportvue/dark/no-data-dark.jpg',
        'assets/showcase-media/sportvue/dark/profile-dark.jpg',
      ],
      phoneFrameSizeMultipliers: [
        0.18733774497866676,
        0.09376676727551374,
        0.10034349543461248,
        0.1778201150198227,
        0.10986685597364959,
        0.07033322353229098,
        0.1191127705251509,
      ],
      title: 'SportVue Mobile App',
      tagChips: [
        TagChip(label: 'Flutter'),
        TagChip(label: 'Firebase'),
        TagChip(label: 'Bluetooth Low Energy'),
      ],
      description: 'Making sports safer and training more effective. Integrates with custom wearable hardware over Bluetooth to track athlete performance metrics. Prevents injury through in-game feedback and supercharges training with targeted recommendations and advanced analysis — with everything shared in real time with each player\'s coach.',
      bottomContent: Text(
        'The SportVue mobile app is not open-source.',
        style: TextStyle(fontSize: 12, letterSpacing: 1),
      ),
    );
  }
}
