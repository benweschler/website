import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/app_preview_page.dart';
import 'package:website/widgets/rectangular_button.dart';
import 'package:website/widgets/technology_tag_chip.dart';

class AllyndPage extends StatelessWidget {
  const AllyndPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
      pageContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Allynd',
            style: TextStyle(
              fontFamily: 'Libre Baskerville',
              fontSize: 36,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              TechnologyTagChip(
                label: 'QWER Hacks 2023',
                textColor: AppColors.of(context).isDark ? Colors.black : Colors.white,
                color: AppColors.of(context).isDark ? Colors.white : Colors.black,
              ),
              const TechnologyTagChip(label: 'Flutter'),
              const TechnologyTagChip(label: 'Firebase'),
              const TechnologyTagChip(label: 'Google Maps Platform'),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Supporting people in the queer community who are forced to travel long distances in order to access gender-affirming healthcare, often due to legal restrictions. Find a medical center that offers the care you need, and then securely connect with people in the community near your clinic who are volunteering their home as temporary housing.',
            style: TextStyle(
              fontSize: 24,
              height: 1.25,
              letterSpacing: 1.33,
            ),
          ),
          const SizedBox(height: 50),
          Row(
            children: [
              RectangularButton(
                onClicked: () => launchUrl(
                  Uri.parse(
                    'https://devpost.com/software/allynd',
                  ),
                ),
                backgroundColor:
                AppColors.of(context).isDark ? Colors.white : Colors.black,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/devpost-logo.png',
                      color: AppColors.of(context).isDark
                          ? Colors.black
                          : Colors.white,
                      height: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Devpost',
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
              const SizedBox(width: 20),
              RectangularButton(
                onClicked: () => launchUrl(
                  Uri.parse('https://github.com/benweschler/allyned'),
                ),
                backgroundColor:
                AppColors.of(context).isDark ? Colors.white : Colors.black,
                child: Row(
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
            ],
          ),
        ],
      ),
      lightAssetPaths: _assetPaths,
      darkAssetPaths: _assetPaths,
      phoneFrameSizeMultipliers: const [
        0.18733774497866676,
        0.1778201150198227,
        0.10034349543461248,
        0.06376676727551374,
      ],
    );
  }

  final List<String> _assetPaths = const [
    'assets/showcase-media/allynd/login.png',
    'assets/showcase-media/allynd/onboarding-one.png',
    'assets/showcase-media/allynd/onboarding-two.png',
    'assets/showcase-media/allynd/onboarding-three.png',
  ];
}
