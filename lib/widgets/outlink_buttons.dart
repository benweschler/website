import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/rectangular_button.dart';

class GithubRepoButton extends StatelessWidget {
  final String repoName;

  const GithubRepoButton({super.key, required this.repoName});

  @override
  Widget build(BuildContext context) {
    return RectangularButton(
      onClicked: () => launchUrl(
        Uri.parse('https://github.com/benweschler/$repoName'),
      ),
      backgroundColor: AppColors.of(context).container,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/github-invertocat-logo.png',
            color: AppColors.of(context).onContainer,
            height: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'GitHub',
            style: TextStyle(
              color: AppColors.of(context).onContainer,
              fontSize: 20,
              height: 1.25,
              letterSpacing: 1.33,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DevpostButton extends StatelessWidget {
  final String projectName;

  const DevpostButton({super.key, required this.projectName});

  @override
  Widget build(BuildContext context) {
    return RectangularButton(
      onClicked: () => launchUrl(
        Uri.parse('https://devpost.com/software/$projectName'),
      ),
      backgroundColor: AppColors.of(context).container,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/devpost-logo.png',
            color: AppColors.of(context).onContainer,
            height: 22,
          ),
          const SizedBox(width: 10),
          Text(
            'Devpost',
            style: TextStyle(
              color: AppColors.of(context).onContainer,
              fontSize: 20,
              height: 1.25,
              letterSpacing: 1.33,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
