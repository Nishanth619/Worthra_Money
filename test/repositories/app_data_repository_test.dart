import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/models/app_settings.dart';
import 'package:personal_finance_app/models/goal.dart';
import 'package:personal_finance_app/models/transaction.dart';
import 'package:personal_finance_app/repositories/app_data_repository.dart';
import 'package:personal_finance_app/repositories/settings_repository.dart';
import 'package:personal_finance_app/repositories/transaction_repository.dart';

import '../helpers/test_database.dart';

void main() {
  TestDatabase? database;
  TransactionRepository? transactionRepository;
  SettingsRepository? settingsRepository;
  AppDataRepository? appDataRepository;

  setUp(() async {
    database = await TestDatabase.open(name: 'app_data_repository_test');
    transactionRepository = TransactionRepository(database!.isar);
    settingsRepository = SettingsRepository(database!.isar);
    appDataRepository = AppDataRepository(
      database!.isar,
      transactionRepository!,
      settingsRepository!,
      exportDirectoryResolver: () async => database!.directory,
    );
  });

  tearDown(() async {
    if (database != null) {
      await database!.dispose();
    }
  });

  test('exports CSV and insights report files', () async {
    final now = DateTime.now();
    await transactionRepository!.addTransactions([
      Transaction(
        amount: 2400,
        isExpense: false,
        category: 'Salary',
        date: now.subtract(const Duration(days: 1)),
        notes: 'Salary',
      ),
      Transaction(
        amount: 300,
        isExpense: true,
        category: 'Food & Dining',
        date: now,
        notes: 'Dinner',
      ),
    ]);

    final csvPath = await appDataRepository!.exportTransactionsCsv(
      currencySymbol: '\$',
    );
    final reportPath = await appDataRepository!.exportInsightsReport(
      period: InsightsPeriodPreference.weekly,
      currencySymbol: '\$',
    );

    expect(await File(csvPath).exists(), isTrue);
    expect(await File(reportPath).exists(), isTrue);
  });

  test(
    'clears transactions and goals but preserves seed flag by default',
    () async {
      await transactionRepository!.addTransaction(
        Transaction(
          amount: 42,
          isExpense: true,
          category: 'Other',
          date: DateTime.now(),
        ),
      );
      await database!.isar.writeTxn(() async {
        await database!.isar.goals.put(
          Goal(
            title: 'Relocation Fund',
            targetAmount: 1000,
            currentAmount: 250,
            isStreakChallenge: false,
          ),
        );
      });
      await settingsRepository!.markInitialSeedCompleted();

      await appDataRepository!.clearAllAppData();

      expect(await transactionRepository!.getAllTransactions(), isEmpty);
      expect(await database!.isar.goals.count(), 0);
      expect(
        (await settingsRepository!.getSettings()).hasCompletedInitialSeed,
        isTrue,
      );
    },
  );
}
