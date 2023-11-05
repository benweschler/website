import 'package:flutter/material.dart';
import 'package:website/widgets/app_preview_page.dart';
import 'package:website/widgets/buttons/outlink_buttons.dart';
import 'package:website/widgets/tag_chip.dart';

class DragonatorPage extends StatelessWidget {
  const DragonatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPreviewPage(
      lightAssetPaths: [
        'assets/showcase-media/dragonator/light/roster-light.jpg',
        'assets/showcase-media/dragonator/light/edit-lineup-light.jpg',
        'assets/showcase-media/dragonator/light/create-paddler-light.jpg',
        'assets/showcase-media/dragonator/light/paddler-details-light.jpg',
        'assets/showcase-media/dragonator/light/settings-light.jpg',
      ],
      darkAssetPaths: [
        'assets/showcase-media/dragonator/dark/roster-dark.jpg',
        'assets/showcase-media/dragonator/dark/edit-lineup-dark.jpg',
        'assets/showcase-media/dragonator/dark/create-paddler-dark.jpg',
        'assets/showcase-media/dragonator/dark/paddler-details-dark.jpg',
        'assets/showcase-media/dragonator/dark/settings-dark.jpg',
      ],
      phoneFrameSizeMultipliers: [
        0.18733774497866676,
        0.06376676727551374,
        0.10034349543461248,
        0.1778201150198227,
        0.10986685597364959,
      ],
      title: 'Dragonator',
      tagChips: [
        TagChip(
          label: 'Under Development',
          textColor: Colors.white,
          // This is the Dragonator theme red
          color: Color(0xFFE55C45),
        ),
        TagChip(label: 'Flutter'),
        TagChip(label: 'Firebase'),
        TagChip(label: 'Google Cloud Functions'),
      ],
      description: 'A Dragonboat team management platform. Track your paddler roster within a division and during races, automatically calculate paddler seating to optimize boat balance and center of gravity, and automate the creation of race heats with hundreds of paddlers. Share anything with your team and collaborate securely with other coaches in real time.',
      bottomContent: GithubRepoButton(repoName: 'dragonator'),
    );
  }
}
