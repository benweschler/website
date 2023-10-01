import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/utils/http_utils.dart';
import 'package:website/widgets/responsive_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  void downloadResume() async {
    final bytes = await rootBundle.load('assets/resume.pdf');
    downloadFileFromBytes(
      bytes.buffer.asUint8List(),
      'Benjamin Weschler Resume.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ResponsiveButton(
          onClicked: downloadResume,
          child: const Text(
            'Resumé',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ResponsiveButton(
          onClicked: () => Clipboard.setData(
            const ClipboardData(text: 'benjaminweschler@gmail.com'),
          ),
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
