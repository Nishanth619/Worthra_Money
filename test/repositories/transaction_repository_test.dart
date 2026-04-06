import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/models/transaction.dart';
import 'package:personal_finance_app/repositories/repository_exception.dart';
import 'package:personal_finance_app/repositories/transaction_repository.dart';

import '../helpers/test_database.dart';

void main() {
  TestDatabase? database;
  TransactionRepository? repository;

  setUp(() async {
    database = await TestDatabase.open(name: 'transaction_repository_test');
    repository = TransactionRepository(database!.isar);
  });

  tearDown(() async {
    if (database != null) {
      await database!.dispose();
    }
  });

  test(
    'returns transactions sorted descending and calculates monthly totals',
    () async {
      final now = DateTime.now();
      final currentMonthTransactions = [
        Transaction(
          amount: 5000,
          isExpense: false,
          category: 'Salary',
          date: DateTime(now.year, now.month, 1, 9),
          notes: 'Monthly Salary',
        ),
        Transaction(
          amount: 1200,
          isExpense: true,
          category: 'Housing',
          date: DateTime(now.year, now.month, 2, 18),
          notes: 'Monthly Rent',
        ),
        Transaction(
          amount: 300,
          isExpense: true,
          category: 'Food & Dining',
          date: DateTime(now.year, now.month, 3, 12),
          notes: 'Vegetarian Groceries',
        ),
      ];
      final oldTransaction = Transaction(
        amount: 100,
        isExpense: true,
        category: 'Transport',
        date: DateTime(now.year, now.month - 1, 25, 8),
        notes: 'Last Month Taxi',
      );

      await repository!.addTransactions([
        ...currentMonthTransactions,
        oldTransaction,
      ]);

      final allTransactions = await repository!.getAllTransactions();
      expect(allTransactions, hasLength(4));
      expect(allTransactions.map((transaction) => transaction.notes).toList(), [
        'Vegetarian Groceries',
        'Monthly Rent',
        'Monthly Salary',
        'Last Month Taxi',
      ]);

      expect(await repository!.getTotalIncome(), 5000);
      expect(await repository!.getTotalExpense(), 1500);
      expect(await repository!.getTotalBalance(), 3500);

      final currentMonthRange = await repository!.getTransactionsByDateRange(
        DateTime(now.year, now.month),
        DateTime(
          now.year,
          now.month + 1,
        ).subtract(const Duration(microseconds: 1)),
      );
      expect(currentMonthRange, hasLength(3));
    },
  );

  test('aggregates category insights from expense transactions only', () async {
    final now = DateTime.now();
    await repository!.addTransactions([
      Transaction(
        amount: 900,
        isExpense: true,
        category: 'Housing',
        date: DateTime(now.year, now.month, 1, 10),
      ),
      Transaction(
        amount: 300,
        isExpense: true,
        category: 'Food & Dining',
        date: DateTime(now.year, now.month, 2, 10),
      ),
      Transaction(
        amount: 100,
        isExpense: true,
        category: 'Food & Dining',
        date: DateTime(now.year, now.month, 2, 18),
      ),
      Transaction(
        amount: 2000,
        isExpense: false,
        category: 'Salary',
        date: DateTime(now.year, now.month, 1, 8),
      ),
    ]);

    final insights = await repository!.getCategoryInsights();

    expect(insights, hasLength(2));
    expect(insights.first.category, 'Housing');
    expect(insights.first.totalSpent, 900);
    expect(insights.first.percentage, closeTo(900 / 1300, 0.0001));
    expect(insights.last.category, 'Food & Dining');
    expect(insights.last.totalSpent, 400);
    expect(insights.last.percentage, closeTo(400 / 1300, 0.0001));
  });

  test('deletes a transaction by id', () async {
    final transaction = Transaction(
      amount: 42,
      isExpense: true,
      category: 'Food & Dining',
      date: DateTime.now(),
      notes: 'Delete me',
    );

    await repository!.addTransaction(transaction);
    final stored = await repository!.getAllTransactions();

    await repository!.deleteTransaction(stored.single.id);

    expect(await repository!.getAllTransactions(), isEmpty);
  });

  test('rejects invalid transaction payloads at the repository boundary', () async {
    expect(
      () => repository!.addTransaction(
        Transaction(
          amount: -10,
          isExpense: true,
          category: 'Food & Dining',
          date: DateTime.now(),
        ),
      ),
      throwsA(isA<RepositoryException>()),
    );

    expect(
      () => repository!.addTransaction(
        Transaction(
          amount: double.nan,
          isExpense: true,
          category: 'Food & Dining',
          date: DateTime.now(),
        ),
      ),
      throwsA(isA<RepositoryException>()),
    );

    expect(
      () => repository!.addTransaction(
        Transaction(
          amount: 20,
          isExpense: true,
          category: '   ',
          date: DateTime.now(),
        ),
      ),
      throwsA(isA<RepositoryException>()),
    );
  });
}
