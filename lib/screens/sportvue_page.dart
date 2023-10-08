import 'package:flutter/material.dart';
import 'package:website/widgets/app_preview_page.dart';
import 'package:website/widgets/technology_tag_chip.dart';

class SportVuePage extends StatelessWidget {
  const SportVuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
      lightAssetPaths: _getAssetPaths(Brightness.light),
      darkAssetPaths: _getAssetPaths(Brightness.dark),
      phoneFrameSizeMultipliers: const [
        0.18733774497866676,
        0.06376676727551374,
        0.10034349543461248,
        0.1778201150198227,
        0.10986685597364959,
        0.07033322353229098,
        0.1191127705251509,
      ],
      title: 'SportVue Mobile App',
      tagChips: const [
        TechnologyTagChip(label: 'Flutter'),
        TechnologyTagChip(label: 'Firebase'),
        TechnologyTagChip(label: 'Bluetooth Low Energy'),
      ],
      description: 'Making sports safer and training more effective. Integrates with custom wearable hardware over Bluetooth to track athlete performance metrics. Prevents injury through in-game feedback and supercharges training with targeted recommendations and advanced analysis — with everything shared in real time with each player\'s coach.',
      bottomContent: const Text(
        'The SportVue mobile app is not open-source.',
        style: TextStyle(fontSize: 12, letterSpacing: 1),
      ),
    );
  }

  List<String> _getAssetPaths(Brightness brightness) {
    final isDark = (brightness == Brightness.dark);
    final themeString = isDark ? 'dark' : 'light';
    final assetDirectoryPath = 'assets/showcase-media/sportvue/$themeString/';

    return [
      'login-$themeString.png',
      'no-data-$themeString.png',
      'dashboard-$themeString.png',
      'session-data-$themeString.png',
      'trends-$themeString.png',
      'calendar-$themeString.png',
      // TODO: add video support
      //'data-import-$brightness.mp4',
      'profile-$themeString.png',
    ].map((path) => assetDirectoryPath + path).toList();
  }
}
