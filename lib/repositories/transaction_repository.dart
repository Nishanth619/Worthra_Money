import 'package:isar_community/isar.dart';

import '../models/transaction.dart';
import 'category_insight.dart';
import 'repository_exception.dart';

abstract class ITransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Future<void> addTransactions(Iterable<Transaction> transactions);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(int id);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<double> getBalanceForDateRange(DateTime start, DateTime end);
  Future<double> getIncomeForDateRange(DateTime start, DateTime end);
  Future<double> getExpenseForDateRange(DateTime start, DateTime end);
  Future<List<CategoryInsight>> getCategoryInsightsByDateRange(
    DateTime start,
    DateTime end,
  );
  Future<double> getTotalBalance();
  Future<double> getTotalIncome();
  Future<double> getTotalExpense();
  Future<List<CategoryInsight>> getCategoryInsights();
  Stream<void> watchTransactions();
}

class TransactionRepository implements ITransactionRepository {
  TransactionRepository(this._isar);

  final Isar _isar;

  IsarCollection<Transaction> get _transactions => _isar.transactions;

  @override
  Future<void> addTransaction(Transaction transaction) async {
    try {
      _sanitizeAndValidateTransaction(transaction);
      await _isar.writeTxn(() async {
        await _transactions.put(transaction);
      });
    } catch (error) {
      throw RepositoryException('Failed to add transaction.', error);
    }
  }

  @override
  Future<void> addTransactions(Iterable<Transaction> transactions) async {
    try {
      final items = transactions.toList(growable: false);
      if (items.isEmpty) {
        return;
      }

      for (final transaction in items) {
        _sanitizeAndValidateTransaction(transaction);
      }

      await _isar.writeTxn(() async {
        await _transactions.putAll(items);
      });
    } catch (error) {
      throw RepositoryException('Failed to add transactions.', error);
    }
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      _sanitizeAndValidateTransaction(transaction);
      // Mark as unsynced so the sync engine re-pushes the updated record.
      transaction.syncedAt = null;
      await _isar.writeTxn(() async {
        await _transactions.put(transaction);
      });
    } catch (error) {
      throw RepositoryException(
          'Failed to update transaction ${transaction.id}.', error);
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _transactions.delete(id);
      });
    } catch (error) {
      throw RepositoryException('Failed to delete transaction $id.', error);
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    try {
      return _transactions.where().sortByDateDesc().findAll();
    } catch (error) {
      throw RepositoryException('Failed to load transactions.', error);
    }
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return _transactions
          .filter()
          .dateBetween(start, end, includeLower: true, includeUpper: true)
          .sortByDateDesc()
          .findAll();
    } catch (error) {
      throw RepositoryException(
        'Failed to load transactions for the selected range.',
        error,
      );
    }
  }

  @override
  Future<double> getTotalBalance() async {
    try {
      final (start, end) = _currentMonthBounds();
      return getBalanceForDateRange(start, end);
    } catch (error) {
      throw RepositoryException('Failed to calculate total balance.', error);
    }
  }

  @override
  Future<double> getTotalIncome() async {
    try {
      final (start, end) = _currentMonthBounds();
      return getIncomeForDateRange(start, end);
    } catch (error) {
      throw RepositoryException('Failed to calculate total income.', error);
    }
  }

  @override
  Future<double> getTotalExpense() async {
    try {
      final (start, end) = _currentMonthBounds();
      return getExpenseForDateRange(start, end);
    } catch (error) {
      throw RepositoryException('Failed to calculate total expense.', error);
    }
  }

  @override
  Future<List<CategoryInsight>> getCategoryInsights() async {
    try {
      final (start, end) = _currentMonthBounds();
      return getCategoryInsightsByDateRange(start, end);
    } catch (error) {
      throw RepositoryException(
        'Failed to calculate category insights.',
        error,
      );
    }
  }

  @override
  Stream<void> watchTransactions() {
    return _transactions.watchLazy(fireImmediately: true);
  }

  @override
  Future<double> getBalanceForDateRange(DateTime start, DateTime end) async {
    try {
      final transactions = await getTransactionsByDateRange(start, end);
      return transactions.fold<double>(
        0,
        (total, transaction) => transaction.isExpense
            ? total - transaction.amount
            : total + transaction.amount,
      );
    } catch (error) {
      throw RepositoryException(
        'Failed to calculate balance for range.',
        error,
      );
    }
  }

  @override
  Future<double> getIncomeForDateRange(DateTime start, DateTime end) async {
    try {
      final transactions = await getTransactionsByDateRange(start, end);
      return transactions
          .where((transaction) => !transaction.isExpense)
          .fold<double>(0, (total, transaction) => total + transaction.amount);
    } catch (error) {
      throw RepositoryException('Failed to calculate income for range.', error);
    }
  }

  @override
  Future<double> getExpenseForDateRange(DateTime start, DateTime end) async {
    try {
      final transactions = await getTransactionsByDateRange(start, end);
      return transactions
          .where((transaction) => transaction.isExpense)
          .fold<double>(0, (total, transaction) => total + transaction.amount);
    } catch (error) {
      throw RepositoryException(
        'Failed to calculate expense for range.',
        error,
      );
    }
  }

  @override
  Future<List<CategoryInsight>> getCategoryInsightsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final rangeTransactions = await getTransactionsByDateRange(start, end);
      final expenseTransactions = rangeTransactions.where(
        (transaction) => transaction.isExpense,
      );
      final totalsByCategory = <String, double>{};

      for (final transaction in expenseTransactions) {
        totalsByCategory.update(
          transaction.category,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }

      final totalExpense = totalsByCategory.values.fold<double>(
        0,
        (sum, amount) => sum + amount,
      );

      if (totalExpense == 0) {
        return const <CategoryInsight>[];
      }

      final insights = totalsByCategory.entries.map((entry) {
        return CategoryInsight(
          category: entry.key,
          totalSpent: entry.value,
          percentage: entry.value / totalExpense,
        );
      }).toList();

      insights.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
      return insights;
    } catch (error) {
      throw RepositoryException(
        'Failed to calculate category insights for range.',
        error,
      );
    }
  }
}

void _sanitizeAndValidateTransaction(Transaction transaction) {
  transaction.category = transaction.category.trim();
  final trimmedNotes = transaction.notes?.trim();
  transaction.notes = trimmedNotes == null || trimmedNotes.isEmpty
      ? null
      : trimmedNotes;

  if (!transaction.amount.isFinite || transaction.amount <= 0) {
    throw const RepositoryException(
      'Transaction amount must be a finite number greater than zero.',
    );
  }

  if (transaction.category.isEmpty) {
    throw const RepositoryException('Transaction category is required.');
  }
}

(DateTime, DateTime) _currentMonthBounds() {
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month);
  final nextMonthStart = DateTime(now.year, now.month + 1);
  final monthEnd = nextMonthStart.subtract(const Duration(microseconds: 1));
  return (monthStart, monthEnd);
}
