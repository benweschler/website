import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:provider/provider.dart';
import 'package:website/style/theme.dart';
import 'package:website/utils/color_utils.dart';

import 'pointer_move_notifier.dart';

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({super.key});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final Ticker ticker;
  double time = 0;

  @override
  void initState() {
    super.initState();
    final pointerMoveNotifier = context.read<PointerMoveNotifier>();

    // Trigger a more dramatic effect on a touch interaction since the
    // interaction time is usually shorter.
    pointerMoveNotifier.addTouchListener(() => setState(() => time += 0.12));
    pointerMoveNotifier.addMouseListener(() => setState(() => time += 0.04));
    ticker = createTicker((_) => setState(() => time += 0.03))..start();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ShaderBuilder(
        assetKey: 'assets/shaders/gradient.frag',
        (context, shader, child) => CustomPaint(
          painter: GradientPainter(
            time: time,
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
    shader.setFloat(6, gradientColors.upperLeft.opacity);

    // Upper right color
    shader.setFloat(7, gradientColors.upperRight.redNorm);
    shader.setFloat(8, gradientColors.upperRight.greenNorm);
    shader.setFloat(9, gradientColors.upperRight.blueNorm);
    shader.setFloat(10, gradientColors.upperRight.opacity);

    // Bottom left color
    shader.setFloat(11, gradientColors.bottomLeft.redNorm);
    shader.setFloat(12, gradientColors.bottomLeft.greenNorm);
    shader.setFloat(13, gradientColors.bottomLeft.blueNorm);
    shader.setFloat(14, gradientColors.bottomLeft.opacity);

    // Bottom right color
    shader.setFloat(15, gradientColors.bottomRight.redNorm);
    shader.setFloat(16, gradientColors.bottomRight.greenNorm);
    shader.setFloat(17, gradientColors.bottomRight.blueNorm);
    shader.setFloat(18, gradientColors.bottomRight.opacity);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => time != oldDelegate.time;
}
