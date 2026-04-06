import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../models/transaction.dart' as finance;
import '../../../state/auth_provider.dart';
import '../../../state/dashboard_state.dart';
import '../../../state/dashboard_summary.dart';
import '../../../state/settings_provider.dart';
import '../../../state/transactions_provider.dart';
import '../../transactions/presentation/transaction_view_data.dart';
import '../../transactions/widgets/transaction_tile.dart';

/// Exposes the auth user's display name or drops back to local settings.
final authUserNameProvider = Provider<String?>((ref) {
  final localName = ref.watch(settingsProvider).maybeWhen(
        data: (s) => s.localUserName,
        orElse: () => null,
      );
  return ref.watch(authControllerProvider).maybeWhen(
        data: (user) => user?.name ?? localName,
        orElse: () => localName,
      );
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    required this.onAvatarTap,
    required this.onViewAllTap,
    required this.onStatusTap,
    super.key,
  });

  final VoidCallback onAvatarTap;
  final VoidCallback onViewAllTap;
  final VoidCallback onStatusTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final dashboardSummary = ref.watch(dashboardStateProvider);
    final transactionsAsync = ref.watch(transactionsProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final l10n = context.l10n;

    // authUserNameProvider is a plain Provider<String> - read it directly.
    final userName = ref.watch(authUserNameProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(l10n.appBrandName, style: textTheme.titleLarge),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onStatusTap,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceContainer,
                  foregroundColor: colors.primary,
                ),
                icon: const Icon(Icons.notifications_none_rounded),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onAvatarTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [colors.primary, colors.primaryContainer],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (userName ?? l10n.guestUserName).substring(0, 1).toUpperCase(),
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            l10n.dashboardGreeting(userName ?? l10n.guestUserName),
            style: textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.dashboardSubtitle, style: textTheme.bodyMedium),
          const SizedBox(height: 24),
          _BalanceCard(
            summary: dashboardSummary,
            currencySymbol: currencySymbol,
          ),
          const SizedBox(height: 24),
          _TrendCard(
            transactionsAsync: transactionsAsync,
            currencySymbol: currencySymbol,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(l10n.recentTransactionsLabel, style: textTheme.titleLarge),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onViewAllTap,
                child: Text(l10n.viewAllButton),
              ),
            ],
          ),
          const SizedBox(height: 12),
          transactionsAsync.when(
            data: (transactions) {
              final recent = transactions.take(4).toList();
              if (recent.isEmpty) {
                return _EmptyStateCard(message: l10n.emptyDashboardMessage);
              }

              return Column(
                children: recent
                    .map(
                      (transaction) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TransactionTile(
                          transaction: mapTransactionToViewData(transaction),
                          currencySymbol: currencySymbol,
                          compact: true,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const _LoadingCard(),
            error: (error, _) => _ErrorCard(message: error.toString()),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Balance Card
// ─────────────────────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.summary, required this.currencySymbol});

  final AsyncValue<DashboardSummary> summary;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: summary.when(
        data: (value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.currentBalanceLabel, style: textTheme.labelSmall),
            const SizedBox(height: 12),
            Text(
              formatCurrency(value.currentBalance, symbol: currencySymbol),
              style: textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: colors.surfaceContainerHighest),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _BalanceStat(
                    label: l10n.monthlyIncomeLabel,
                    value: formatCurrency(
                      value.monthlyIncome,
                      symbol: currencySymbol,
                    ),
                    color: colors.primary,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BalanceStat(
                    label: l10n.monthlyExpensesLabel,
                    value: formatCurrency(
                      value.monthlyExpense,
                      symbol: currencySymbol,
                    ),
                    color: colors.secondary,
                    icon: Icons.arrow_downward_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => const _LoadingCard(compact: true),
        error: (error, _) => _ErrorCard(message: error.toString()),
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  const _BalanceStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: textTheme.labelSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: textTheme.titleLarge?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trend Card — animated bar chart
// ─────────────────────────────────────────────────────────────────────────────

class _TrendCard extends StatelessWidget {
  const _TrendCard({
    required this.transactionsAsync,
    required this.currencySymbol,
  });

  final AsyncValue<List<finance.Transaction>> transactionsAsync;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appPalette;
    final l10n = context.l10n;

    // Compute real expenditure totals per day (absolute amounts, not normalised).
    final rawPoints = transactionsAsync.maybeWhen(
      data: _weeklyExpenseRaw,
      orElse: () => List<double>.filled(7, 0),
    );

    // Build labels for the last 7 days ending TODAY.
    // Dart weekday: 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat, 7=Sun.
    final _allDayLabels = [
      l10n.dayMon, l10n.dayTue, l10n.dayWed, l10n.dayThu,
      l10n.dayFri, l10n.daySat, l10n.daySun,
    ];
    final now = DateTime.now();
    final dayLabels = List.generate(7, (i) {
      final date = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      return _allDayLabels[date.weekday - 1]; // weekday 1=Mon → index 0
    });

    // Normalise to [0, 1] range for bar heights.
    final maxVal = rawPoints.fold<double>(0, (m, v) => v > m ? v : m);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.weeklySpendingTrendLabel, style: textTheme.titleLarge),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                l10n.last7DaysLabel,
                style: textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _AnimatedBarChart(
            rawPoints: rawPoints,
            maxVal: maxVal,
            dayLabels: dayLabels,
            currencySymbol: currencySymbol,
          ),
        ),
      ],
    );
  }
}

/// Widget that owns the animation and re-renders whenever data or theme changes.
class _AnimatedBarChart extends StatefulWidget {
  const _AnimatedBarChart({
    required this.rawPoints,
    required this.maxVal,
    required this.dayLabels,
    required this.currencySymbol,
  });

  final List<double> rawPoints;
  final double maxVal;
  final List<String> dayLabels;
  final String currencySymbol;

  @override
  State<_AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<_AnimatedBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_AnimatedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-animate whenever the underlying data changes (deep equality check).
    if (!listEquals(oldWidget.rawPoints, widget.rawPoints)) {
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;


    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(widget.rawPoints.length, (i) {
                  final normalised = widget.maxVal == 0
                      ? 0.15
                      : (widget.rawPoints[i] / widget.maxVal).clamp(0.05, 1.0);
                  final isToday = i == 6;
                  final hasAmount = widget.rawPoints[i] > 0;

                  // Today → full primary; others → primary at 28% opacity
                  final barColor = isToday
                      ? colors.primary
                      : colors.primary.withValues(alpha: 0.28);

                  // Tooltip badge color: today→primary, others→lighter primary
                  final badgeColor = isToday
                      ? colors.primary
                      : colors.primary.withValues(alpha: 0.60);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Amount tooltip above every bar that has spending
                          if (hasAmount) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                formatCurrency(
                                  widget.rawPoints[i],
                                  symbol: widget.currencySymbol,
                                  compact: true,
                                ),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimary,
                                  fontSize: 8,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          // Bar
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Container(
                              height: 110 * normalised * _anim.value,
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            // Day labels
            Row(
              children: List.generate(widget.dayLabels.length, (i) {
                final isToday = i == 6;
                return Expanded(
                  child: Text(
                    widget.dayLabels[i],
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall?.copyWith(
                      color: isToday ? colors.primary : colors.textMuted,
                      fontWeight:
                          isToday ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 18 : 20),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator()),
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.destructiveSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Returns raw expense totals (in currency units) for each of the last 7 days,
/// ordered Mon … Sun relative to today.
List<double> _weeklyExpenseRaw(List<finance.Transaction> transactions) {
  final now = DateTime.now();
  final points = List<double>.filled(7, 0);

  for (var offset = 0; offset < 7; offset++) {
    final date = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: 6 - offset));
    final nextDate = date.add(const Duration(days: 1));
    points[offset] = transactions
        .where(
          (t) =>
              t.isExpense &&
              t.date.isAfter(date.subtract(const Duration(microseconds: 1))) &&
              t.date.isBefore(nextDate),
        )
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  return points;
}
