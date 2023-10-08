import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/constants.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/http_utils.dart';
import 'package:website/widgets/responsive_button.dart';

class AboutPopup extends StatelessWidget {
  const AboutPopup({super.key});

  void _downloadResume() async {
    final bytes = await rootBundle.load('assets/resume.pdf');
    downloadFileFromBytes(
      bytes.buffer.asUint8List(),
      'Benjamin Weschler Resume.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideFormat = MediaQuery.of(context).size.width > wideScreenCutoff;
    final Color contentColor = AppColors.of(context).onContainer;
    final double largeFontSize = isWideFormat ? 48 : 36;

    return DefaultTextStyle(
      style: TextStyle(
        color: contentColor,
        fontSize: largeFontSize,
        letterSpacing: 2,
      ),
      child: _SizeAwareBackgroundWrapper(
        isWideFormat: isWideFormat,
        child: Stack(
          children: [
            IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWideFormat)
                    _buildCombinedResumeAndCloseButtons(context, contentColor)
                  else
                    ..._buildStackedResumeAndCloseButtons(
                      context,
                      contentColor,
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 36),
                    child: _buildEmailButton(contentColor, largeFontSize),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 36),
                    child: _buildGithubButton(contentColor, largeFontSize),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 36),
                    child: _buildDevpostButton(contentColor, largeFontSize),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: isWideFormat ? 50 : 0,
                    ),
                    child: _buildShadertoyButton(contentColor, largeFontSize),
                  ),
                  if (!isWideFormat) const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Created with Flutter, GLSL, and lots of coffee in my Los Angeles apartment.',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  _buildSourceMessage(),
                ]
                    .animate(interval: 75.ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 350.ms,
                      curve: Curves.easeOutCubic,
                    )
                    .fadeIn(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedResumeAndCloseButtons(
      BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: _buildResumeButton()),
          const SizedBox(width: 10),
          ResponsiveButton(
            onClicked: Navigator.of(context).pop,
            child: Icon(
              Icons.close_rounded,
              size: 36,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStackedResumeAndCloseButtons(
      BuildContext context, Color color) {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 36),
        child: Align(
          alignment: Alignment.topRight,
          child: ResponsiveButton(
            onClicked: Navigator.of(context).pop,
            child: Icon(
              Icons.close_rounded,
              size: 36,
              color: color,
            ),
          ),
        ),
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 36),
          child: _buildResumeButton(),
        ),
      ),
    ];
  }

  Widget _buildResumeButton() {
    return ResponsiveButton(
      onClicked: _downloadResume,
      child: const Text('Download Resumé'),
    );
  }

  Widget _buildEmailButton(Color color, double size) {
    return ResponsiveButton(
      onClicked: () => Clipboard.setData(
        const ClipboardData(text: 'benjaminweschler@gmail.com'),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.email_outlined, size: size, color: color),
          const SizedBox(width: 20),
          const Flexible(child: Text('Copy Email')),
        ],
      ),
    );
  }

  Widget _buildGithubButton(Color color, double size) {
    return ResponsiveButton(
      onClicked: () => launchUrl(
        Uri.parse('https://www.github.com/benweschler'),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/github-invertocat-logo.png',
            color: color,
            height: size,
          ),
          const SizedBox(width: 20),
          const Text('GitHub'),
        ],
      ),
    );
  }

  Widget _buildDevpostButton(Color color, double size) {
    return ResponsiveButton(
      onClicked: () => launchUrl(
        Uri.parse('https://devpost.com/benjaminweschler'),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/devpost-logo.png',
            color: color,
            height: size,
          ),
          const SizedBox(width: 20),
          const Text('Devpost'),
        ],
      ),
    );
  }

  Widget _buildShadertoyButton(Color color, double size) {
    return ResponsiveButton(
      onClicked: () => launchUrl(
        Uri.parse('https://www.shadertoy.com/user/welches'),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/shadertoy-logo.png',
            color: color,
            height: size,
          ),
          const SizedBox(width: 20),
          const Text('Shadertoy'),
        ],
      ),
    );
  }

  Widget _buildSourceMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Flexible(
          child: Text(
            'View this website\'s source code ',
            style: TextStyle(fontSize: 16, letterSpacing: 2),
          ),
        ),
        ResponsiveButton(
          onClicked: () => launchUrl(
            Uri.parse('https://github.com/benweschler/website'),
          ),
          child: const Text(
            'here',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: 2,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Text(
          '.',
          style: TextStyle(fontSize: 16, letterSpacing: 2),
        ),
      ],
    );
  }
}

class _SizeAwareBackgroundWrapper extends StatelessWidget {
  final bool isWideFormat;
  final Widget child;

  const _SizeAwareBackgroundWrapper({
    required this.isWideFormat,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isWideFormat) {
      return Container(
        padding: const EdgeInsets.all(50),
        decoration: BoxDecoration(
          color: AppColors.of(context).container,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      );
    }

    return Container(
      padding: const EdgeInsets.all(35),
      color: AppColors.of(context).container,
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}
