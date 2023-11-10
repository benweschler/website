import 'package:flutter/material.dart';
import 'package:website/utils/layout_utils.dart';
import 'package:website/widgets/buttons/responsive_button.dart';

class FullScreenAppPreview extends StatelessWidget {
  final Widget child;

  const FullScreenAppPreview({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final closeButton = ResponsiveButton(
      onClicked: Navigator.of(context).pop,
      child: const Material(
        color: Colors.white,
        // Adding a shadow increases visibility in light mode, when both the
        // button and background are white.
        elevation: 15,
        shape: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.close_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.symmetric(
          vertical:
          constraints.maxHeight * (context.isWideLayout() ? 0.05 : 0.03),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: context.isWideLayout()
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            children: [
              if (context.isWideLayout()) closeButton,
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 50,
                  ),
                  child: child,
                ),
              ),
              if (!context.isWideLayout()) ...[
                const SizedBox(height: 10),
                closeButton,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
