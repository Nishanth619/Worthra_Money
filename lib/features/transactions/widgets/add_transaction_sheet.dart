import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/theme_extensions.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../models/transaction.dart';
import '../../../state/settings_provider.dart';
import '../../../state/transactions_provider.dart';
import '../data/transaction_categories.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key, this.existingTransaction});

  /// When non-null, the sheet opens in edit mode pre-filled with this data.
  final Transaction? existingTransaction;

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _customCategoryController = TextEditingController();

  bool isExpense = true;
  // Holds the dropdown-selected value (may be customCategoryOption sentinel).
  String _dropdownValue = transactionCategories.first;
  // True when the user picked the custom-category sentinel.
  bool _isCustomCategory = false;

  /// The actual category string to save on the transaction.
  String get _effectiveCategory =>
      _isCustomCategory ? _customCategoryController.text.trim() : _dropdownValue;

  DateTime selectedDate = DateTime.now();

  bool get _isEditMode => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    final tx = widget.existingTransaction;
    if (tx != null) {
      _amountController.text = tx.amount.toStringAsFixed(2);
      _notesController.text = tx.notes ?? '';
      isExpense = tx.isExpense;
      selectedDate = tx.date;
      // If the saved category is in the standard list, select it directly;
      // otherwise pre-fill the custom field.
      if (transactionCategories.contains(tx.category)) {
        _dropdownValue = tx.category;
        _isCustomCategory = false;
      } else {
        _dropdownValue = customCategoryOption;
        _isCustomCategory = true;
        _customCategoryController.text = tx.category;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final transactionState = ref.watch(transactionsControllerProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);

    ref.listen(transactionsControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: colors.surfaceContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                24 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Form(
                key: _formKey,
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
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: colors.surfaceContainerHighest,
                            foregroundColor: colors.textPrimary,
                          ),
                          icon: const Icon(Icons.close_rounded),
                        ),
                        Expanded(
                          child: Text(
                            _isEditMode
                                ? 'Edit transaction'
                                : 'Add transaction',
                            textAlign: TextAlign.center,
                            style: textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Amount',
                      textAlign: TextAlign.center,
                      style: textTheme.labelMedium,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(
                        color: colors.primary,
                      ),
                      decoration: InputDecoration(
                        hintText: '${currencySymbol}0.00',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        final amount = double.tryParse((value ?? '').trim());
                        if (amount == null || amount <= 0) {
                          return 'Enter a valid amount.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
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
                              label: 'Expense',
                              selected: isExpense,
                              onTap: () => setState(() => isExpense = true),
                            ),
                          ),
                          Expanded(
                            child: _TypeChip(
                              label: 'Income',
                              selected: !isExpense,
                              onTap: () => setState(() => isExpense = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // ── Category picker ──────────────────────────────────
                    _SheetDropdownTile(
                      label: 'Category',
                      value: _dropdownValue,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _dropdownValue = value;
                          _isCustomCategory = value == customCategoryOption;
                          if (!_isCustomCategory) {
                            _customCategoryController.clear();
                          }
                        });
                      },
                    ),
                    // ── Custom category text field (shown conditionally) ──
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: _isCustomCategory
                          ? Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: _CustomCategoryField(
                                controller: _customCategoryController,
                                colors: colors,
                                textTheme: textTheme,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 14),
                    _DateTile(selectedDate: selectedDate, onTap: _pickDate),
                    const SizedBox(height: 20),
                    Text('Notes (optional)', style: textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.edit_note_rounded),
                        hintText: 'Add a note',
                      ),
                    ),
                    const SizedBox(height: 28),
                    AppPrimaryButton(
                      label: transactionState.isLoading
                          ? (_isEditMode ? 'Updating...' : 'Saving...')
                          : (_isEditMode
                                ? 'Update transaction'
                                : 'Save transaction'),
                      icon: isExpense
                          ? Icons.check_circle_outline_rounded
                          : Icons.south_west_rounded,
                      onPressed:
                          transactionState.isLoading ? null : _saveTransaction,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    // Extra validation: if custom mode, the field must not be empty.
    if (_isCustomCategory && _customCategoryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a category name.')),
      );
      return;
    }

    final amount = double.parse(_amountController.text.trim());

    if (_isEditMode) {
      // Preserve the original id and serverId for the update.
      final updated = widget.existingTransaction!;
      updated
        ..amount = amount
        ..isExpense = isExpense
        ..category = _effectiveCategory
        ..date = selectedDate
        ..notes = _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim();

      await ref
          .read(transactionsControllerProvider.notifier)
          .updateTransaction(updated);

      if (mounted && !ref.read(transactionsControllerProvider).hasError) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction updated.')),
        );
      }
    } else {
      final transaction = Transaction(
        amount: amount,
        isExpense: isExpense,
        category: _effectiveCategory,
        date: selectedDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await ref
          .read(transactionsControllerProvider.notifier)
          .addTransaction(transaction);

      if (mounted && !ref.read(transactionsControllerProvider).hasError) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction saved.')),
        );
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? colors.navSelectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 6),
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

class _SheetDropdownTile extends StatelessWidget {
  const _SheetDropdownTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.grid_view_rounded,
              color: colors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: value,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: textTheme.labelMedium,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: transactionCategories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        style: cat == customCategoryOption
                            ? textTheme.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w600,
                              )
                            : null,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline text field shown when the user picks the custom-category option.
class _CustomCategoryField extends StatelessWidget {
  const _CustomCategoryField({
    required this.controller,
    required this.colors,
    required this.textTheme,
  });

  final TextEditingController controller;
  final AppPalette colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primarySoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.label_outline_rounded, color: colors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              style: textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'e.g. Gym, Pet care, Streaming',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colors.textMuted,
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.selectedDate, required this.onTap});

  final DateTime selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(_formatDate(selectedDate), style: textTheme.bodyLarge),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
