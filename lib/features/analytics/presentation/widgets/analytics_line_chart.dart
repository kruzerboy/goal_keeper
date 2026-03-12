import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../../../core/theme/app_theme.dart';

class AnalyticsLineChart extends StatelessWidget {
  final List<double> points;
  final List<String> labels;

  const AnalyticsLineChart({
    super.key,
    required this.points,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _LinePainter(points: points),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: labels
                    .map((l) => Text(l, style: AppTypography.bodySmall))
                    .toList(),
              ),
            ),
          ),
        ),
      );
}

class _LinePainter extends CustomPainter {
  final List<double> points;
  const _LinePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final chartHeight = size.height - 24;
    final stepX = size.width / (points.length - 1);

    final linePath = Path();
    final fillPath = Path();

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = chartHeight - (points[i] * chartHeight * 0.85) - 10;
      i == 0 ? linePath.moveTo(x, y) : linePath.lineTo(x, y);
    }

    // Gradient fill
    fillPath.addPath(linePath, Offset.zero);
    fillPath.lineTo((points.length - 1) * stepX, chartHeight);
    fillPath.lineTo(0, chartHeight);
    fillPath.close();

    final gradient = ui.Gradient.linear(
      Offset(0, 0),
      Offset(0, chartHeight),
      [AppColors.primary.withOpacity(0.25), AppColors.primary.withOpacity(0.0)],
    );

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.points != points;
}