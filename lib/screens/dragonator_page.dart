import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/app_preview_page.dart';
import 'package:website/widgets/rectangular_button.dart';
import 'package:website/widgets/technology_tag_chip.dart';

class DragonatorPage extends StatelessWidget {
  const DragonatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
      lightAssetPaths: const [
        'assets/showcase-media/dragonator/light/create-paddler-light.png',
        'assets/showcase-media/dragonator/light/roster-light.png',
        'assets/showcase-media/dragonator/light/edit-lineup-light.png',
        'assets/showcase-media/dragonator/light/paddler-details-light.png',
        'assets/showcase-media/dragonator/light/settings-light.png',
      ],
      darkAssetPaths: const [
        'assets/showcase-media/dragonator/dark/create-paddler-dark.png',
        'assets/showcase-media/dragonator/dark/roster-dark.png',
        'assets/showcase-media/dragonator/dark/edit-lineup-dark.png',
        'assets/showcase-media/dragonator/dark/paddler-details-dark.png',
        'assets/showcase-media/dragonator/dark/settings-dark.png',
      ],
      phoneFrameSizeMultipliers: const [
        0.18733774497866676,
        0.06376676727551374,
        0.10034349543461248,
        0.1778201150198227,
        0.10986685597364959,
      ],
      title: 'Dragonator',
      tagChips: const [
        TechnologyTagChip(
          label: 'Under Development',
          textColor: Colors.white,
          // This is the Dragonator theme red
          color: Color(0xFFE55C45),
        ),
        TechnologyTagChip(label: 'Flutter'),
        TechnologyTagChip(label: 'Firebase'),
        TechnologyTagChip(label: 'Google Cloud Functions'),
      ],
      description: 'A Dragonboat team management platform.',
      bottomContent: RectangularButton(
        onClicked: () => launchUrl(
          Uri.parse('https://github.com/benweschler/dragonator'),
        ),
        backgroundColor:
        AppColors.of(context).isDark ? Colors.white : Colors.black,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/github-invertocat-logo.png',
              color: AppColors.of(context).isDark
                  ? Colors.black
                  : Colors.white,
              height: 22,
            ),
            const SizedBox(width: 10),
            Text(
              'GitHub',
              style: TextStyle(
                color: AppColors.of(context).isDark
                    ? Colors.black
                    : Colors.white,
                fontSize: 20,
                height: 1.25,
                letterSpacing: 1.33,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
