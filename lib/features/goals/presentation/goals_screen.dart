import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/currency_format.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../models/goal.dart';
import '../../../state/goals_provider.dart';
import '../../../state/settings_provider.dart';
import '../widgets/add_edit_goal_sheet.dart';
import '../widgets/streak_ring.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

IconData _iconForGoal(Goal goal) {
  if (goal.iconCodePoint != null) {
    return _iconFromCodePoint(goal.iconCodePoint!);
  }
  final t = goal.title.toLowerCase();
  if (t.contains('travel') || t.contains('trip') || t.contains('flight')) {
    return Icons.flight_rounded;
  }
  if (t.contains('car') || t.contains('vehicle')) {
    return Icons.directions_car_rounded;
  }
  if (t.contains('home') || t.contains('house') || t.contains('rent')) {
    return Icons.home_rounded;
  }
  if (t.contains('school') || t.contains('education')) {
    return Icons.school_rounded;
  }
  if (t.contains('health') || t.contains('medical')) {
    return Icons.health_and_safety_rounded;
  }
  if (t.contains('laptop') || t.contains('tech') || t.contains('phone')) {
    return Icons.laptop_rounded;
  }
  if (t.contains('emergency')) {
    return Icons.crisis_alert_rounded;
  }
  if (t.contains('wedding') || t.contains('diamond')) {
    return Icons.diamond_rounded;
  }
  if (t.contains('coffee') ||
      t.contains('no spend') ||
      t.contains('no-spend')) {
    return Icons.coffee_rounded;
  }
  return goal.isStreakChallenge
      ? Icons.local_fire_department_rounded
      : Icons.savings_rounded;
}

IconData _iconFromCodePoint(int codePoint) {
  return switch (codePoint) {
    0xf0128 => Icons.savings_rounded,
    0xf7f5 => Icons.home_rounded,
    0xf772 => Icons.flight_rounded,
    0xf6b3 => Icons.directions_car_rounded,
    0xf012e => Icons.school_rounded,
    0xf7df => Icons.health_and_safety_rounded,
    0xf842 => Icons.laptop_rounded,
    0xf5b3 => Icons.beach_access_rounded,
    0xf0306 => Icons.diamond_rounded,
    0xf016f => Icons.shopping_bag_rounded,
    0xf86b => Icons.local_fire_department_rounded,
    0xf07ec => Icons.crisis_alert_rounded,
    _ => Icons.savings_rounded,
  };
}

double _computeScore(List<Goal> goals) {
  if (goals.isEmpty) {
    return 0;
  }
  return (goals.fold<double>(0, (s, g) => s + g.progress) / goals.length * 100)
      .clamp(0, 100);
}

String _scoreTier(double s) => s >= 80
    ? 'Elite'
    : s >= 60
    ? 'Consistent'
    : s >= 30
    ? 'Building'
    : 'Beginner';
IconData _scoreTierIcon(double s) => s >= 80
    ? Icons.emoji_events_rounded
    : s >= 60
    ? Icons.military_tech_rounded
    : s >= 30
    ? Icons.trending_up_rounded
    : Icons.flag_rounded;
Color _scoreTierColor(double s, AppPalette c) => s >= 80
    ? c.warning
    : s >= 60
    ? c.primary
    : s >= 30
    ? c.tertiary
    : c.textMuted;

String _fmtDate(DateTime dt) {
  const m = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${m[dt.month - 1]} ${dt.day}, ${dt.year}';
}

int _daysUntil(DateTime dt) => DateTime(dt.year, dt.month, dt.day)
    .difference(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    )
    .inDays;

void _openAddSheet(BuildContext ctx, {bool initialIsStreakChallenge = false}) =>
    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AddEditGoalSheet(initialIsStreakChallenge: initialIsStreakChallenge),
    );
void _openEditSheet(BuildContext ctx, Goal g) => showModalBottomSheet<void>(
  context: ctx,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) => AddEditGoalSheet(existingGoal: g),
);
void _openDetailSheet(BuildContext ctx, Goal g, String sym) =>
    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GoalDetailSheet(goal: g, currencySymbol: sym),
    );

