import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class FallingStarEffect extends StatefulWidget {
  final Widget child;

  const FallingStarEffect({super.key, required this.child});

  @override
  _FallingStarEffectState createState() => _FallingStarEffectState();
}

class _FallingStarEffectState extends State<FallingStarEffect> with SingleTickerProviderStateMixin {
  final List<_StarParticle> _stars = [];
  late Timer _timer;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _addStar();
    });
  }

  void _addStar() {
    final size = MediaQuery.of(context).size;

    final star = _StarParticle(
      position: Offset(_random.nextDouble() * size.width, -50),
      animationController: AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      ),
    );

    star.animationController.forward().then((_) {
      // Reset lại vị trí sao để rơi liên tục
      setState(() {
        star.position = Offset(_random.nextDouble() * size.width, -50);
        star.animationController.reset();
        star.animationController.forward();
      });
    });

    setState(() {
      _stars.add(star);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ..._stars.map((star) => _StarWidget(star: star)),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var star in _stars) {
      star.animationController.dispose();
    }
    super.dispose();
  }
}

class _StarParticle {
  Offset position;
  final AnimationController animationController;

  _StarParticle({
    required this.position,
    required this.animationController,
  });
}

class _StarWidget extends StatelessWidget {
  final _StarParticle star;

  const _StarWidget({Key? key, required this.star}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: star.animationController,
      builder: (context, child) {
        final progress = star.animationController.value;
        final size = 15 * (1 - progress);
        final offset = Offset(
          star.position.dx,
          star.position.dy + (progress * MediaQuery.of(context).size.height),
        );

        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Transform.rotate(
            angle: progress * math.pi,
            child: Opacity(
              opacity: 1 - progress,
              child: CustomPaint(
                painter: _StarPainter(),
                size: Size(size, size),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;

    path.moveTo(centerX, centerY - outerRadius);

    for (int i = 0; i < 5; i++) {
      final outerAngle = (math.pi / 2) + (i * 4 * math.pi / 5);
      final innerAngle = outerAngle + math.pi / 5;

      path.lineTo(
        centerX + outerRadius * math.cos(outerAngle),
        centerY - outerRadius * math.sin(outerAngle),
      );

      path.lineTo(
        centerX + innerRadius * math.cos(innerAngle),
        centerY - innerRadius * math.sin(innerAngle),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
