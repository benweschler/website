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
    final contentColor = AppColors.of(context).onContainer;

    return DefaultTextStyle(
      style: TextStyle(color: contentColor),
      child: _SizeAwareBackgroundWrapper(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                              color: AppColors.of(context).onContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: _buildEmailButton(contentColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: _buildGithubButton(contentColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: _buildDevpostButton(contentColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: _buildShadertoyButton(contentColor),
                    ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeButton() {
    return ResponsiveButton(
      onClicked: _downloadResume,
      child: const Text(
        'Download Resumé',
        style: TextStyle(
          fontSize: 48,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildEmailButton(Color color) {
    return ResponsiveButton(
      onClicked: () => Clipboard.setData(
        const ClipboardData(text: 'benjaminweschler@gmail.com'),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.email_outlined, size: 48, color: color),
          const SizedBox(width: 20),
          const Text(
            'Copy Email',
            style: TextStyle(
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGithubButton(Color color) {
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
            height: 48,
          ),
          const SizedBox(width: 20),
          const Text(
            'GitHub',
            style: TextStyle(
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevpostButton(Color color) {
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
            height: 48,
          ),
          const SizedBox(width: 20),
          const Text(
            'Devpost',
            style: TextStyle(
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShadertoyButton(Color color) {
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
            height: 48,
          ),
          const SizedBox(width: 20),
          const Text(
            'Shadertoy',
            style: TextStyle(
              fontSize: 48,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'View this website\'s source code ',
          style: TextStyle(fontSize: 16, letterSpacing: 2),
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
  final Widget child;

  const _SizeAwareBackgroundWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width < wideScreenCutoff) {
      return Container(
        color: AppColors.of(context).container,
        width: double.infinity,
        height: double.infinity,
        child: child,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).container,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

