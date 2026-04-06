import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../models/app_settings.dart';
import '../../../repositories/category_insight.dart';
import '../../../state/insights_provider.dart';
import '../../../state/settings_provider.dart';
import '../widgets/spending_donut_chart.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final period = ref.watch(insightsPeriodProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final insightsAsync = ref.watch(insightsProvider);
    final incomeAsync = ref.watch(periodIncomeProvider);
    final expenseAsync = ref.watch(periodExpenseProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.insightsHeaderIntelligence,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.insightsHeaderTitle,
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.insightsHeaderSubtitle,
                style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _PeriodSelector(
            selected: period,
            onChanged: (selectedPeriod) {
              ref
                  .read(settingsControllerProvider.notifier)
                  .setInsightsPeriod(selectedPeriod);
            },
          ),
          const SizedBox(height: 24),
          _SummaryRow(
            incAsync: incomeAsync,
            expAsync: expenseAsync,
            currencySymbol: currencySymbol,
            colors: colors,
          ),
          const SizedBox(height: 24),
          insightsAsync.when(
            loading: () => const _ShimmerBody(),
            error: (error, _) => _ErrorCard(message: error.toString()),
            data: (insights) {
              if (insights.isEmpty) return const _EmptyState();
              final income = incomeAsync.value ?? 0;
              final expense = expenseAsync.value ?? 0;
              return _InsightsBody(
                insights: insights,
                currencySymbol: currencySymbol,
                income: income,
                expense: expense,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onChanged});

  final InsightsPeriodPreference selected;
  final ValueChanged<InsightsPeriodPreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PeriodChip(
              label: context.l10n.insightsTabWeekly,
              selected: selected == InsightsPeriodPreference.weekly,
              onTap: () => onChanged(InsightsPeriodPreference.weekly),
            ),
          ),
          Expanded(
            child: _PeriodChip(
              label: context.l10n.insightsTabMonthly,
              selected: selected == InsightsPeriodPreference.monthly,
              onTap: () => onChanged(InsightsPeriodPreference.monthly),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? colors.primary : colors.textMuted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.incAsync,
    required this.expAsync,
    required this.currencySymbol,
    required this.colors,
  });

  final AsyncValue<double> incAsync;
  final AsyncValue<double> expAsync;
  final String currencySymbol;
  final AppPalette colors;

  @override
  Widget build(BuildContext context) {
    final income = incAsync.value ?? 0;
    final expense = expAsync.value ?? 0;
    final net = income - expense;
    final savings = income > 0
        ? ((income - expense) / income * 100).clamp(0, 100)
        : 0.0;
    final colors = this.colors;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 430;

          final incomeStat = _CompactMetric(
            label: context.l10n.insightsIncome,
            value: formatCurrency(
              income,
              symbol: currencySymbol,
              compact: true,
            ),
            icon: Icons.south_west_rounded,
            color: colors.success,
          );
          final expenseStat = _CompactMetric(
            label: context.l10n.insightsExpenses,
            value: formatCurrency(
              expense,
              symbol: currencySymbol,
              compact: true,
            ),
            icon: Icons.north_east_rounded,
            color: colors.secondary,
          );
          final savedStat = _SavingsMetric(
            label: context.l10n.insightsSaved,
            percentText: '${savings.toStringAsFixed(0)}%',
            netText: formatCurrency(net, symbol: currencySymbol, compact: true),
            color: colors.tertiary,
            progress: income <= 0 ? 0 : (savings / 100).clamp(0.0, 1.0),
          );

          if (compact) {
            return Column(
              children: [
                incomeStat,
                const SizedBox(height: 14),
                expenseStat,
                const SizedBox(height: 14),
                savedStat,
              ],
            );
          }

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: incomeStat),
                _MetricDivider(colors: colors),
                Expanded(child: expenseStat),
                _MetricDivider(colors: colors),
                Expanded(child: savedStat),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsMetric extends StatelessWidget {
  const _SavingsMetric({
    required this.label,
    required this.percentText,
    required this.netText,
    required this.color,
    required this.progress,
  });

  final String label;
  final String percentText;
  final String netText;
  final Color color;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.savings_rounded, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.textMuted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          percentText,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            netText,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider({required this.colors});

  final AppPalette colors;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: 24,
      thickness: 1,
      color: colors.outlineVariant.withValues(alpha: 0.55),
    );
  }
}

