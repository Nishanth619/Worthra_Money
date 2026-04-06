import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/models/goal.dart';
import 'package:personal_finance_app/repositories/goal_repository.dart';
import 'package:personal_finance_app/repositories/repository_exception.dart';

import '../helpers/test_database.dart';

void main() {
  TestDatabase? database;
  GoalRepository? repository;

  setUp(() async {
    database = await TestDatabase.open(name: 'goal_repository_test');
    repository = GoalRepository(database!.isar);
  });

  tearDown(() async {
    if (database != null) {
      await database!.dispose();
    }
  });

  test('stores goals and separates streak goals from savings goals', () async {
    await repository!.addGoals([
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
      Goal(
        title: 'Energy Saver',
        targetAmount: 10,
        currentAmount: 8,
        isStreakChallenge: true,
      ),
    ]);

    final allGoals = await repository!.getAllGoals();
    final savingsGoals = await repository!.getSavingsGoals();
    final streakGoals = await repository!.getStreakGoals();

    expect(allGoals.map((goal) => goal.title).toList(), [
      'Energy Saver',
      'No-Spend Streak',
      'Relocation Fund',
    ]);
    expect(savingsGoals.map((goal) => goal.title).toList(), [
      'Relocation Fund',
    ]);
    expect(streakGoals.map((goal) => goal.title).toList(), [
      'Energy Saver',
      'No-Spend Streak',
    ]);
  });

  test('updates goal progress and persists the new amount', () async {
    final goal = Goal(
      title: 'Relocation Fund',
      targetAmount: 5000,
      currentAmount: 2500,
      isStreakChallenge: false,
    );

    await repository!.addGoal(goal);
    final storedGoal = (await repository!.getAllGoals()).single;

    await repository!.updateGoalProgress(storedGoal.id, 3200);

    final updatedGoal = (await repository!.getAllGoals()).single;
    expect(updatedGoal.currentAmount, 3200);
  });

  test('throws a repository exception when updating a missing goal', () async {
    expect(
      () => repository!.updateGoalProgress(999999, 10),
      throwsA(isA<RepositoryException>()),
    );
  });

  test('throws when updating a goal that does not exist', () async {
    expect(
      () => repository!.updateGoal(
        Goal(
          id: 999999,
          title: 'Missing Goal',
          targetAmount: 100,
          currentAmount: 25,
          isStreakChallenge: false,
        ),
      ),
      throwsA(isA<RepositoryException>()),
    );
  });

  test('deletes a goal by id', () async {
    await repository!.addGoal(
      Goal(
        title: 'Delete Goal',
        targetAmount: 100,
        currentAmount: 25,
        isStreakChallenge: false,
      ),
    );

    final storedGoal = (await repository!.getAllGoals()).single;
    await repository!.deleteGoal(storedGoal.id);

    expect(await repository!.getAllGoals(), isEmpty);
  });
}
