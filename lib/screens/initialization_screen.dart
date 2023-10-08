import 'dart:html';

import 'package:flutter/material.dart';
import 'package:website/constants.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/linear_loading_indicator.dart';

class InitializationScreen extends StatelessWidget {
  final int loadingPercentage;

  const InitializationScreen({super.key, required this.loadingPercentage});

  @override
  Widget build(BuildContext context) {
    final showWorksOnMobilePrompt = !(MediaQuery
        .of(context)
        .size
        .width <= wideScreenCutoff) && !_isMobileBrowser();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Loading',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  letterSpacing: 1.33,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: LinearLoadingIndicator(
                progress: loadingPercentage / 100,
                color:
                AppColors
                    .of(context)
                    .isDark ? Colors.white : Colors.black,
              ),
            ),
            /*
            if (showWorksOnMobilePrompt)
              const Text(
                'This webapp also works on mobile',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.25,
                  letterSpacing: 1.33,
                ),
              )

             */
          ],
        ),
      ),
    );
  }
}

bool _isMobileBrowser() {
  final userAgent = window.navigator.userAgent;
  return userAgent.contains('Mobile') ||
      userAgent.contains('Tablet') ||
      userAgent.contains('Android') ||
      userAgent.contains('iOS');
}