class _InsightsBody extends StatelessWidget {
  const _InsightsBody({
    required this.insights,
    required this.currencySymbol,
    required this.income,
    required this.expense,
  });

  final List<CategoryInsight> insights;
  final String currencySymbol;
  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final palette = _buildPalette(colors);
    final totalExp = insights.fold<double>(
      0,
      (sum, item) => sum + item.totalSpent,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpendingDonutChart(
          insights: insights,
          totalAmount: totalExp,
          currencySymbol: currencySymbol,
        ),
        const SizedBox(height: 20),
        _NetBalanceBanner(
          amount: income - expense,
          currencySymbol: currencySymbol,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.bar_chart_rounded,
                color: colors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.insightsCategoryBreakdown,
                    style: textTheme.titleLarge,
                  ),
                  Text(
                    '${insights.length} categories tracked',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: colors.outlineVariant.withValues(alpha: 0.7),
                ),
              ),
              child: Text(
                formatCurrency(totalExp, symbol: currencySymbol, compact: true),
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...insights.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: entry.key < insights.length - 1 ? 12 : 0,
            ),
            child: _CategoryRow(
              insight: entry.value,
              color: palette[entry.key % palette.length],
              currencySymbol: currencySymbol,
              rank: entry.key + 1,
            ),
          );
        }),
        const SizedBox(height: 24),
        _SmartTipCard(insights: insights),
      ],
    );
  }
}

class _NetBalanceBanner extends StatelessWidget {
  const _NetBalanceBanner({required this.amount, required this.currencySymbol});

  final double amount;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final netPositive = amount >= 0;
    final accent = netPositive ? colors.success : colors.secondary;
    final title = netPositive
        ? context.l10n.insightsGreenBanner
        : context.l10n.insightsRedBanner;
    final prefix = netPositive
        ? context.l10n.insightsSurplus
        : context.l10n.insightsDeficit;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withValues(alpha: 0.14), colors.surfaceContainerLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 380;
          final iconTile = Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              netPositive
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: accent,
              size: 24,
            ),
          );
          final amountChip = Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: accent.withValues(alpha: 0.2)),
            ),
            child: Text(
              formatCurrency(amount, symbol: currencySymbol, compact: true),
              style: textTheme.titleMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
          final textBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$prefix ${formatCurrency(amount.abs(), symbol: currencySymbol)} ${context.l10n.insightsThisPeriod}',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          );

          if (isCompact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconTile,
                    const SizedBox(width: 12),
                    Expanded(child: textBlock),
                  ],
                ),
                const SizedBox(height: 12),
                amountChip,
              ],
            );
          }

          return Row(
            children: [
              iconTile,
              const SizedBox(width: 12),
              Expanded(child: textBlock),
              const SizedBox(width: 14),
              amountChip,
            ],
          );
        },
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.insight,
    required this.color,
    required this.currencySymbol,
    required this.rank,
  });

  final CategoryInsight insight;
  final Color color;
  final String currencySymbol;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final icon = _iconForCategory(insight.category);
    final shareLabel =
        '${(insight.percentage * 100).toStringAsFixed(1)}% ${context.l10n.insightsOfExpenses}';
    final percentageValue = '${(insight.percentage * 100).toStringAsFixed(0)}%';
    final amountText = formatCurrency(
      insight.totalSpent,
      symbol: currencySymbol,
      compact: true,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 350;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          insight.category,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          shareLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: isCompact ? 84 : 96,
                      maxWidth: isCompact ? 104 : 124,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          amountText,
                          textAlign: TextAlign.right,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: insight.percentage),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, child) => Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: value.clamp(0.0, 1.0),
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color.withValues(alpha: 0.82), color],
                            ),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.22),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 48,
                child: Text(
                  percentageValue,
                  textAlign: TextAlign.right,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Rank #$rank',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (rank == 1) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    context.l10n.insightsTopBadge,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SmartTipCard extends StatelessWidget {
  const _SmartTipCard({required this.insights});

  final List<CategoryInsight> insights;

  String _tip(BuildContext context, List<CategoryInsight> insights) {
    if (insights.isEmpty) return context.l10n.insightsTipEmpty;
    final top = insights.first;
    final topPct = (top.percentage * 100).toStringAsFixed(0);

    if (top.percentage > 0.5) {
      return context.l10n.insightsTipMoreThanHalf(top.category, topPct);
    }
    if (top.percentage > 0.35) {
      return context.l10n.insightsTipLeads(top.category, topPct);
    }
    if (insights.length >= 3 &&
        insights[0].percentage - insights[2].percentage < 0.1) {
      return context.l10n.insightsTipBalanced;
    }
    return context.l10n.insightsTipTop(top.category, topPct);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final top = insights.isEmpty ? null : insights.first;
    final topPct = top == null
        ? null
        : '${(top.percentage * 100).toStringAsFixed(0)}%';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primarySoft, colors.surfaceContainerLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -18,
            child: Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.06),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              final iconTile = Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: colors.primary,
                  size: 22,
                ),
              );
              final textBlock = Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.insightsTipTitle,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tip(context, insights),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              );
              final categoryChip = top == null
                  ? const SizedBox.shrink()
                  : Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Text(
                        '${top.category} ${topPct ?? ''}',
                        style: textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        iconTile,
                        const SizedBox(width: 14),
                        textBlock,
                      ],
                    ),
                    if (top != null) ...[
                      const SizedBox(height: 16),
                      categoryChip,
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  iconTile,
                  const SizedBox(width: 14),
                  textBlock,
                  if (top != null) ...[const SizedBox(width: 16), categoryChip],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.insights_rounded,
              size: 40,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.insightsEmptyTitle,
            style: textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.insightsEmptySubtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ShimmerBody extends StatefulWidget {
  const _ShimmerBody();

  @override
  State<_ShimmerBody> createState() => _ShimmerBodyState();
}

class _ShimmerBodyState extends State<_ShimmerBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Column(
          children: [
            _ShimmerRect(height: 240, colors: colors),
            const SizedBox(height: 16),
            _ShimmerRect(height: 100, colors: colors),
            const SizedBox(height: 16),
            _ShimmerRect(height: 82, colors: colors),
            const SizedBox(height: 12),
            _ShimmerRect(height: 102, colors: colors),
            const SizedBox(height: 12),
            _ShimmerRect(height: 102, colors: colors),
            const SizedBox(height: 12),
            _ShimmerRect(height: 102, colors: colors),
          ],
        );
      },
    );
  }
}

