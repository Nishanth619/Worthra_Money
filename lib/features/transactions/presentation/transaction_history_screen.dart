import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/theme_extensions.dart';
import '../../../core/utils/currency_format.dart';
import '../../../models/transaction.dart' as finance;
import '../../../state/dashboard_state.dart';
import '../../../state/dashboard_summary.dart';
import '../../../state/settings_provider.dart';
import '../../../state/transaction_history_provider.dart';
import '../../../state/transactions_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_view_data.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final summaryAsync = ref.watch(dashboardStateProvider);
    final currencySymbol = ref.watch(currencySymbolProvider);
    final filter = ref.watch(transactionHistoryFilterProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  _HistoryTopBar(
                    hasActiveFilters: filter.hasActiveFilters,
                    onSearchPressed: () => _showSearchDialog(context, ref),
                    onFilterPressed: () => _showFilterSheet(context, ref),
                    onMenuPressed: () => _showActionsSheet(context, ref),
                  ),
                  if (filter.hasActiveFilters) ...[
                    const SizedBox(height: 12),
                    _ActiveFilterBar(
                      filter: filter,
                      onClear: () => ref
                          .read(transactionHistoryFilterProvider.notifier)
                          .clear(),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _MonthlySummaryCard(
                    summaryAsync: summaryAsync,
                    currencySymbol: currencySymbol,
                  ),
                ],
              ),
            ),
          ),
          ...transactionsAsync.when(
            data: (transactions) =>
                _buildTransactionSlivers(
                  context,
                  ref,
                  transactions,
                  currencySymbol,
                ),
            loading: () => const [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
            error: (error, _) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _MessageCard(message: error.toString()),
                ),
              ),
            ],
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  List<Widget> _buildTransactionSlivers(
    BuildContext context,
    WidgetRef ref,
    List<finance.Transaction> transactions,
    String currencySymbol,
  ) {
    final colors = context.appPalette;
    if (transactions.isEmpty) {
      return const [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: _MessageCard(
              message:
                  'No transactions match these filters. Clear them or add a new transaction.',
            ),
          ),
        ),
      ];
    }

    // Build a lookup map from id → raw Transaction for edit access.
    final rawById = <int, finance.Transaction>{
      for (final t in transactions) t.id: t,
    };

    final grouped = <String, List<TransactionViewData>>{};
    for (final transaction in transactions) {
      final viewData = mapTransactionToViewData(transaction);
      grouped.putIfAbsent(viewData.dateGroup, () => []).add(viewData);
    }

    return [
      for (final entry in grouped.entries) ...[
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeaderDelegate(title: entry.key),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              final viewData = entry.value[index];
              final raw = rawById[viewData.id];
              return Dismissible(
                key: ValueKey('transaction-${viewData.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    color: colors.destructiveSoft,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: colors.secondary,
                  ),
                ),
                onDismissed: (_) {
                  ref
                      .read(transactionsControllerProvider.notifier)
                      .deleteTransaction(viewData.id);
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: raw == null
                      ? null
                      : () => _openEditSheet(context, raw),
                  child: TransactionTile(
                    transaction: viewData,
                    currencySymbol: currencySymbol,
                  ),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemCount: entry.value.length,
          ),
        ),
      ],
    ];
  }

  void _openEditSheet(BuildContext context, finance.Transaction transaction) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(existingTransaction: transaction),
    );
  }
}

class _HistoryTopBar extends StatelessWidget {
  const _HistoryTopBar({
    required this.hasActiveFilters,
    required this.onSearchPressed,
    required this.onFilterPressed,
    required this.onMenuPressed,
  });

