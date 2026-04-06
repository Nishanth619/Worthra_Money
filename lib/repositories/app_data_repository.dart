import 'dart:io';

import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';
import '../models/goal.dart';
import '../models/transaction.dart';
import 'repository_exception.dart';
import 'settings_repository.dart';
import 'transaction_repository.dart';

abstract class IAppDataRepository {
  Future<String> exportTransactionsCsv({required String currencySymbol});
  Future<String> exportInsightsReport({
    required InsightsPeriodPreference period,
    required String currencySymbol,
  });
  Future<void> clearAllAppData({bool preserveInitialSeedFlag = true});
}

class AppDataRepository implements IAppDataRepository {
  AppDataRepository(
    this._isar,
    this._transactionRepository,
    this._settingsRepository, {
    Future<Directory> Function()? exportDirectoryResolver,
  }) : _exportDirectoryResolver =
           exportDirectoryResolver ?? getApplicationDocumentsDirectory;

  final Isar _isar;
  final ITransactionRepository _transactionRepository;
  final ISettingsRepository _settingsRepository;
  final Future<Directory> Function() _exportDirectoryResolver;

  @override
  Future<String> exportTransactionsCsv({required String currencySymbol}) async {
    try {
      final transactions = await _transactionRepository.getAllTransactions();
      final directory = await _ensureExportDirectory();
      final file = File(
        '${directory.path}${Platform.pathSeparator}transactions_${_timestamp()}.csv',
      );

      final buffer = StringBuffer()
        ..writeln('id,date,type,category,amount,notes');

      for (final transaction in transactions) {
        buffer.writeln(
          [
            transaction.id,
            transaction.date.toIso8601String(),
            transaction.isExpense ? 'expense' : 'income',
            _escapeCsv(transaction.category),
            '$currencySymbol${transaction.amount.toStringAsFixed(2)}',
            _escapeCsv(transaction.notes ?? ''),
          ].join(','),
        );
      }

      await file.writeAsString(buffer.toString(), flush: true);
      return file.path;
    } catch (error) {
      throw RepositoryException('Failed to export transactions CSV.', error);
    }
  }

  @override
  Future<String> exportInsightsReport({
    required InsightsPeriodPreference period,
    required String currencySymbol,
  }) async {
    try {
      final range = switch (period) {
        InsightsPeriodPreference.weekly => _currentWeekRange(),
        InsightsPeriodPreference.monthly => _currentMonthRange(),
      };
      final transactions = await _transactionRepository
          .getTransactionsByDateRange(range.start, range.end);
      final expenseTransactions = transactions
          .where((transaction) => transaction.isExpense)
          .toList();
      final incomeTransactions = transactions
          .where((transaction) => !transaction.isExpense)
          .toList();

      final expenseTotal = expenseTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );
      final incomeTotal = incomeTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );
      final balance = incomeTotal - expenseTotal;
      final categoryTotals = <String, double>{};

      for (final transaction in expenseTransactions) {
        categoryTotals.update(
          transaction.category,
          (value) => value + transaction.amount,
          ifAbsent: () => transaction.amount,
        );
      }

      final sortedCategories = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final directory = await _ensureExportDirectory();
      final file = File(
        '${directory.path}${Platform.pathSeparator}insights_${period.storageValue}_${_timestamp()}.txt',
      );
      final buffer = StringBuffer()
        ..writeln('Worthra Insights Report')
        ..writeln('Period: ${period.name}')
        ..writeln(
          'Range: ${range.start.toIso8601String()} - ${range.end.toIso8601String()}',
        )
        ..writeln()
        ..writeln('Income: $currencySymbol${incomeTotal.toStringAsFixed(2)}')
        ..writeln('Expenses: $currencySymbol${expenseTotal.toStringAsFixed(2)}')
        ..writeln('Net Balance: $currencySymbol${balance.toStringAsFixed(2)}')
        ..writeln()
        ..writeln('Top Categories:');

      if (sortedCategories.isEmpty) {
        buffer.writeln('- No expense transactions in this period.');
      } else {
        for (final entry in sortedCategories) {
          final percentage = expenseTotal == 0
              ? 0
              : (entry.value / expenseTotal) * 100;
          buffer.writeln(
            '- ${entry.key}: $currencySymbol${entry.value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
          );
        }
      }

      await file.writeAsString(buffer.toString(), flush: true);
      return file.path;
    } catch (error) {
      throw RepositoryException('Failed to export insights report.', error);
    }
  }

  @override
  Future<void> clearAllAppData({bool preserveInitialSeedFlag = true}) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.transactions.clear();
        await _isar.goals.clear();
      });

      await _settingsRepository.resetSettings(
        preserveInitialSeedFlag: preserveInitialSeedFlag,
      );
    } catch (error) {
      throw RepositoryException('Failed to clear local app data.', error);
    }
  }

  Future<Directory> _ensureExportDirectory() async {
    final root = await _exportDirectoryResolver();
    final directory = Directory('${root.path}${Platform.pathSeparator}exports');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}

String _timestamp() {
  final now = DateTime.now();
  String two(int value) => value.toString().padLeft(2, '0');
  return '${now.year}${two(now.month)}${two(now.day)}_${two(now.hour)}${two(now.minute)}${two(now.second)}';
}

String _escapeCsv(String value) {
  final escaped = value.replaceAll('"', '""');
  return '"$escaped"';
}

({DateTime start, DateTime end}) _currentWeekRange() {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999, 999);
  final start = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(const Duration(days: 6));
  return (start: start, end: end);
}

({DateTime start, DateTime end}) _currentMonthRange() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month);
  final end = DateTime(
    now.year,
    now.month + 1,
  ).subtract(const Duration(microseconds: 1));
  return (start: start, end: end);
}