Future<void> _logStreakDay(
  BuildContext context,
  WidgetRef ref,
  Goal goal,
) async {
  if (goal.loggedToday) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Today is already logged. Come back tomorrow.'),
      ),
    );
    return;
  }
  final broke = !goal.isStreakAlive && goal.currentAmount > 0;
  final newAmt = broke
      ? 1.0
      : (goal.currentAmount + 1).clamp(0, goal.targetAmount).toDouble();
  goal
    ..currentAmount = newAmt
    ..lastLoggedDate = DateTime.now();
  await ref.read(goalsControllerProvider.notifier).updateGoal(goal);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          broke
              ? 'Streak restarted. Day 1 logged.'
              : 'Day ${newAmt.toInt()} logged.',
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Root Screen — unified scrollable layout, no tabs
// ─────────────────────────────────────────────────────────────────────────────
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGoals = ref.watch(allGoalsProvider);
    final savings = ref.watch(savingsGoalsProvider);
    final streaks = ref.watch(streakGoalsProvider);
    final sym = ref.watch(currencySymbolProvider);
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appPalette;

    ref.listen(goalsControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString()))),
      );
    });

    Future<void> logStreak(Goal g) => _logStreakDay(context, ref, g);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          // ── Page header ──────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.goalsHeaderTracker,
                style: textTheme.labelMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.goalsHeaderTitle,
                style: textTheme.displayMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.goalsHeaderSubtitle,
                style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Main body ────────────────────────────────────────────────────
          allGoals.when(
            loading: _buildShimmer,
            error: (e, _) => _ErrorCard(message: e.toString()),
            data: (goals) {
              if (goals.isEmpty) {
                return _OnboardingCard(onAdd: () => _openAddSheet(context));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat chips row
                  _SummaryRow(goals: goals),
                  const SizedBox(height: 16),

                  // Discipline score card
                  _DisciplineScoreCard(goals: goals),
                  const SizedBox(height: 28),

                  // ── Savings goals ─────────────────────────────────────
                  _SectionHeader(
                    title: context.l10n.goalsSectionSavings,
                    icon: Icons.savings_rounded,
                    onAdd: () => _openAddSheet(context),
                  ),
                  const SizedBox(height: 14),
                  savings.when(
                    loading: () => const _ShimmerRect(height: 180),
                    error: (e, _) => _ErrorCard(message: e.toString()),
                    data: (items) => items.isEmpty
                        ? _EmptyMiniState(
                            icon: Icons.savings_rounded,
                            label:
                                'No savings goals yet. Tap Add to create one.',
                          )
                        : _SavingsGrid(
                            goals: items,
                            currencySymbol: sym,
                            context: context,
                          ),
                  ),
                  const SizedBox(height: 28),

                  // ── Streak challenges ─────────────────────────────────
                  _SectionHeader(
                    title: context.l10n.goalsSectionStreaks,
                    icon: Icons.local_fire_department_rounded,
                    onAdd: () =>
                        _openAddSheet(context, initialIsStreakChallenge: true),
                  ),
                  const SizedBox(height: 14),
                  streaks.when(
                    loading: () => const _ShimmerRect(height: 140),
                    error: (e, _) => _ErrorCard(message: e.toString()),
                    data: (items) => items.isEmpty
                        ? _EmptyMiniState(
                            icon: Icons.local_fire_department_rounded,
                            label:
                                'No streak challenges yet. Start your first habit.',
                          )
                        : Column(
                            children: List.generate(
                              items.length,
                              (i) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: i < items.length - 1 ? 14 : 0,
                                ),
                                child: _StreakCard(
                                  goal: items[i],
                                  onLogDay: () => logStreak(items[i]),
                                  onTap: () =>
                                      _openDetailSheet(context, items[i], sym),
                                  onEdit: () =>
                                      _openEditSheet(context, items[i]),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() => Column(
    children: [
      Row(
        children: [
          Expanded(child: _ShimmerRect(height: 80)),
          const SizedBox(width: 12),
          Expanded(child: _ShimmerRect(height: 80)),
          const SizedBox(width: 12),
          Expanded(child: _ShimmerRect(height: 80)),
        ],
      ),
      const SizedBox(height: 16),
      const _ShimmerRect(height: 110),
      const SizedBox(height: 28),
      const _ShimmerRect(height: 200),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Savings 2-column grid
// ─────────────────────────────────────────────────────────────────────────────
class _SavingsGrid extends StatelessWidget {
  const _SavingsGrid({
    required this.goals,
    required this.currencySymbol,
    required this.context,
  });
  final List<Goal> goals;
  final String currencySymbol;
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    final rows = <Widget>[];
    for (var i = 0; i < goals.length; i += 2) {
      if (rows.isNotEmpty) {
        rows.add(const SizedBox(height: 14));
      }
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _SavingsCard(
                  goal: goals[i],
                  currencySymbol: currencySymbol,
                  onTap: () =>
                      _openDetailSheet(context, goals[i], currencySymbol),
                  onEdit: () => _openEditSheet(context, goals[i]),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: i + 1 < goals.length
                    ? _SavingsCard(
                        goal: goals[i + 1],
                        currencySymbol: currencySymbol,
                        onTap: () => _openDetailSheet(
                          context,
                          goals[i + 1],
                          currencySymbol,
                        ),
                        onEdit: () => _openEditSheet(context, goals[i + 1]),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Onboarding card (zero-goals state)
// ─────────────────────────────────────────────────────────────────────────────
class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceContainer, colors.surfaceContainerLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
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
              Icons.track_changes_rounded,
              size: 40,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Start your first goal',
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create savings goals and streak challenges to build better habits.',
            style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _FeatureRow(
            icon: Icons.savings_rounded,
            color: colors.primary,
            label: 'Set a target amount and optional deadline',
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.local_fire_department_rounded,
            color: colors.warning,
            label: 'Build daily streaks and track your progress',
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.bar_chart_rounded,
            color: colors.tertiary,
            label: 'Track your progress and build momentum',
          ),
          const SizedBox(height: 28),
          AppPrimaryButton(
            label: 'Create first goal',
            icon: Icons.add_rounded,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.label,
  });
  final IconData icon;
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary chips row
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.goals});
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final completed = goals.where((g) => g.isCompleted).length;
    final activeStreaks = goals
        .where((g) => g.isStreakChallenge && g.isStreakAlive)
        .length;
    return Row(
      children: [
        Expanded(
          child: _StatChip(
            label: 'Total Goals',
            value: '${goals.length}',
            icon: Icons.track_changes_rounded,
            color: colors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            label: 'Completed',
            value: '$completed',
            icon: Icons.check_circle_rounded,
            color: colors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatChip(
            label: 'Active Streaks',
            value: '$activeStreaks',
            icon: Icons.local_fire_department_rounded,
            color: colors.warning,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(color: colors.textMuted),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Discipline score card
// ─────────────────────────────────────────────────────────────────────────────
class _DisciplineScoreCard extends StatelessWidget {
  const _DisciplineScoreCard({required this.goals});
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final score = _computeScore(goals);
    final tier = _scoreTier(score);
    final tierIcon = _scoreTierIcon(score);
    final tierColor = _scoreTierColor(score, colors);
    final completed = goals.where((g) => g.isCompleted).length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.surfaceContainer, colors.surfaceContainerLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: tierColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 5,
                  backgroundColor: colors.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(tierColor),
                  strokeCap: StrokeCap.round,
                ),
                Icon(tierIcon, color: tierColor, size: 22),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      tier,
                      style: textTheme.titleMedium?.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${score.toStringAsFixed(0)}%',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: score / 100),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (_, v, child) => ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      backgroundColor: colors.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(tierColor),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$completed of ${goals.length} goals completed',
                  style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.onAdd,
  });
  final String title;
  final IconData icon;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primarySoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: textTheme.titleLarge)),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: const Text('Add'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Savings goal card (2-column grid item)
// ─────────────────────────────────────────────────────────────────────────────
class _SavingsCard extends StatelessWidget {
  const _SavingsCard({
    required this.goal,
    required this.currencySymbol,
    required this.onTap,
    required this.onEdit,
  });
  final Goal goal;
  final String currencySymbol;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final progress = goal.progress;
    final icon = _iconForGoal(goal);
    final done = goal.isCompleted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: done
              ? Border.all(
                  color: colors.success.withValues(alpha: 0.4),
                  width: 1.5,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: done
                        ? colors.success.withValues(alpha: 0.15)
                        : colors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    done ? Icons.check_circle_rounded : icon,
                    color: done ? colors.success : colors.primary,
                    size: 20,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              goal.title,
              style: textTheme.titleSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (goal.deadline != null) ...[
              const SizedBox(height: 4),
              _DeadlineBadge(deadline: goal.deadline!),
            ],
            const SizedBox(height: 14),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (_, v, child) => ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: v,
                  minHeight: 6,
                  backgroundColor: colors.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(
                    done ? colors.success : colors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatCurrency(
                      goal.currentAmount,
                      symbol: currencySymbol,
                      compact: true,
                    ),
                    style: textTheme.titleSmall?.copyWith(
                      color: done ? colors.success : colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
            Text(
              'of ${formatCurrency(goal.targetAmount, symbol: currencySymbol, compact: true)}',
              style: textTheme.bodySmall?.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak challenge card (compact horizontal layout)
// ─────────────────────────────────────────────────────────────────────────────
class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.goal,
    required this.onLogDay,
    required this.onTap,
    required this.onEdit,
  });
  final Goal goal;
  final VoidCallback onLogDay;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final done = goal.isCompleted;
    final loggedToday = goal.loggedToday;
    final isAlive = goal.isStreakAlive;
    final neverStarted = goal.lastLoggedDate == null && goal.currentAmount == 0;

    final statusLabel = done
        ? context.l10n.goalStatusCompleted
        : loggedToday
        ? context.l10n.goalStatusDoneToday
        : isAlive
        ? context.l10n.goalStatusActive
        : neverStarted
        ? context.l10n.goalStatusNotStarted
        : context.l10n.goalStatusBroken;
    final statusColor = done || loggedToday
        ? colors.success
        : isAlive
        ? colors.warning
        : neverStarted
        ? colors.textMuted
        : colors.secondary;
    final ringColor = done
        ? colors.success
        : isAlive
        ? colors.warning
        : !neverStarted
        ? colors.secondary
        : colors.primary;
    final actionLabel = loggedToday
        ? 'Logged today'
        : !isAlive && !neverStarted
        ? 'Restart streak'
        : 'Log today';
    final progressText =
        '${goal.currentAmount.toInt()} / ${goal.targetAmount.toInt()} ${context.l10n.goalLabelDays}';
    final ring = StreakRing(
      progress: goal.progress,
      size: 118,
      strokeWidth: 10,
      centerLabel: '${goal.currentAmount.toInt()}',
      bottomLabel: context.l10n.goalLabelDays,
      progressColor: ringColor,
      shadowColor: ringColor.withValues(alpha: 0.18),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: !isAlive && !neverStarted && !done
              ? Border.all(
                  color: colors.secondary.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : done
              ? Border.all(
                  color: colors.success.withValues(alpha: 0.4),
                  width: 1.5,
                )
              : null,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stackLayout = constraints.maxWidth < 360;

            final titleRow = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: colors.textMuted,
                    ),
                  ),
                ),
              ],
            );

            final detailsBody = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  progressText,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (loggedToday || done) ? null : onLogDay,
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          !isAlive && !neverStarted && !loggedToday && !done
                          ? colors.secondary
                          : colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      actionLabel,
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            );

            if (stackLayout) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleRow,
                  const SizedBox(height: 18),
                  Center(child: ring),
                  const SizedBox(height: 18),
                  detailsBody,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ring,
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleRow,
                      const SizedBox(height: 10),
                      detailsBody,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty section mini-state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyMiniState extends StatelessWidget {
  const _EmptyMiniState({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: colors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Goal detail sheet
// ─────────────────────────────────────────────────────────────────────────────
class _GoalDetailSheet extends ConsumerStatefulWidget {
  const _GoalDetailSheet({required this.goal, required this.currencySymbol});
  final Goal goal;
  final String currencySymbol;
  @override
  ConsumerState<_GoalDetailSheet> createState() => _GoalDetailSheetState();
}

class _GoalDetailSheetState extends ConsumerState<_GoalDetailSheet> {
  final _fundsCtrl = TextEditingController();
  @override
  void dispose() {
    _fundsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final goal = widget.goal;
    final progress = goal.progress;
    final remaining = (goal.targetAmount - goal.currentAmount).clamp(
      0,
      double.infinity,
    );
    final icon = _iconForGoal(goal);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.primarySoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(icon, color: colors.primary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: textTheme.titleLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            goal.isStreakChallenge
                                ? 'Streak challenge'
                                : 'Savings goal',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, child) => CustomPaint(
                            painter: _ArcPainter(
                              progress: v,
                              colors: colors,
                              isComplete: goal.isCompleted,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Complete',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _DetailRow(
                  label: goal.isStreakChallenge
                      ? 'Current streak'
                      : 'Saved so far',
                  value: goal.isStreakChallenge
                      ? '${goal.currentAmount.toInt()} days'
                      : formatCurrency(
                          goal.currentAmount,
                          symbol: widget.currencySymbol,
                        ),
                ),
                _DetailRow(
                  label: goal.isStreakChallenge
                      ? 'Target streak'
                      : 'Target amount',
                  value: goal.isStreakChallenge
                      ? '${goal.targetAmount.toInt()} days'
                      : formatCurrency(
                          goal.targetAmount,
                          symbol: widget.currencySymbol,
                        ),
                ),
                _DetailRow(
                  label: 'Remaining',
                  value: goal.isStreakChallenge
                      ? '${remaining.toInt()} days'
                      : formatCurrency(
                          remaining.toDouble(),
                          symbol: widget.currencySymbol,
                        ),
                  accent: true,
                ),
                if (goal.deadline != null)
                  _DetailRow(
                    label: 'Target date',
                    value:
                        '${_fmtDate(goal.deadline!)} (${_daysUntil(goal.deadline!)} days left)',
                  ),
                if (goal.isStreakChallenge && goal.lastLoggedDate != null)
                  _DetailRow(
                    label: 'Last check-in',
                    value: _fmtDate(goal.lastLoggedDate!),
                  ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                if (!goal.isCompleted) ...[
                  if (goal.isStreakChallenge)
                    AppPrimaryButton(
                      label: goal.loggedToday
                          ? 'Logged today'
                          : 'Log today',
                      icon: goal.loggedToday
                          ? Icons.check_rounded
                          : Icons.add_rounded,
                      onPressed: goal.loggedToday
                          ? null
                          : () => _logDay(context),
                    )
                  else
                    _AddFundsInline(
                      goal: goal,
                      currencySymbol: widget.currencySymbol,
                      onDone: () => Navigator.of(context).pop(),
                    ),
                  const SizedBox(height: 12),
                ],
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _openEditSheet(context, goal);
                  },
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('Edit goal'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _logDay(BuildContext context) async {
    final goal = widget.goal;
    if (goal.loggedToday) {
      return;
    }
    final broke = !goal.isStreakAlive && goal.currentAmount > 0;
    final newAmt = broke
        ? 1.0
        : (goal.currentAmount + 1).clamp(0, goal.targetAmount).toDouble();
    goal
      ..currentAmount = newAmt
      ..lastLoggedDate = DateTime.now();
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(goalsControllerProvider.notifier).updateGoal(goal);
    if (mounted) {
      nav.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            broke
                ? 'Streak restarted. Day 1 logged.'
                : 'Day ${newAmt.toInt()} logged.',
          ),
        ),
      );
    }
  }
}

class _AddFundsInline extends ConsumerStatefulWidget {
  const _AddFundsInline({
    required this.goal,
    required this.currencySymbol,
    required this.onDone,
  });
  final Goal goal;
  final String currencySymbol;
  final VoidCallback onDone;
  @override
  ConsumerState<_AddFundsInline> createState() => _AddFundsInlineState();
}

class _AddFundsInlineState extends ConsumerState<_AddFundsInline> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Add funds', style: textTheme.labelMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: '${widget.currencySymbol}0.00',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: _loading ? null : _addFunds,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _loading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.onPrimary,
                      ),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addFunds() async {
    final amount = double.tryParse(_ctrl.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid amount.')));
      return;
    }
    setState(() => _loading = true);
    final goal = widget.goal;
    final next = (goal.currentAmount + amount)
        .clamp(0, goal.targetAmount)
        .toDouble();
    await ref
        .read(goalsControllerProvider.notifier)
        .updateGoalProgress(goal.id, next);
    if (mounted) {
      setState(() => _loading = false);
      widget.onDone();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            next >= goal.targetAmount
                ? 'Goal completed.'
                : '${formatCurrency(amount, symbol: widget.currencySymbol)} added.',
          ),
        ),
      );
    }
  }
}

// Shared small widgets
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.accent = false,
  });
  final String label;
  final String value;
  final bool accent;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
            ),
          ),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              color: accent ? colors.primary : colors.textPrimary,
              fontWeight: accent ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeadlineBadge extends StatelessWidget {
  const _DeadlineBadge({required this.deadline});
  final DateTime deadline;
  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final d = _daysUntil(deadline);
    final color = d < 0
        ? colors.secondary
        : d <= 7
        ? colors.warning
        : colors.textMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.event_rounded, size: 11, color: color),
        const SizedBox(width: 3),
        Text(
          d < 0
              ? 'Overdue'
              : d == 0
              ? 'Due today'
              : '$d days left',
          style: textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appPalette.destructiveSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    ),
  );
}

class _ShimmerRect extends StatelessWidget {
  const _ShimmerRect({required this.height});
  final double height;
  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: context.appPalette.surfaceContainerLow,
      borderRadius: BorderRadius.circular(24),
    ),
  );
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.colors,
    required this.isComplete,
  });
  final double progress;
  final AppPalette colors;
  final bool isComplete;
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = colors.surfaceContainerHighest
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..shader = LinearGradient(
          colors: isComplete
              ? [colors.success, colors.success.withValues(alpha: 0.7)]
              : [colors.primary, colors.primaryContainer],
        ).createShader(Rect.fromCircle(center: c, radius: r))
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) =>
      old.progress != progress || old.isComplete != isComplete;
}