  final bool hasActiveFilters;
  final VoidCallback onSearchPressed;
  final VoidCallback onFilterPressed;
  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        IconButton(
          onPressed: onMenuPressed,
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainer,
            foregroundColor: colors.textPrimary,
          ),
          icon: const Icon(Icons.more_horiz_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text('Transactions', style: textTheme.headlineMedium),
        ),
        IconButton(
          onPressed: onSearchPressed,
          style: IconButton.styleFrom(
            backgroundColor: colors.surfaceContainer,
            foregroundColor: colors.textPrimary,
          ),
          icon: const Icon(Icons.search_rounded),
        ),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onFilterPressed,
              style: IconButton.styleFrom(
                backgroundColor: colors.surfaceContainer,
                foregroundColor: colors.textPrimary,
              ),
              icon: const Icon(Icons.tune_rounded),
            ),
            if (hasActiveFilters)
              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: colors.primaryContainer,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ActiveFilterBar extends StatelessWidget {
  const _ActiveFilterBar({required this.filter, required this.onClear});

  final TransactionHistoryFilter filter;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final chips = <String>[
      if (filter.query.trim().isNotEmpty) 'Search: ${filter.query.trim()}',
      if (filter.type != TransactionTypeFilter.all) filter.type.name,
      if (filter.category != null) filter.category!,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips
                  .map(
                    (chip) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(chip),
                    ),
                  )
                  .toList(),
            ),
          ),
          TextButton(onPressed: onClear, child: const Text('Clear')),
        ],
      ),
    );
  }
}

class _MonthlySummaryCard extends StatelessWidget {
  const _MonthlySummaryCard({
    required this.summaryAsync,
    required this.currencySymbol,
  });

  final AsyncValue<DashboardSummary> summaryAsync;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colors = context.appPalette;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: summaryAsync.when(
        data: (summary) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spent this month', style: textTheme.labelSmall),
            const SizedBox(height: 10),
            Text(
              formatCurrency(summary.monthlyExpense, symbol: currencySymbol),
              style: textTheme.displayMedium,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _MessageCard(message: error.toString()),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({required this.title});

  final String title;

  @override
  double get minExtent => 52;

  @override
  double get maxExtent => 52;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colors = context.appPalette;
    return Container(
      alignment: Alignment.centerLeft,
      color: colors.background.withValues(alpha: 0.96),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return title != oldDelegate.title;
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({required this.message});

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

Future<void> _showSearchDialog(BuildContext context, WidgetRef ref) async {
  final existing = ref.read(transactionHistoryFilterProvider);
  final controller = TextEditingController(text: existing.query);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Search transactions'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search notes or categories',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(transactionHistoryFilterProvider.notifier)
                  .update(existing.copyWith(query: controller.text));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      );
    },
  );
}

Future<void> _showFilterSheet(BuildContext context, WidgetRef ref) async {
  final colors = context.appPalette;
  final existing = ref.read(transactionHistoryFilterProvider);
  var selectedType = existing.type;
  String? selectedCategory = existing.category;

  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 46,
                      height: 5,
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Filter transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: TransactionTypeFilter.values.map((type) {
                      final selected = type == selectedType;
                      return ChoiceChip(
                        label: Text(type.name),
                        selected: selected,
                        onSelected: (_) =>
                            setModalState(() => selectedType = type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String?>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All categories'),
                      ),
                      ...TransactionHistoryFilter.availableCategories.map(
                        (category) => DropdownMenuItem<String?>(
                          value: category,
                          child: Text(category),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        setModalState(() => selectedCategory = value),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            ref
                                .read(transactionHistoryFilterProvider.notifier)
                                .clear();
                            Navigator.of(sheetContext).pop();
                          },
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            ref
                                .read(transactionHistoryFilterProvider.notifier)
                                .update(
                                  existing.copyWith(
                                    type: selectedType,
                                    category: selectedCategory,
                                  ),
                                );
                            Navigator.of(sheetContext).pop();
                          },
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _showActionsSheet(BuildContext context, WidgetRef ref) async {
  final colors = context.appPalette;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: const Text('Export transactions CSV'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  try {
                    final path = await ref
                        .read(settingsControllerProvider.notifier)
                        .exportTransactionsCsv();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('CSV exported to $path')),
                      );
                    }
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error.toString())));
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.layers_clear_rounded),
                title: const Text('Clear filters'),
                onTap: () {
                  ref.read(transactionHistoryFilterProvider.notifier).clear();
                  Navigator.of(sheetContext).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
