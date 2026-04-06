import 'package:isar_community/isar.dart';

import '../models/goal.dart';
import 'repository_exception.dart';

abstract class IGoalRepository {
  Future<void> addGoal(Goal goal);
  Future<void> addGoals(Iterable<Goal> goals);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(int id);
  Future<List<Goal>> getAllGoals();
  Future<List<Goal>> getSavingsGoals();
  Future<List<Goal>> getStreakGoals();
  Future<void> updateGoalProgress(int id, double currentAmount);
  Stream<void> watchGoals();
}

class GoalRepository implements IGoalRepository {
  GoalRepository(this._isar);

  final Isar _isar;

  IsarCollection<Goal> get _goals => _isar.goals;

  @override
  Future<void> addGoal(Goal goal) async {
    try {
      await _isar.writeTxn(() async {
        await _goals.put(goal);
      });
    } catch (error) {
      throw RepositoryException('Failed to add goal.', error);
    }
  }

  @override
  Future<void> addGoals(Iterable<Goal> goals) async {
    try {
      final items = goals.toList(growable: false);
      if (items.isEmpty) {
        return;
      }

      await _isar.writeTxn(() async {
        await _goals.putAll(items);
      });
    } catch (error) {
      throw RepositoryException('Failed to add goals.', error);
    }
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    try {
      final existing = await _goals.get(goal.id);
      if (existing == null) {
        throw RepositoryException('Goal ${goal.id} was not found for update.');
      }

      await _isar.writeTxn(() async {
        await _goals.put(goal);
      });
    } catch (error) {
      if (error is RepositoryException) {
        rethrow;
      }

      throw RepositoryException('Failed to update goal ${goal.id}.', error);
    }
  }

  @override
  Future<void> deleteGoal(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _goals.delete(id);
      });
    } catch (error) {
      throw RepositoryException('Failed to delete goal $id.', error);
    }
  }

  @override
  Future<List<Goal>> getAllGoals() async {
    try {
      return _goals.where().sortByTitle().findAll();
    } catch (error) {
      throw RepositoryException('Failed to load goals.', error);
    }
  }

  @override
  Future<List<Goal>> getSavingsGoals() async {
    try {
      return _goals
          .filter()
          .isStreakChallengeEqualTo(false)
          .sortByTitle()
          .findAll();
    } catch (error) {
      throw RepositoryException('Failed to load savings goals.', error);
    }
  }

  @override
  Future<List<Goal>> getStreakGoals() async {
    try {
      return _goals
          .filter()
          .isStreakChallengeEqualTo(true)
          .sortByTitle()
          .findAll();
    } catch (error) {
      throw RepositoryException('Failed to load streak goals.', error);
    }
  }

  @override
  Future<void> updateGoalProgress(int id, double currentAmount) async {
    try {
      final goal = await _goals.get(id);

      if (goal == null) {
        throw const RepositoryException('Goal not found.');
      }

      goal.currentAmount = currentAmount;

      await _isar.writeTxn(() async {
        await _goals.put(goal);
      });
    } catch (error) {
      if (error is RepositoryException) {
        rethrow;
      }

      throw RepositoryException('Failed to update goal progress.', error);
    }
  }

  @override
  Stream<void> watchGoals() {
    return _goals.watchLazy(fireImmediately: true);
  }
}
