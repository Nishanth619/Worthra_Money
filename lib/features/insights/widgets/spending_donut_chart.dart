import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/currency_format.dart';
import '../../../repositories/category_insight.dart';

class SpendingDonutChart extends StatefulWidget {
  const SpendingDonutChart({
    required this.insights,
    required this.totalAmount,
    required this.currencySymbol,
    super.key,
  });

  final List<CategoryInsight> insights;
  final double totalAmount;
  final String currencySymbol;

  @override
  State<SpendingDonutChart> createState() => _SpendingDonutChartState();
}

class _SpendingDonutChartState extends State<SpendingDonutChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SpendingDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.insights != widget.insights ||
        oldWidget.totalAmount != widget.totalAmount) {
      _selectedIndex = null;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final segments = _buildSegments(colors, widget.insights);
    final selected =
        _selectedIndex != null && _selectedIndex! < widget.insights.length
        ? widget.insights[_selectedIndex!]
        : null;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 460;
          final chartSize =
              (isWide
                      ? constraints.maxWidth * 0.36
                      : constraints.maxWidth * 0.62)
                  .clamp(190.0, 240.0)
                  .toDouble();
          final legendCount = isWide ? 5 : 4;
          final legendItems = widget.insights.take(legendCount).toList();
          final chart = _buildChart(
            context: context,
            colors: colors,
            textTheme: textTheme,
            chartSize: chartSize,
            segments: segments,
            selected: selected,
          );
          final legend = _LegendList(
            insights: legendItems,
            colors: segments
                .take(legendCount)
                .map((segment) => segment.color)
                .toList(),
            currencySymbol: widget.currencySymbol,
            selectedIndex: _selectedIndex,
            onSelect: (index) {
              setState(() {
                _selectedIndex = _selectedIndex == index ? null : index;
              });
            },
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Mix',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap the chart or legend to inspect a category.',
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
              const SizedBox(height: 20),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 5, child: Center(child: chart)),
                    const SizedBox(width: 20),
                    Expanded(flex: 6, child: legend),
                  ],
                )
              else
                Column(
                  children: [
                    Center(child: chart),
                    const SizedBox(height: 22),
                    legend,
                  ],
                ),
              if (widget.insights.length > legendCount) ...[
                const SizedBox(height: 12),
                Text(
                  '+${widget.insights.length - legendCount} more categories are listed below.',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildChart({
    required BuildContext context,
    required AppPalette colors,
    required TextTheme textTheme,
    required double chartSize,
    required List<_ChartSegment> segments,
    required CategoryInsight? selected,
  }) {
    final label = selected?.category ?? 'Total';
    final amount = selected?.totalSpent ?? widget.totalAmount;
    final meta = selected != null
        ? '${(selected.percentage * 100).toStringAsFixed(0)}% of total'
        : 'All expenses';

    return SizedBox.square(
      dimension: chartSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) {
          final tappedIndex = _segmentIndexAtPosition(
            localPosition: details.localPosition,
            chartSize: chartSize,
            segments: segments,
          );
          setState(() {
            _selectedIndex = _selectedIndex == tappedIndex ? null : tappedIndex;
          });
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return CustomPaint(
              size: Size.square(chartSize),
              painter: _InteractiveDonutPainter(
                segments: segments,
                trackColor: colors.surfaceContainerHighest,
                progress: _animation.value,
                selectedIndex: _selectedIndex,
              ),
              child: Center(
                child: Container(
                  width: chartSize * 0.56,
                  height: chartSize * 0.56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                    border: Border.all(
                      color: colors.surfaceContainerHighest.withValues(
                        alpha: 0.85,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final innerSize = constraints.maxWidth;
                      final labelStyle = textTheme.labelMedium?.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        fontSize: (innerSize * 0.11).clamp(11.0, 14.0),
                      );
                      final amountStyle = textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: (innerSize * 0.22).clamp(18.0, 28.0),
                        height: 1,
                      );
                      final metaStyle = textTheme.labelSmall?.copyWith(
                        color: colors.textMuted,
                        height: 1.2,
                        fontSize: (innerSize * 0.095).clamp(10.0, 12.0),
                      );

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: innerSize * 0.18,
                              child: Center(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: labelStyle,
                                ),
                              ),
                            ),
                            SizedBox(height: innerSize * 0.03),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: amount),
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, _) {
                                  return Text(
                                    formatCurrency(
                                      value,
                                      symbol: widget.currencySymbol,
                                      compact: true,
                                    ),
                                    textAlign: TextAlign.center,
                                    style: amountStyle,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: innerSize * 0.03),
                            SizedBox(
                              height: innerSize * 0.16,
                              child: Center(
                                child: Text(
                                  meta,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: metaStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int? _segmentIndexAtPosition({
    required Offset localPosition,
    required double chartSize,
    required List<_ChartSegment> segments,
  }) {
    if (segments.isEmpty) return null;

    final center = Offset(chartSize / 2, chartSize / 2);
    final offset = localPosition - center;
    final distance = offset.distance;
    final outerPadding = _outerPaddingForSize(chartSize);
    final maxStrokeWidth =
        _baseStrokeWidthForSize(chartSize) +
        _selectedStrokeBoostForSize(chartSize);
    final radius = chartSize / 2 - outerPadding - maxStrokeWidth / 2;
    final innerRadius = radius - maxStrokeWidth / 2 - 10;
    final outerRadius = radius + maxStrokeWidth / 2 + 10;

    if (distance < innerRadius || distance > outerRadius) {
      return null;
    }

    var angle = math.atan2(offset.dy, offset.dx) + math.pi / 2;
    if (angle < 0) {
      angle += math.pi * 2;
    }

    const gapRadians = _InteractiveDonutPainter.gapRadians;
    var start = 0.0;
    for (var i = 0; i < segments.length; i++) {
      final fullSweep = math.pi * 2 * segments[i].percentage;
      final segmentStart = start + gapRadians / 2;
      final segmentEnd = start + fullSweep - gapRadians / 2;
      if (angle >= segmentStart && angle <= segmentEnd) {
        return i;
      }
      start += fullSweep;
    }
    return null;
  }
}

class _LegendList extends StatelessWidget {
  const _LegendList({
    required this.insights,
    required this.colors,
    required this.currencySymbol,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<CategoryInsight> insights;
  final List<Color> colors;
  final String currencySymbol;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: insights.asMap().entries.map((entry) {
        final index = entry.key;
        final insight = entry.value;
        final color = colors[index];
        final isSelected = selectedIndex == index;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index < insights.length - 1 ? 10 : 0,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.12)
                    : palette.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? color.withValues(alpha: 0.4)
                      : palette.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          insight.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatCurrency(
                            insight.totalSpent,
                            symbol: currencySymbol,
                            compact: true,
                          ),
                          style: textTheme.bodySmall?.copyWith(
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(insight.percentage * 100).toStringAsFixed(0)}%',
                    style: textTheme.labelLarge?.copyWith(
                      color: isSelected ? color : palette.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ChartSegment {
  const _ChartSegment({required this.percentage, required this.color});

  final double percentage;
  final Color color;
}

class _InteractiveDonutPainter extends CustomPainter {
  const _InteractiveDonutPainter({
    required this.segments,
    required this.trackColor,
    required this.progress,
    this.selectedIndex,
  });

  static const double gapRadians = 0.08;

  final List<_ChartSegment> segments;
  final Color trackColor;
  final double progress;
  final int? selectedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final outerPadding = _outerPaddingForSize(size.width);
    final baseStrokeWidth = _baseStrokeWidthForSize(size.width);
    final selectedBoost = _selectedStrokeBoostForSize(size.width);
    final radius =
        size.width / 2 - outerPadding - (baseStrokeWidth + selectedBoost) / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);

    var start = -math.pi / 2;
    for (var i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final fullSweep = math.pi * 2 * segment.percentage;
      final sweep = math.max(0.0, fullSweep - gapRadians) * progress;
      final isSelected = selectedIndex == i;
      final paint = Paint()
        ..color = isSelected
            ? segment.color
            : segment.color.withValues(alpha: selectedIndex == null ? 1 : 0.38)
        ..style = PaintingStyle.stroke
        ..strokeWidth = baseStrokeWidth + (isSelected ? selectedBoost : 0)
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, start + gapRadians / 2, sweep, false, paint);
      start += fullSweep;
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveDonutPainter oldDelegate) {
    return oldDelegate.segments != segments ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

List<_ChartSegment> _buildSegments(
  AppPalette colors,
  List<CategoryInsight> insights,
) {
  if (insights.isEmpty) return const [];

  final palette = _palette(colors);
  final total = insights.fold<double>(
    0,
    (sum, insight) => sum + insight.percentage,
  );

  return insights.asMap().entries.map((entry) {
    final normalizedPercentage = total <= 0
        ? 1 / insights.length
        : (entry.value.percentage / total).clamp(0.0, 1.0);
    return _ChartSegment(
      percentage: normalizedPercentage,
      color: palette[entry.key % palette.length],
    );
  }).toList();
}

List<Color> _palette(AppPalette colors) => [
  colors.tertiary,
  colors.secondary,
  colors.primary,
  colors.warning,
  const Color(0xFFFF7F50),
  const Color(0xFF9B59B6),
  const Color(0xFF3498DB),
  const Color(0xFF1ABC9C),
];

double _baseStrokeWidthForSize(double size) => size >= 220 ? 18 : 16;

double _selectedStrokeBoostForSize(double size) => size >= 220 ? 4 : 3;

double _outerPaddingForSize(double size) => size >= 220 ? 6 : 5;
