import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/http_utils.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/utils/theme_config.dart';
import 'package:website/widgets/icon_switch.dart';
import 'package:website/widgets/responsive_button.dart';

class GlobalHeader extends StatelessWidget {
  final _emailPopupKey = GlobalKey<_EmailCopiedPopupState>();

  GlobalHeader({super.key});

  Color _resolveHeaderColor(BuildContext context) {
    double navigatorPage = context
        .select<RootPageController, double>((controller) => controller.page);
    navigatorPage = clampDouble(navigatorPage, 0, 1);
    return Color.lerp(
        Colors.white, AppColors.of(context).headerColor, navigatorPage)!;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedHeaderColor = _resolveHeaderColor(context);
    return Theme(
      data: AppColors.of(context)
          .copyWith(
            headerColor: resolvedHeaderColor,
            transparentContainer: resolvedHeaderColor.withOpacity(0.25),
          )
          .toThemeData(),
      child: Builder(
        builder: (context) {
          return DefaultTextStyle.merge(
            style: TextStyle(color: AppColors.of(context).headerColor),
            child: IconTheme.merge(
              data: IconThemeData(color: AppColors.of(context).headerColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _HeaderButtons(emailPopupKey: _emailPopupKey),
                  const SizedBox(height: 15),
                  _EmailCopiedPopup(key: _emailPopupKey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderButtons extends StatelessWidget {
  final GlobalKey<_EmailCopiedPopupState> emailPopupKey;

  const _HeaderButtons({required this.emailPopupKey});

  void _downloadResume() async {
    final bytes = await rootBundle.load('assets/resume.pdf');
    downloadFileFromBytes(
      bytes.buffer.asUint8List(),
      'Benjamin Weschler Resume.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ResponsiveButton(
          onClicked: () => context.jumpTo(0),
          child: const Text(
            'Ben Weschler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Spacer(),
        ResponsiveButton(
          onClicked: _downloadResume,
          child: const Text(
            'Resumé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
            emailPopupKey.currentState!.showPopup();
          },
          child: const Icon(Icons.email_outlined),
        ),
        const SizedBox(width: 20),
        ResponsiveButton(
          onClicked: () => launchUrl(
            Uri.parse('https://www.github.com/benweschler'),
          ),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              AppColors.of(context).headerColor,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/github-invertocat-logo.png',
              height: 22,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Consumer<ThemeConfig>(
          builder: (_, themeConfig, __) => IconSwitch(
            onSwitch: themeConfig.toggleTheme,
            animationTarget: themeConfig.themeType == ThemeType.dark ? 0 : 1,
            color: AppColors.of(context).headerColor,
            firstIcon: Icons.dark_mode_rounded,
            secondIcon: Icons.light_mode_rounded,
          ),
        ),
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.of(context).transparentContainer,
              ),
              child: const Text(
                'Email copied to clipboard',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
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
                        decoration: BoxDecoration(
                          color: AppColors.of(context).headerColor,
                          borderRadius: const BorderRadius.horizontal(
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
