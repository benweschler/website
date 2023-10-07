import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// An animated linear loading indicator with accompanying percentage text.
///
/// Implemented using [CustomMultiChildLayout] and so must be given a size.
class LinearLoadingIndicator extends StatefulWidget {
  /// A float between 0 and 1 representing the loading percentage.
  final double progress;
  final Color color;

  const LinearLoadingIndicator({
    super.key,
    required this.progress,
    required this.color,
  }) : assert(0 <= progress && progress <= 1,
            'Progress must be between 0 and 1: progress = $progress');

  @override
  State<LinearLoadingIndicator> createState() => _LinearLoadingIndicatorState();
}

class _LinearLoadingIndicatorState extends State<LinearLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: 2000.ms);

  @override
  void didUpdateWidget(LinearLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.progress != oldWidget.progress) {
      _controller.animateTo(widget.progress, curve: Curves.easeOut);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _LoadingIndicatorLayoutDelegate(),
      children: [
        LayoutId(
          id: 'loading-indicator',
          child: Container(
            width: 200,
            height: 6,
            decoration: ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(color: widget.color),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) => Container(
                    color: widget.color,
                    width: constraints.maxWidth * _controller.value,
                  ),
                ),
              ),
            ),
          ),
        ),
        LayoutId(
          id: 'loading-percentage',
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Text(
              '${(_controller.value * 100).ceil()}%',
              style: const TextStyle(
                fontSize: 16,
                height: 1.25,
                letterSpacing: 1.33,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingIndicatorLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final loadingIndicatorSize =
        layoutChild('loading-indicator', const BoxConstraints());
    positionChild(
      'loading-indicator',
      Offset(
        size.width / 2 - loadingIndicatorSize.width / 2,
        -1 * loadingIndicatorSize.height / 2,
      ),
    );

    final textSize = layoutChild('loading-percentage', const BoxConstraints());
    positionChild(
      'loading-percentage',
      Offset(
        size.width / 2 + loadingIndicatorSize.width / 2 + 15,
        -1 * textSize.height / 2,
      ),
    );
  }

  @override
  bool shouldRelayout(_LoadingIndicatorLayoutDelegate oldDelegate) => false;
}
