import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/theme_extensions.dart';

class StreakRing extends StatelessWidget {
  const StreakRing({
    required this.progress,
    required this.centerLabel,
    required this.bottomLabel,
    this.size = 180,
    this.strokeWidth = 10,
    this.progressColor,
    this.shadowColor,
    super.key,
  });

  final double progress;
  final String centerLabel;
  final String bottomLabel;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appPalette;
    final activeColor = progressColor ?? colors.primaryContainer;
    final ringShadow = shadowColor ?? activeColor.withValues(alpha: 0.22);
    final innerSize = size - (strokeWidth * 3.2);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ringShadow,
                    blurRadius: size * 0.12,
                    spreadRadius: size * 0.01,
                  ),
                ],
              ),
            ),
          ),
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              progress: progress,
              colors: colors,
              strokeWidth: strokeWidth,
              progressColor: activeColor,
            ),
          ),
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surfaceContainer,
              border: Border.all(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerLabel,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bottomLabel.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: colors.textMuted,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.colors,
    required this.strokeWidth,
    required this.progressColor,
  });

  final double progress;
  final AppPalette colors;
  final double strokeWidth;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth;

    final trackPaint = Paint()
      ..color = colors.surfaceContainerHighest
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          progressColor.withValues(alpha: 0.72),
          progressColor,
        ],
      ).createShader(Offset.zero & size)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        colors != oldDelegate.colors ||
        strokeWidth != oldDelegate.strokeWidth ||
        progressColor != oldDelegate.progressColor;
  }
}
