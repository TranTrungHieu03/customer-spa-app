import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';

/// A custom chart widget that displays skin health data in a visually appealing way
class SkinHealthRadialChart extends StatefulWidget {
  /// The title of the chart
  final String title;

  /// The data to be displayed (values should be between 0.0 and 1.0)
  final List<SkinHealthDataPoint> dataPoints;

  /// The color scheme to use for the chart
  final List<Color> colorScheme;

  /// Optional description text
  final String? description;

  /// Animation duration for the chart
  final Duration animationDuration;

  const SkinHealthRadialChart({
    Key? key,
    required this.title,
    required this.dataPoints,
    this.colorScheme = const [
      Color(0xFFFF8A80), // Red
      Color(0xFFFFD180), // Orange
      Color(0xFFFFFF8D), // Yellow
      Color(0xFFCCFF90), // Light Green
      Color(0xFF80D8FF), // Light Blue
    ],
    this.description,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<SkinHealthRadialChart> createState() => _SkinHealthRadialChartState();
}

class _SkinHealthRadialChartState extends State<SkinHealthRadialChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (widget.description != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.0,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _SkinHealthChartPainter(
                    dataPoints: widget.dataPoints,
                    colorScheme: widget.colorScheme,
                    animationValue: _animationController.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(
        widget.dataPoints.length,
        (index) {
          final dataPoint = widget.dataPoints[index];
          final color =
              index < widget.colorScheme.length ? widget.colorScheme[index] : widget.colorScheme[index % widget.colorScheme.length];

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text('${dataPoint.label}: ${(dataPoint.value * 100).toStringAsFixed(0)}%', style: Theme.of(context)!.textTheme.labelMedium),
            ],
          );
        },
      ),
    );
  }
}

class _SkinHealthChartPainter extends CustomPainter {
  final List<SkinHealthDataPoint> dataPoints;
  final List<Color> colorScheme;
  final double animationValue;

  _SkinHealthChartPainter({
    required this.dataPoints,
    required this.colorScheme,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.85;

    // Draw the background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the grid lines
    _drawGridLines(canvas, center, radius);

    // Draw data arcs
    _drawDataArcs(canvas, center, radius);

    // Draw center text
    _drawCenterText(canvas, center, size);
  }

  void _drawGridLines(Canvas canvas, Offset center, double radius) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      final circleRadius = radius * i / 5;
      canvas.drawCircle(center, circleRadius, gridPaint);
    }

    // Draw radial lines
    if (dataPoints.isNotEmpty) {
      final angleStep = 2 * math.pi / dataPoints.length;
      for (int i = 0; i < dataPoints.length; i++) {
        final angle = -math.pi / 2 + i * angleStep;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        canvas.drawLine(center, Offset(x, y), gridPaint);

        // Draw labels
        final labelRadius = radius + 20;
        final labelX = center.dx + labelRadius * math.cos(angle);
        final labelY = center.dy + labelRadius * math.sin(angle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: dataPoints[i].label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelX - textPainter.width / 2,
            labelY - textPainter.height / 2,
          ),
        );
      }
    }
  }

  void _drawDataArcs(Canvas canvas, Offset center, double radius) {
    if (dataPoints.isEmpty) return;

    final path = Path();
    final angleStep = 2 * math.pi / dataPoints.length;

    for (int i = 0; i < dataPoints.length; i++) {
      final dataPoint = dataPoints[i];
      final angle = -math.pi / 2 + i * angleStep;

      final pointRadius = radius * math.min(1.0, dataPoint.value * animationValue);
      final x = center.dx + pointRadius * math.cos(angle);
      final y = center.dy + pointRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw the data point dot
      final dotPaint = Paint()
        ..color = colorScheme[i % colorScheme.length]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }

    // Close the path
    path.close();

    // Draw the filled area
    final fillPaint = Paint()
      ..color = colorScheme[0].withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Draw the outline
    final outlinePaint = Paint()
      ..color = colorScheme[0]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);
  }

  void _drawCenterText(Canvas canvas, Offset center, Size size) {
    // Calculate average value
    double average = 0;
    for (var point in dataPoints) {
      average += point.value;
    }
    average = dataPoints.isEmpty ? 0 : average / dataPoints.length;

    // Draw the average text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(average * 100 * animationValue).toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: '\n${_getScoreDescription(average, navigatorKey.currentContext!)}',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: size.width * 0.3);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  String _getScoreDescription(double score, BuildContext context) {
    if (score >= 0.8) return AppLocalizations.of(context)!.excellent;
    if (score >= 0.6) return AppLocalizations.of(context)!.good;
    if (score >= 0.4) return AppLocalizations.of(context)!.average;
    if (score >= 0.2) return AppLocalizations.of(context)!.fair;
    return AppLocalizations.of(context)!.poor;
  }

  @override
  bool shouldRepaint(_SkinHealthChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Represents a single data point in the skin health chart
class SkinHealthDataPoint {
  /// The label for this data point
  final String label;

  /// The value of this data point (should be between 0.0 and 1.0)
  final double value;

  SkinHealthDataPoint({
    required this.label,
    required this.value,
  }) : assert(value >= 0 && value <= 1, 'Value must be between 0.0 and 1.0');
}
