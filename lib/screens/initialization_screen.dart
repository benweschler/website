import 'dart:math';

import 'package:flutter/material.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/linear_loading_indicator.dart';

class InitializationScreen extends StatelessWidget {
  final int loadingPercentage;

  const InitializationScreen({super.key, required this.loadingPercentage});

  @override
  Widget build(BuildContext context) {
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
                    AppColors.of(context).isDark ? Colors.white : Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: LayoutBuilder(
                builder: (context, constraints) => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: max(constraints.maxWidth / 3, 500),
                  ),
                  child: const Text(
                    'Due to Safari\'s implementation of WebGL 2.0, use a Chromium browser for best performance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.25,
                      letterSpacing: 1.33,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
