import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:website/style/theme.dart';
import 'package:website/widgets/app_preview_page/full_screen_app_preview.dart';
import 'package:website/widgets/hero_dialog_route.dart';
import 'package:website/widgets/phone_frame.dart';

class AppPreviewFrame extends StatefulWidget {
  final String lightAssetPath;
  final String darkAssetPath;

  const AppPreviewFrame({
    super.key,
    required this.lightAssetPath,
    required this.darkAssetPath,
  });

  @override
  State<AppPreviewFrame> createState() => _AppPreviewFrameState();
}

class _AppPreviewFrameState extends State<AppPreviewFrame> {
  late bool _isDark;

  @override
  void didChangeDependencies() {
    // AppColors must be depended on here rather than in the build method. This
    // is because if dependOnInheritedWidgetOfExactType is called in the build
    // method, when the screen changes whether it is in the wide layout or not,
    // its context becomes stale and using a stale build context is unsafe and
    // throws an error. didChangeDependencies fires when the context becomes
    // stale and dependOnInheritedWidgetOfExactType is called in its body.
    setState(() => _isDark = AppColors.of(context).isDark);
    super.didChangeDependencies();
  }

  Widget _imageFrameBuilder(
      BuildContext context,
      Widget child,
      int? frame,
      bool? wasSynchronouslyLoaded,
      ) {
    if (frame != null) return child;

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: constraints.maxWidth,
        // The exact aspect ratio of the media showcase images
        height: constraints.maxWidth * 2.164,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = Hero(
      tag: widget.lightAssetPath,
      // No clue why this is required, but it prevents jumps in the rounded
      // clipping around images.
      // See https://github.com/flutter/flutter/issues/100903/
      createRectTween: (begin, end) => RectTween(begin: begin, end: end),
      child: PhoneFrame(
        child: Image.asset(
          widget.lightAssetPath,
          frameBuilder: _imageFrameBuilder,
        )
            .animate(
          target: _isDark ? 1 : 0,
          onInit: (controller) => controller.value = _isDark ? 1 : 0,
        )
            .crossfade(
          builder: (_) => Image.asset(
            widget.darkAssetPath,
            frameBuilder: _imageFrameBuilder,
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).push(HeroDialogRoute(
        child: FullScreenAppPreview(child: child),
      )),
      child: child,
    );
  }
}
