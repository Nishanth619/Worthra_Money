import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../models/goal.dart';
import '../../../state/goals_provider.dart';

// 12 preset icons the user can pick from when creating/editing a goal.
const _kPresetIcons = [
  Icons.savings_rounded,
  Icons.home_rounded,
  Icons.flight_rounded,
  Icons.directions_car_rounded,
  Icons.school_rounded,
  Icons.health_and_safety_rounded,
  Icons.laptop_rounded,
  Icons.beach_access_rounded,
  Icons.diamond_rounded,
  Icons.shopping_bag_rounded,
  Icons.local_fire_department_rounded,
  Icons.crisis_alert_rounded,
];

class AddEditGoalSheet extends ConsumerStatefulWidget {
  const AddEditGoalSheet({
    super.key,
    this.existingGoal,
    this.initialIsStreakChallenge = false,
  });

  /// When non-null the sheet opens in edit mode pre-filled with this goal.
  final Goal? existingGoal;
  final bool initialIsStreakChallenge;

  @override
  ConsumerState<AddEditGoalSheet> createState() => _AddEditGoalSheetState();
}

class _AddEditGoalSheetState extends ConsumerState<AddEditGoalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();

  bool _isStreak = false;
  int _selectedIconCodePoint = _kPresetIcons.first.codePoint;
  DateTime? _deadline;

  bool get _isEditMode => widget.existingGoal != null;

  @override
  void initState() {
    super.initState();
    final g = widget.existingGoal;
    if (g != null) {
      _titleController.text = g.title;
      _targetController.text = g.targetAmount.toStringAsFixed(0);
      _isStreak = g.isStreakChallenge;
      _selectedIconCodePoint = g.iconCodePoint ?? _kPresetIcons.first.codePoint;
      _deadline = g.deadline;
    } else {
      _isStreak = widget.initialIsStreakChallenge;
      _selectedIconCodePoint = _defaultIconCodePoint(_isStreak);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  int _defaultIconCodePoint(bool isStreak) {
    return isStreak
        ? Icons.local_fire_department_rounded.codePoint
        : Icons.savings_rounded.codePoint;
  }

  void _setGoalType(bool isStreak) {
    if (_isStreak == isStreak) return;
    final previousDefault = _defaultIconCodePoint(_isStreak);
    final nextDefault = _defaultIconCodePoint(isStreak);
    setState(() {
      _isStreak = isStreak;
      if (_selectedIconCodePoint == previousDefault) {
        _selectedIconCodePoint = nextDefault;
      }
      if (_isStreak) {
        _deadline = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final controllerState = ref.watch(goalsControllerProvider);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Drag handle ─────────────────────────────
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
                  const SizedBox(height: 20),

                  // ── Title row ───────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isEditMode
                              ? 'Edit goal'
                              : _isStreak
                              ? 'New streak challenge'
                              : 'New goal',
                          style: textTheme.titleLarge,
                        ),
                      ),
                      if (_isEditMode)
                        IconButton(
                          onPressed: controllerState.isLoading
                              ? null
                              : _confirmDelete,
                          style: IconButton.styleFrom(
                            backgroundColor: colors.destructiveSoft,
                            foregroundColor: colors.secondary,
                          ),
                          icon: const Icon(Icons.delete_outline_rounded),
                          tooltip: 'Delete goal',
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Type toggle ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _TypeChip(
                            label: 'Savings',
                            selected: !_isStreak,
                            onTap: () => _setGoalType(false),
                          ),
                        ),
                        Expanded(
                          child: _TypeChip(
                            label: 'Streak',
                            selected: _isStreak,
                            onTap: () => _setGoalType(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Goal name ───────────────────────────────
                  TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Goal name',
                      hintText: _isStreak
                          ? 'e.g. 30-Day No-Spend Challenge'
                          : 'e.g. Emergency Fund',
                      prefixIcon: const Icon(Icons.edit_rounded),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter a goal name.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Target ──────────────────────────────────
                  TextFormField(
                    controller: _targetController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: _isStreak ? 'Target days' : 'Target amount',
                      hintText: _isStreak ? '30' : '10000',
                      prefixIcon: Icon(
                        _isStreak
                            ? Icons.calendar_today_rounded
                            : Icons.attach_money_rounded,
                      ),
                    ),
                    validator: (v) {
                      final n = double.tryParse((v ?? '').trim());
                      if (n == null || n <= 0) {
                        return 'Enter a valid ${_isStreak ? 'number of days' : 'amount'}.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Icon picker ─────────────────────────────
                  Text('Choose an icon', style: textTheme.labelMedium),
                  const SizedBox(height: 12),
                  _IconPicker(
                    selectedCodePoint: _selectedIconCodePoint,
                    onSelected: (cp) =>
                        setState(() => _selectedIconCodePoint = cp),
                  ),

                  // ── Deadline (savings only) ──────────────────
                  if (!_isStreak) ...[
                    const SizedBox(height: 20),
                    _DeadlinePicker(
                      deadline: _deadline,
                      onPick: (dt) => setState(() => _deadline = dt),
                      onClear: () => setState(() => _deadline = null),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // ── Save button ─────────────────────────────
                  AppPrimaryButton(
                    label: controllerState.isLoading
                        ? (_isEditMode ? 'Updating...' : 'Creating...')
                        : (_isEditMode
                              ? 'Update goal'
                              : _isStreak
                              ? 'Create challenge'
                              : 'Create goal'),
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: controllerState.isLoading ? null : _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final target = double.parse(_targetController.text.trim());
    final title = _titleController.text.trim();

    if (_isEditMode) {
      final updated = widget.existingGoal!
        ..title = title
        ..targetAmount = target
        ..isStreakChallenge = _isStreak
        ..iconCodePoint = _selectedIconCodePoint
        ..deadline = _isStreak ? null : _deadline;
      await ref.read(goalsControllerProvider.notifier).updateGoal(updated);
    } else {
      final goal = Goal(
        title: title,
        targetAmount: target,
        currentAmount: 0,
        isStreakChallenge: _isStreak,
        iconCodePoint: _selectedIconCodePoint,
        deadline: _isStreak ? null : _deadline,
      );
      await ref.read(goalsControllerProvider.notifier).addGoal(goal);
    }

    if (mounted && !ref.read(goalsControllerProvider).hasError) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode ? 'Goal updated.' : 'Goal created.',
          ),
        ),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete goal?'),
        content: Text(
          'Delete "${widget.existingGoal!.title}" and remove its saved progress from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.appPalette.secondary,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(goalsControllerProvider.notifier)
          .deleteGoal(widget.existingGoal!.id);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Goal deleted.')));
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  const _TypeChip({
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
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? colors.navSelectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
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
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _IconPicker extends StatelessWidget {
  const _IconPicker({
    required this.selectedCodePoint,
    required this.onSelected,
  });

  final int selectedCodePoint;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _kPresetIcons.map((icon) {
        final isSelected = icon.codePoint == selectedCodePoint;
        return GestureDetector(
          onTap: () => onSelected(icon.codePoint),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colors.primary : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? colors.onPrimary : colors.textSecondary,
              size: 24,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DeadlinePicker extends StatelessWidget {
  const _DeadlinePicker({
    required this.deadline,
    required this.onPick,
    required this.onClear,
  });

  final DateTime? deadline;
  final ValueChanged<DateTime> onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: deadline ?? DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.event_rounded, color: colors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Target Date (optional)', style: textTheme.labelMedium),
                  const SizedBox(height: 2),
                  Text(
                    deadline == null
                        ? 'No deadline set'
                        : _formatDate(deadline!),
                    style: textTheme.bodyMedium?.copyWith(
                      color: deadline == null
                          ? colors.textMuted
                          : colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (deadline != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  color: colors.textMuted,
                  size: 20,
                ),
              )
            else
              Icon(Icons.chevron_right_rounded, color: colors.textMuted),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
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
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
