import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/models/goal.dart';
import 'package:personal_finance_app/models/transaction.dart';
import 'package:personal_finance_app/state/dashboard_state.dart';
import 'package:personal_finance_app/state/database_provider.dart';
import 'package:personal_finance_app/state/goals_provider.dart';
import 'package:personal_finance_app/state/insights_provider.dart';
import 'package:personal_finance_app/state/transactions_provider.dart';

import '../helpers/test_database.dart';

void main() {
  test('providers expose repository-backed local data', () async {
    final database = await TestDatabase.open(
      name: 'providers_integration_test',
    );
    addTearDown(database.dispose);

    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWith((ref) async => database.isar)],
    );
    addTearDown(container.dispose);

    final transactionRepository = await container.read(
      transactionRepositoryProvider.future,
    );
    final goalRepository = await container.read(goalRepositoryProvider.future);

    final now = DateTime.now();
    await transactionRepository.addTransactions([
      Transaction(
        amount: 2000,
        isExpense: false,
        category: 'Salary',
        date: DateTime(now.year, now.month, now.day, 9),
        notes: 'Salary',
      ),
      Transaction(
        amount: 200,
        isExpense: true,
        category: 'Food & Dining',
        date: DateTime(now.year, now.month, now.day, 13),
        notes: 'Lunch',
      ),
      Transaction(
        amount: 100,
        isExpense: true,
        category: 'Transport',
        date: DateTime(now.year, now.month, now.day, 18),
        notes: 'Metro',
      ),
    ]);

    await goalRepository.addGoals([
      Goal(
        title: 'Relocation Fund',
        targetAmount: 5000,
        currentAmount: 2500,
        isStreakChallenge: false,
      ),
      Goal(
        title: 'No-Spend Streak',
        targetAmount: 7,
        currentAmount: 5,
        isStreakChallenge: true,
      ),
    ]);

    final transactions = await container.read(transactionsProvider.future);
    final dashboard = await container.read(dashboardStateProvider.future);
    final insights = await container.read(insightsProvider.future);
    final savingsGoals = await container.read(savingsGoalsProvider.future);
    final streakGoals = await container.read(streakGoalsProvider.future);

    expect(transactions.map((transaction) => transaction.notes).toList(), [
      'Metro',
      'Lunch',
      'Salary',
    ]);
    expect(dashboard.monthlyIncome, 2000);
    expect(dashboard.monthlyExpense, 300);
    expect(dashboard.currentBalance, 1700);
    expect(insights.map((insight) => insight.category).toList(), [
      'Food & Dining',
      'Transport',
    ]);
    expect(savingsGoals.single.title, 'Relocation Fund');
    expect(streakGoals.single.title, 'No-Spend Streak');
  });
}
