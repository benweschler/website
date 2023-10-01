import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:provider/provider.dart';

import 'mouse_move_notifier.dart';

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
    context
        .read<MouseMoveNotifier>()
        .addListener(() => setState(() => time += 0.04));
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
          painter: GradientPainter(time: time, shader: shader),
        ),
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  final double time;
  final FragmentShader shader;

  const GradientPainter({required this.time, required this.shader});

  @override
  void paint(Canvas canvas, Size size) {
    // Animated time
    shader.setFloat(0, time);

    // Window size
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => time != oldDelegate.time;
}
