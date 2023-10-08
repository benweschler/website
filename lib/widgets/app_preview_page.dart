import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/constants.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/navigation_utils.dart';
import 'package:website/widgets/phone_frame.dart';
import 'package:website/widgets/staggered_parallax_view_delegate.dart';
import 'package:website/widgets/tag_chip.dart';

// Make this a stateful widget to store the current mouse position in a state
// variable that is persistent between rebuilds, even though the state is never
// explicitly mutated.
class AppPreviewPage extends StatelessWidget {
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;
  final String title;
  final List<TagChip> tagChips;
  final String description;
  final Widget bottomContent;

  const AppPreviewPage({
    super.key,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
    required this.title,
    required this.tagChips,
    required this.description,
    required this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).size.width < wideScreenCutoff) {
          return _MobileLayout(
            constraints: constraints,
            lightAssetPaths: lightAssetPaths,
            darkAssetPaths: darkAssetPaths,
            phoneFrameSizeMultipliers: phoneFrameSizeMultipliers,
            textContent: _TextContent(
              title: title,
              tagChips: tagChips,
              description: description,
              bottomContent: bottomContent,
            ),
          );
        }

        return _WideLayout(
          constraints: constraints,
          lightAssetPaths: lightAssetPaths,
          darkAssetPaths: darkAssetPaths,
          phoneFrameSizeMultipliers: phoneFrameSizeMultipliers,
          textContent: _TextContent(
            title: title,
            tagChips: tagChips,
            description: description,
            bottomContent: bottomContent,
          ),
        );
      },
    );
  }
}

class _WideLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;
  final Widget textContent;

  const _WideLayout({
    required this.constraints,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
    required this.textContent,
  });

  @override
  State<_WideLayout> createState() => _WideLayoutState();
}

class _WideLayoutState extends State<_WideLayout> {
  // The portion of the total vertical space the mouse is at.
  final _mouseYPositionNotifier = ValueNotifier(0.0);

  void _updateMousePosition(
    PointerHoverEvent event,
    BoxConstraints constraints,
  ) {
    final newPosition = event.localPosition.dy / constraints.maxHeight;
    _mouseYPositionNotifier.value = newPosition;
  }

  @override
  void dispose() {
    _mouseYPositionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      hitTestBehavior: HitTestBehavior.translucent,
      onHover: (event) => _updateMousePosition(event, widget.constraints),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.constraints.maxWidth > 1500
              ? (widget.constraints.maxWidth - 1500) / 2
              : 0,
        ),
        child: Row(
          children: [
            Expanded(flex: 4, child: widget.textContent),
            Expanded(
              flex: 3,
              child: ListenableBuilder(
                listenable: _mouseYPositionNotifier,
                builder: (_, __) => _ScrollingAppFrames(
                  lightAssetPaths: widget.lightAssetPaths,
                  darkAssetPaths: widget.darkAssetPaths,
                  scrollPosition: _mouseYPositionNotifier.value,
                  phoneFrameSizeMultipliers: widget.phoneFrameSizeMultipliers,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final List<double> phoneFrameSizeMultipliers;
  final Widget textContent;

  const _MobileLayout({
    required this.constraints,
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.phoneFrameSizeMultipliers,
    required this.textContent,
  });

  @override
  State<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<_MobileLayout> {
  // Add a small amount to the scroll offset so that if the user scrolls back
  // to the edge the controller notifies listeners and we can detect it.
  final _scrollController = ScrollController(initialScrollOffset: 10);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollEnd);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollEnd);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollEnd() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.offset == 0) {
        if (context.currentPage() > 0) {
          context.jumpPrevious().then((_) => _scrollController.jumpTo(1));
        }
      } else if (context.currentPage() <= 3) {
        final offset = _scrollController.offset;
        context.jumpNext().then((_) => _scrollController.jumpTo(offset - 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.textContent),
        Positioned.fill(
          child: ListenableBuilder(
            listenable: _scrollController,
            builder: (_, __) {
              double scrollPosition = -0.25;
              if (_scrollController.positions.isNotEmpty) {
                scrollPosition = _scrollController.offset /
                    _scrollController.position.maxScrollExtent;
              }

              return _ScrollingAppFrames(
                lightAssetPaths: widget.lightAssetPaths,
                darkAssetPaths: widget.darkAssetPaths,
                scrollPosition: scrollPosition,
                phoneFrameSizeMultipliers: widget.phoneFrameSizeMultipliers,
                positionLowerBound: -0.55,
                positionUpperBound:
                    1 + (0.45 * widget.constraints.maxHeight / 803),
              );
            },
          ),
        ),
        Positioned.fill(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                // This makes the scroll extent 50% of the screen's height
                height: widget.constraints.maxHeight * 1.5,
                width: widget.constraints.maxWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextContent extends StatelessWidget {
  final String title;
  final List<TagChip> tagChips;
  final String description;
  final Widget bottomContent;

  const _TextContent({
    required this.title,
    required this.tagChips,
    required this.description,
    required this.bottomContent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add top padding to avoid header
          const SizedBox(height: 60),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Libre Baskerville',
              fontSize: 36,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tagChips,
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(
              fontSize: 24,
              height: 1.25,
              letterSpacing: 1.33,
            ),
          ),
          const SizedBox(height: 50),
          bottomContent,
        ],
      ),
    );
  }
}

class _ScrollingAppFrames extends StatefulWidget {
  final List<String> lightAssetPaths;
  final List<String> darkAssetPaths;
  final double scrollPosition;
  final List<double> phoneFrameSizeMultipliers;
  final double positionLowerBound;
  final double positionUpperBound;

  const _ScrollingAppFrames({
    required this.lightAssetPaths,
    required this.darkAssetPaths,
    required this.scrollPosition,
    required this.phoneFrameSizeMultipliers,
    this.positionLowerBound = 0,
    this.positionUpperBound = 1,
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
  late final _controller = AnimationController(vsync: this);
  late final _positionAnimation = Tween(
    begin: widget.positionLowerBound,
    end: widget.positionUpperBound,
  ).animate(_controller);

  @override
  void didUpdateWidget(covariant _ScrollingAppFrames oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.scrollPosition,
      curve: Curves.easeOutQuart,
      duration: 700.ms,
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
          positionAnimation: _positionAnimation,
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
