import 'package:flutter/material.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/app_preview_page/app_preview_page.dart';
import 'package:website/widgets/buttons/outlink_buttons.dart';
import 'package:website/widgets/tag_chip.dart';

class AllyndPage extends StatelessWidget {
  const AllyndPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPreviewPage(
      lightAssetPaths: _assetPaths,
      darkAssetPaths: _assetPaths,
      phoneFrameSizeMultipliers: const [
        0.18733774497866676,
        0.09376676727551374,
        0.10034349543461248,
        0.1778201150198227,
      ],
      title: 'Allynd',
      tagChips: [
        TagChip(
          label: 'QWER Hacks 2023',
          textColor: AppColors.of(context).isDark ? Colors.black : Colors.white,
          color: AppColors.of(context).isDark ? Colors.white : Colors.black,
        ),
        const TagChip(label: 'Flutter'),
        const TagChip(label: 'Firebase'),
        const TagChip(label: 'Google Maps Cloud Platform'),
      ],
      description: 'Supporting people in the queer community who are forced to travel long distances in order to access gender-affirming healthcare, often due to legal restrictions. Find a medical center that offers the care you need, and then securely connect with people in the community near your clinic who are volunteering their home as temporary housing.',
      bottomContent: const Row(
        children: [
          DevpostButton(projectName: 'allynd'),
          SizedBox(width: 20),
          GithubRepoButton(repoName: 'allyned'),
        ],
      ),
    );
  }

  final List<String> _assetPaths = const [
    'assets/showcase-media/allynd/login.jpg',
    'assets/showcase-media/allynd/onboarding-one.jpg',
    'assets/showcase-media/allynd/onboarding-two.jpg',
    'assets/showcase-media/allynd/onboarding-three.jpg',
  ];
}
