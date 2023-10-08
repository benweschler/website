import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:website/constants.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/http_utils.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/theme_config.dart';
import 'package:website/widgets/icon_switch.dart';
import 'package:website/widgets/responsive_button.dart';

import 'header_messenger.dart';

class GlobalHeader extends StatelessWidget {
  final GlobalKey<HeaderMessengerState> messengerKey;

  const GlobalHeader({super.key, required this.messengerKey});

  Color _resolveHeaderColor(BuildContext context) {
    double navigatorPage = context
        .select<RootPageController, double>((controller) => controller.page);
    navigatorPage = clampDouble(navigatorPage, 0, 1);
    return Color.lerp(
        Colors.white, AppColors.of(context).onBackground, navigatorPage)!;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedHeaderColor = _resolveHeaderColor(context);
    return Theme(
      data: AppColors.of(context)
          .copyWith(
            onBackground: resolvedHeaderColor,
            transparentContainer: resolvedHeaderColor.withOpacity(0.15),
          )
          .toThemeData(),
      child: Builder(
        builder: (context) {
          return DefaultTextStyle.merge(
            style: TextStyle(color: AppColors.of(context).onBackground),
            child: IconTheme.merge(
              data: IconThemeData(color: AppColors.of(context).onBackground),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _HeaderButtons(emailPopupKey: messengerKey),
                  const SizedBox(height: 15),
                  HeaderMessenger(messengerKey: messengerKey),
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
  final GlobalKey<HeaderMessengerState> emailPopupKey;

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
        /*
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
              AppColors.of(context).onBackground,
              BlendMode.srcIn,
            ),
            child: Image.asset(
              'assets/github-invertocat-logo.png',
              height: 22,
            ),
          ),
        ),
         */
        //TODO: implement about button
        ResponsiveButton(
          onClicked: () {},
          child: const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 30),
        Consumer<ThemeConfig>(
          builder: (_, themeConfig, __) => IconSwitch(
            onSwitch: themeConfig.toggleTheme,
            animationTarget: themeConfig.themeType == ThemeType.dark ? 0 : 1,
            color: AppColors.of(context).onBackground,
            firstIcon: Icons.dark_mode_rounded,
            secondIcon: Icons.light_mode_rounded,
            isDisabled: themeConfig.darkModeLocked,
            onDisabledClick: () {
              final appName = darkModeUnsupportedPages[context.currentPage()];
              emailPopupKey.currentState!
                  .showPopup("$appName doesn't have dark mode");
            },
          ),
        ),
      ],
    );
  }
}
