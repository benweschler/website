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
      pageContent: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SportVue Mobile App',
            style: TextStyle(
              fontFamily: 'Libre Baskerville',
              fontSize: 36,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              TechnologyTagChip(label: 'Flutter'),
              TechnologyTagChip(label: 'Firebase'),
              TechnologyTagChip(label: 'Bluetooth Low Energy'),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Making sports safer and training more effective. Integrates with custom wearable hardware over Bluetooth to track athlete performance metrics. Prevents injury through in-game feedback and supercharges training with targeted recommendations and advanced analysis — with everything shared in real time with each player\'s coach.',
            style: TextStyle(
              fontSize: 24,
              height: 1.25,
              letterSpacing: 1.33,
            ),
          ),
          SizedBox(height: 50),
          Text(
            'SportVue is not open-source.',
            style: TextStyle(fontSize: 12, letterSpacing: 1),
          ),
        ],
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
