import 'package:flutter/material.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/app_preview_page.dart';
import 'package:website/widgets/buttons/outlink_buttons.dart';
import 'package:website/widgets/tag_chip.dart';

const List<String> _assetPaths = [
  'assets/showcase-media/layover-party/onboarding-one.jpg',
  'assets/showcase-media/layover-party/onboarding-two.jpg',
  'assets/showcase-media/layover-party/onboarding-three.jpg',
  'assets/showcase-media/layover-party/trip-ticket.jpg',
  'assets/showcase-media/layover-party/search-bar.jpg',
  'assets/showcase-media/layover-party/trips.jpg',
];

class LayoverPartyPage extends StatelessWidget {
  const LayoverPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
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
      title: 'Layover Party',
      tagChips: [
        TagChip(
          label: 'LA Hacks 2023 Track Winner',
          textColor: AppColors.of(context).onContainer,
          color: AppColors.of(context).onBackground,
        ),
        const TagChip(label: 'Flutter'),
        const TagChip(label: 'FastAPI'),
        const TagChip(label: 'Swagger'),
        const TagChip(label: 'Python'),
      ],
      description:
          'Rather than taking a direct flight the next time you travel, find flights with multiple long layovers — which are often cheaper than direct flights — in places you want to visit, allowing you to save money and explore destinations you\'ve always wanted to see every time you travel. Exploring is better together, so connect with other travellers who have layovers that overlap with yours.',
      bottomContent: const Row(
        children: [
          DevpostButton(projectName: 'layover-party'),
          SizedBox(width: 20),
          GithubRepoButton(repoName: 'layover-party-app'),
        ],
      ),
    );
  }
}
