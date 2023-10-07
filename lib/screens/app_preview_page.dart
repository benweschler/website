import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/phone_frame.dart';
import 'package:website/widgets/staggered_parallax_view_delegate.dart';

class AppPreviewPage extends StatelessWidget {
  final Widget textColumn;
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;

  AppPreviewPage({
    super.key,
    required this.textColumn,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
  });

// The portion of the total vertical space the mouse is at.
  final _mouseYPositionNotifier = ValueNotifier(0.5);

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
                  child: textColumn,
                ),
              ),
              Expanded(
                flex: 3,
                child: ListenableBuilder(
                  listenable: _mouseYPositionNotifier,
                  builder: (_, __) => _ScrollingAppFrames(
                    lightAssetPaths: lightAssetPaths,
                    darkAssetPaths: darkAssetPaths,
                    scrollPosition: _mouseYPositionNotifier.value,
                    phoneFrameSizeMultipliers: phoneFrameSizeMultipliers,
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
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final double scrollPosition;
  final List<double> phoneFrameSizeMultipliers;

  const _ScrollingAppFrames({
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.scrollPosition,
    required this.phoneFrameSizeMultipliers,
  }) : assert(
          lightAssetPaths.length == darkAssetPaths.length &&
              lightAssetPaths.length == phoneFrameSizeMultipliers.length,
          'The number of light asset paths, dark asset paths, and size multipliers must be equal',
        );

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomMultiChildLayout(
        delegate: StaggeredParallaxViewDelegate(
          positionAnimation: _controller,
          length: widget.lightAssetPaths.length,
          sizeMultipliers: widget.phoneFrameSizeMultipliers,
        ),
        // Reverse the list to ensure that children appearing first in the
        // scrolling list are painted on top of the children appearing later.
        children: [
          for (int i = widget.lightAssetPaths.length - 1; i >= 0; i--)
            LayoutId(
              id: i,
              child: PhoneFrame(
                child: Image.asset(widget.lightAssetPaths[i])
                    .animate(
                      target: AppColors.of(context).isDark ? 1 : 0,
                      onInit: (controller) => controller.value =
                          AppColors.of(context).isDark ? 1 : 0,
                    )
                    .crossfade(
                      builder: (_) => Image.asset(widget.darkAssetPaths[i]),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