class _ShimmerRect extends StatelessWidget {
  const _ShimmerRect({required this.height, required this.colors});

  final double height;
  final AppPalette colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.destructiveSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colors.secondary),
      ),
    );
  }
}

List<Color> _buildPalette(AppPalette colors) => [
  colors.tertiary,
  colors.secondary,
  colors.primary,
  colors.warning,
  const Color(0xFFFF7F50),
  const Color(0xFF9B59B6),
  const Color(0xFF3498DB),
  const Color(0xFF1ABC9C),
];

IconData _iconForCategory(String category) {
  return switch (category.toLowerCase()) {
    String c
        when c.contains('food') ||
            c.contains('dining') ||
            c.contains('restaurant') =>
      Icons.restaurant_rounded,
    String c
        when c.contains('housing') ||
            c.contains('rent') ||
            c.contains('home') =>
      Icons.home_rounded,
    String c
        when c.contains('transport') ||
            c.contains('travel') ||
            c.contains('car') =>
      Icons.directions_car_rounded,
    String c
        when c.contains('health') ||
            c.contains('medical') ||
            c.contains('gym') =>
      Icons.favorite_rounded,
    String c
        when c.contains('work') || c.contains('tech') || c.contains('office') =>
      Icons.work_rounded,
    String c
        when c.contains('entertain') ||
            c.contains('movie') ||
            c.contains('sub') =>
      Icons.movie_rounded,
    String c
        when c.contains('salary') ||
            c.contains('income') ||
            c.contains('wage') =>
      Icons.account_balance_wallet_rounded,
    String c
        when c.contains('gift') || c.contains('shop') || c.contains('cloth') =>
      Icons.card_giftcard_rounded,
    String c when c.contains('freelance') || c.contains('consult') =>
      Icons.laptop_mac_rounded,
    _ => Icons.receipt_long_rounded,
  };
}
