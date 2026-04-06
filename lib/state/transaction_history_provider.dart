import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/transactions/data/transaction_categories.dart';
import '../models/transaction.dart';
import 'transactions_provider.dart';

enum TransactionTypeFilter { all, income, expense }

class TransactionHistoryFilter {
  const TransactionHistoryFilter({
    this.query = '',
    this.type = TransactionTypeFilter.all,
    this.category,
  });

  final String query;
  final TransactionTypeFilter type;
  final String? category;

  TransactionHistoryFilter copyWith({
    String? query,
    TransactionTypeFilter? type,
    Object? category = _sentinel,
  }) {
    return TransactionHistoryFilter(
      query: query ?? this.query,
      type: type ?? this.type,
      category: identical(category, _sentinel)
          ? this.category
          : category as String?,
    );
  }

  bool get hasActiveFilters =>
      query.trim().isNotEmpty ||
      type != TransactionTypeFilter.all ||
      category != null;

  static const availableCategories = transactionCategories;
}

const _sentinel = Object();

class TransactionHistoryFilterNotifier
    extends Notifier<TransactionHistoryFilter> {
  @override
  TransactionHistoryFilter build() => const TransactionHistoryFilter();

  void update(TransactionHistoryFilter filter) {
    state = filter;
  }

  void clear() {
    state = const TransactionHistoryFilter();
  }
}

final transactionHistoryFilterProvider =
    NotifierProvider<
      TransactionHistoryFilterNotifier,
      TransactionHistoryFilter
    >(TransactionHistoryFilterNotifier.new);

final filteredTransactionsProvider = FutureProvider<List<Transaction>>((
  ref,
) async {
  final transactions = await ref.watch(transactionsProvider.future);
  final filter = ref.watch(transactionHistoryFilterProvider);
  final query = filter.query.trim().toLowerCase();

  return transactions
      .where((transaction) {
        final matchesQuery =
            query.isEmpty ||
            transaction.category.toLowerCase().contains(query) ||
            (transaction.notes?.toLowerCase().contains(query) ?? false);
        final matchesType = switch (filter.type) {
          TransactionTypeFilter.all => true,
          TransactionTypeFilter.income => !transaction.isExpense,
          TransactionTypeFilter.expense => transaction.isExpense,
        };
        final matchesCategory =
            filter.category == null || transaction.category == filter.category;

        return matchesQuery && matchesType && matchesCategory;
      })
      .toList(growable: false);
});
