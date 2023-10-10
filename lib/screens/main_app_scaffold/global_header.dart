import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:website/constants.dart';
import 'package:website/screens/main_app_scaffold/about_popup.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/theme_config.dart';
import 'package:website/widgets/icon_switch.dart';
import 'package:website/widgets/responsive_button.dart';

import 'header_messenger.dart';

class GlobalHeader extends StatelessWidget {
  final GlobalKey<HeaderMessengerState> messengerKey;

  const GlobalHeader({super.key, required this.messengerKey});

  Color _resolveHeaderColor(BuildContext context) {
    double navigatorPage = context.select<RootPageController, double>(
        (controller) => clampDouble(controller.page, 0, 1));
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
                  _HeaderButtons(headerMessengerKey: messengerKey),
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
  final GlobalKey<HeaderMessengerState> headerMessengerKey;

  const _HeaderButtons({required this.headerMessengerKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ResponsiveButton(
          onClicked: () => context.goTo(0),
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
          onClicked: () => showGeneralDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.25),
            pageBuilder: (_, __, ___) => const Center(child: AboutPopup()),
          ),
          child: const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (MediaQuery.of(context).size.width > wideScreenCutoff)
          const SizedBox(width: 30)
        else
          const SizedBox(width: 15),
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
              if(appName == null) return;
              headerMessengerKey.currentState!
                  .showPopup('$appName doesn\'t have dark mode');
            },
          ),
        ),
      ],
    );
  }
}
