import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/http_utils.dart';
import 'package:website/utils/theme_config.dart';
import 'package:website/widgets/icon_switch.dart';
import 'package:website/widgets/responsive_button.dart';

// TODO: this is very long and messy but it doesn't matter because it's readable enough and it's GOING AWAY SOON!!.
class UnderConstructionScreen extends StatefulWidget {
  final VoidCallback validateAdmin;

  const UnderConstructionScreen({super.key, required this.validateAdmin});

  @override
  State<UnderConstructionScreen> createState() =>
      _UnderConstructionScreenState();
}

class _UnderConstructionScreenState extends State<UnderConstructionScreen> {
  // HAHA you sneaky sneaker. Checking the source code to try and get in smh...
  // Wait until the site is ready!!! I promise it'll worth the wait.
  // Props for getting here, though :).
  final _magicWordHash =
      'd2a27049b0b146881e0c7bb4e760704ee9689f5c21c3f6279c6529fb66cca8ac';
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _downloadResume() async {
    final bytes = await rootBundle.load('assets/resume.pdf');
    downloadFileFromBytes(
      bytes.buffer.asUint8List(),
      'Benjamin Weschler Resume.pdf',
    );
  }

  void _validate() {
    final inputBytes = utf8.encode(_controller.value.text);
    final inputHash = sha256.convert(inputBytes);
    if (inputHash.toString() == _magicWordHash) {
      widget.validateAdmin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 45, bottom: 15),
                child: Row(
                  children: [
                    const Spacer(),
                    Consumer<ThemeConfig>(
                      builder: (_, themeConfig, __) => IconSwitch(
                        onSwitch: themeConfig.toggleTheme,
                        animationTarget:
                            themeConfig.themeType == ThemeType.dark ? 0 : 1,
                        color: AppColors.of(context).headerColor,
                        firstIcon: Icons.dark_mode_rounded,
                        secondIcon: Icons.light_mode_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 1000
                      ? 1000
                      : double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight / 2,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'This website is under construction and is waiting for DNS propagation and certificate provisioning, but it won\'t be long! Check back in the late afternoon or evening of October 7th.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    height: 1.25,
                                    letterSpacing: 1.33,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                const Text(
                                  'Are you from Nova for Good? Hey!! Thanks for stopping by :). I\'m SO excited to apply and show you what I have here, so PLEASE come back soon and check out my portfolio once everything is up and running — I promise it won\'t be too long. In the meantime, you can check out my GitHub or download my resumé by clicking below.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.25,
                                    letterSpacing: 1.33,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ResponsiveButton(
                                      onClicked: _downloadResume,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color:
                                              AppColors.of(context).headerColor,
                                        ),
                                        child: Text(
                                          'Download Resumé',
                                          style: TextStyle(
                                            color: AppColors.of(context).isDark
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 16,
                                            height: 1.25,
                                            letterSpacing: 1.33,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    ResponsiveButton(
                                      onClicked: () => launchUrl(
                                        Uri.parse(
                                            'https://www.github.com/benweschler'),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color:
                                              AppColors.of(context).headerColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/github-invertocat-logo.png',
                                              color:
                                                  AppColors.of(context).isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                              height: 22,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              'GitHub',
                                              style: TextStyle(
                                                color:
                                                    AppColors.of(context).isDark
                                                        ? Colors.black
                                                        : Colors.white,
                                                fontSize: 16,
                                                height: 1.25,
                                                letterSpacing: 1.33,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight / 2,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Are you Ben and want to get in? What\'s the magic word then...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.25,
                                    letterSpacing: 1.33,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Maybe you can even try to find it in the ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.25,
                                        letterSpacing: 1.33,
                                      ),
                                    ),
                                    ResponsiveButton(
                                      onClicked: () => launchUrl(
                                        Uri.parse(
                                            'https://github.com/benweschler/website/blob/main/lib/screens/under_construction_page.dart'),
                                      ),
                                      child: const Text(
                                        'source code',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.25,
                                          letterSpacing: 1.33,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      '?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.25,
                                        letterSpacing: 1.33,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 500,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _controller,
                                          decoration: const InputDecoration(
                                            hintText: 'Are you magic?',
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      ResponsiveButton(
                                        onClicked: _validate,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            color: AppColors.of(context)
                                                .headerColor,
                                          ),
                                          child: Text(
                                            'Validate',
                                            style: TextStyle(
                                              color:
                                                  AppColors.of(context).isDark
                                                      ? Colors.black
                                                      : Colors.white,
                                              fontSize: 16,
                                              height: 1.25,
                                              letterSpacing: 1.33,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
