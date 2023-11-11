import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:provider/provider.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/color_utils.dart';

import 'pointer_move_notifier.dart';

//TODO: Gradient animation ticking may possibly still vary by refresh rate even after fix?

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  late final Timer _timeUpdateTimer;
  late double _timeIncrement = _idleTimeIncrement;
  final double _idleTimeIncrement = 0.016;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    final pointerMoveNotifier = context.read<PointerMoveNotifier>();

    // Trigger a more dramatic effect on a touch interaction since the
    // interaction time is usually shorter.
    pointerMoveNotifier.addTouchListener(
        () => setState(() => _timeIncrement = _idleTimeIncrement + 0.12));
    pointerMoveNotifier.addMouseListener(
        () => setState(() => _timeIncrement = _idleTimeIncrement + 0.08));
    pointerMoveNotifier.addPointerStopListener(
        () => setState(() => _timeIncrement = _idleTimeIncrement));

    _timeUpdateTimer =
        Timer.periodic((1000 / 60).ms, (_) => _updateAnimationTime());
  }

  @override
  void dispose() {
    _timeUpdateTimer.cancel();
    super.dispose();
  }

  void _updateAnimationTime() => setState(() => _time += _timeIncrement);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ShaderBuilder(
        assetKey: 'assets/shaders/gradient.frag',
        (context, shader, child) => CustomPaint(
          painter: GradientPainter(
            time: _time,
            shader: shader,
            gradientColors: AppColors.of(context).gradientColors,
          ),
        ),
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  final double time;
  final FragmentShader shader;
  final GradientColors gradientColors;

  const GradientPainter({
    required this.time,
    required this.shader,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Animated time
    shader.setFloat(0, time);

    // Window size
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);

    // Upper left color
    shader.setFloat(3, gradientColors.upperLeft.redNorm);
    shader.setFloat(4, gradientColors.upperLeft.greenNorm);
    shader.setFloat(5, gradientColors.upperLeft.blueNorm);

    // Upper right color
    shader.setFloat(6, gradientColors.upperRight.redNorm);
    shader.setFloat(7, gradientColors.upperRight.greenNorm);
    shader.setFloat(8, gradientColors.upperRight.blueNorm);

    // Bottom left color
    shader.setFloat(9, gradientColors.bottomLeft.redNorm);
    shader.setFloat(10, gradientColors.bottomLeft.greenNorm);
    shader.setFloat(11, gradientColors.bottomLeft.blueNorm);

    // Bottom right color
    shader.setFloat(12, gradientColors.bottomRight.redNorm);
    shader.setFloat(13, gradientColors.bottomRight.greenNorm);
    shader.setFloat(14, gradientColors.bottomRight.blueNorm);

    // Film grain intensity
    shader.setFloat(15, 0.1);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => time != oldDelegate.time;
}
