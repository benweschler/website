import 'package:flutter/material.dart';

import 'app_preview_page.dart';

class LayoverPartyPage extends StatelessWidget {
  const LayoverPartyPage({super.key});

  List<String> _getAssetPaths(Brightness brightness) {
    final isDark = (brightness == Brightness.dark);
    final themeString = isDark ? 'dark' : 'light';
    final assetDirectoryPath =
        'assets/images/sportvue/$themeString/';

    return [
      'login-$themeString.png',
      'no-data-$themeString.png',
      'dashboard-$themeString.png',
      'session-data-$themeString.png',
      'trends-$themeString.png',
      'calendar-$themeString.png',
      'profile-$themeString.png',
    ].map((path) => assetDirectoryPath + path).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
      textColumn: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layover Party',
            style: TextStyle(
              fontFamily: 'Libre Baskerville',
              color: Colors.white,
              fontSize: 36,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      lightAssetPaths: _getAssetPaths(Brightness.light),
      darkAssetPaths: _getAssetPaths(Brightness.light),
      phoneFrameSizeMultipliers: const [
        0.18733774497866676,
        0.06376676727551374,
        0.10034349543461248,
        0.1778201150198227,
        0.10986685597364959,
        0.07033322353229098,
        0.1191127705251509,
      ],
    );
  }
}
