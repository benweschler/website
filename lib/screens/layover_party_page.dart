import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/rectangular_button.dart';
import 'package:website/widgets/technology_tag_chip.dart';

import '../widgets/app_preview_page.dart';

class LayoverPartyPage extends StatelessWidget {
  const LayoverPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
      pageContent: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Layover Party',
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
                label: 'LA Hacks 2023 Track Winner',
                textColor: Colors.black,
                color: Colors.amberAccent
                    .withOpacity(AppColors.of(context).isDark ? 0.7 : 0.5),
              ),
              const TechnologyTagChip(label: 'Flutter'),
              const TechnologyTagChip(label: 'FastAPI'),
              const TechnologyTagChip(label: 'Swagger'),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Rather than taking a direct flight the next time you travel, find flights with multiple long layovers — which are often cheaper than direct flights — in places you want to visit, allowing you to save money and explore destinations you\'ve always wanted to every time you travel. Exploring is better together, so connect with other travellers who have layovers that overlap with yours.',
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
                    'https://devpost.com/software/layover-party?ref_content=my-projects-tab&ref_feature=my_projects',
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
                  Uri.parse('https://github.com/benweschler/layover-party-app'),
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
        0.06376676727551374,
        0.10034349543461248,
        0.1778201150198227,
        0.10986685597364959,
        0.07033322353229098,
      ],
    );
  }

  final List<String> _assetPaths = const [
    'assets/showcase-media/layover-party/images/onboarding-one.png',
    'assets/showcase-media/layover-party/images/onboarding-two.png',
    'assets/showcase-media/layover-party/images/onboarding-three.png',
    'assets/showcase-media/layover-party/images/trip-ticket.png',
    'assets/showcase-media/layover-party/images/search-bar.png',
    'assets/showcase-media/layover-party/images/trips.png',
  ];
}
