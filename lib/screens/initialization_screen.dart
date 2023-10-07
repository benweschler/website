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
            const Expanded(
              child: Align(
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
            ),
            const SizedBox(height: 15),
            Expanded(
              child: LinearLoadingIndicator(
                progress: loadingPercentage / 100,
                color:
                    AppColors.of(context).isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
