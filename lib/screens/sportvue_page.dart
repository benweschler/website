import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/iterable_utils.dart';
import 'package:website/widgets/phone_frame.dart';
import 'package:website/widgets/staggered_parallax_view_delegate.dart';
import 'package:website/widgets/technology_tag_chip.dart';

class SportVuePage extends StatelessWidget {
  // The portion of the total vertical space the mouse is at.
  final _mouseYPositionNotifier = ValueNotifier(0.5);

  SportVuePage({super.key});

  void _updateMousePosition(
    PointerHoverEvent event,
    BoxConstraints constraints,
  ) {
    final newPosition = event.localPosition.dy / constraints.maxHeight;
    _mouseYPositionNotifier.value = newPosition;
  }

  @override
  Widget build(BuildContext context) {
    //TODO: change to stacked layout on mobile
    return LayoutBuilder(
      builder: (context, constraints) => MouseRegion(
        opaque: false,
        hitTestBehavior: HitTestBehavior.translucent,
        onHover: (event) => _updateMousePosition(event, constraints),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth > 1500
                ? (constraints.maxWidth - 1500) / 2
                : 0,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SportVue Mobile App',
                        style: TextStyle(
                          fontFamily: 'Libre Baskerville',
                          fontSize: 36,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          const TechnologyTagChip(label: 'Flutter'),
                          const TechnologyTagChip(label: 'Firebase'),
                          const TechnologyTagChip(
                              label: 'Bluetooth Low Energy'),
                        ].separate(const SizedBox(width: 10)).toList(),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Making sports safer and training more effective. Integrates with custom wearable hardware over Bluetooth to track athlete performance metrics. Prevents injury through in-game feedback and supercharges training with targeted recommendations and advanced analysis — with everything shared in real time with each player\'s coach.',
                        style: TextStyle(
                          fontSize: 24,
                          height: 1.25,
                          letterSpacing: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: ListenableBuilder(
                  listenable: _mouseYPositionNotifier,
                  builder: (_, __) => _ScrollingAppFrames(
                    getAssetPaths: (Brightness brightness) {
                      final isDark = (brightness == Brightness.dark);
                      final themeString = isDark ? 'dark' : 'light';
                      final assetDirectoryPath =
                          'assets/images/sportvue/$themeString/';

                      return [
                        'login-$themeString.png',
                        'no-data-$themeString.png',
                        'dashboard-$themeString.png',
                        'session-data-$themeString.png',
                        'trends-$themeString.png',
                        'calendar-$themeString.png',
                        // TODO: add video support
                        //'data-import-$brightness.mp4',
                        'profile-$themeString.png',
                      ].map((path) => assetDirectoryPath + path).toList();
                    },
                    scrollPosition: _mouseYPositionNotifier.value,
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

class _ScrollingAppFrames extends StatefulWidget {
  final List<String> Function(Brightness brightness) getAssetPaths;
  final double scrollPosition;

  const _ScrollingAppFrames({
    required this.scrollPosition,
    required this.getAssetPaths,
  });

  @override
  State<_ScrollingAppFrames> createState() => _ScrollingAppFramesState();
}

class _ScrollingAppFramesState extends State<_ScrollingAppFrames>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didUpdateWidget(covariant _ScrollingAppFrames oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.scrollPosition,
      curve: Curves.easeOutQuart,
      duration: 600.ms,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightPaths = widget.getAssetPaths(Brightness.light);
    final darkPaths = widget.getAssetPaths(Brightness.dark);

    return RepaintBoundary(
      child: CustomMultiChildLayout(
        delegate: StaggeredParallaxViewDelegate(
          positionAnimation: _controller,
          length: lightPaths.length,
          sizeMultipliers: [
            0.18733774497866676,
            0.06376676727551374,
            0.10034349543461248,
            0.1778201150198227,
            0.10986685597364959,
            0.07033322353229098,
            0.1191127705251509,
          ],
        ),
        // Reverse the list to ensure that children appearing first in the
        // scrolling list are painted on top of the children appearing later.
        children: [
          for (int i = lightPaths.length - 1; i >= 0; i--)
            LayoutId(
              id: i,
              child: PhoneFrame(
                child: Image.asset(lightPaths[i])
                    .animate(
                      target: AppColors.of(context).isDark ? 1 : 0,
                      onInit: (controller) => controller.value =
                          AppColors.of(context).isDark ? 1 : 0,
                    )
                    .crossfade(
                      builder: (_) => Image.asset(darkPaths[i]),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
