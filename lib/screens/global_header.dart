import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/utils/http_utils.dart';
import 'package:website/widgets/responsive_button.dart';

class GlobalHeader extends StatelessWidget {
  final _emailPopupKey = GlobalKey<_EmailCopiedPopupState>();

  GlobalHeader({super.key});

  void downloadResume() async {
    final bytes = await rootBundle.load('assets/resume.pdf');
    downloadFileFromBytes(
      bytes.buffer.asUint8List(),
      'Benjamin Weschler Resume.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildHeaderButtons(),
        const SizedBox(height: 15),
        _EmailCopiedPopup(key: _emailPopupKey),
      ],
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
      children: [
        ResponsiveButton(
          onClicked: () {},
          child: const Text(
            'Ben Weschler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Spacer(),
        ResponsiveButton(
          onClicked: downloadResume,
          child: const Text(
            'Resumé',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ResponsiveButton(
          onClicked: () {
            Clipboard.setData(
              const ClipboardData(text: 'benjaminweschler@gmail.com'),
            );
            _emailPopupKey.currentState!.showPopup();
          },
          child: const Icon(
            Icons.email_outlined,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 20),
        ResponsiveButton(
          onClicked: () => launchUrl(
            Uri.parse('https://www.github.com/benweschler'),
          ),
          child: Image.asset(
            'images/github-invertocat-logo.png',
            height: 22,
          ),
        )
      ],
    );
  }
}

class _EmailCopiedPopup extends StatefulWidget {
  const _EmailCopiedPopup({super.key});

  @override
  State<_EmailCopiedPopup> createState() => _EmailCopiedPopupState();
}

class _EmailCopiedPopupState extends State<_EmailCopiedPopup> {
  final _animationSegmentDuration = 250.ms;
  bool _visible = false;

  void showPopup() async {
    setState(() => _visible = true);
    await Future.delayed(2500.ms);
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
            ),
            child: const Text(
              'Email copied to clipboard',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          )
              .animate(target: _visible ? 1 : 0)
              .visibility(duration: _animationSegmentDuration)
              .then(duration: _animationSegmentDuration),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Animate(target: _visible ? 1 : 0)
                        .custom(
                          duration: _animationSegmentDuration,
                          begin: 1,
                          end: 0,
                          curve: Curves.fastEaseInToSlowEaseOut,
                          builder: (_, value, __) => SizedBox(
                            width: constraints.maxWidth * value,
                          ),
                        )
                        .then(duration: _animationSegmentDuration),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Animate(target: _visible ? 1 : 0).custom(
                      delay: _animationSegmentDuration,
                      duration: _animationSegmentDuration,
                      begin: 0,
                      end: 1,
                      curve: Curves.fastEaseInToSlowEaseOut,
                      builder: (_, value, __) => SizedBox(
                        width: constraints.maxWidth * value,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
