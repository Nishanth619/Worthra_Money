import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goal.dart';
import '../repositories/goal_repository.dart';
import 'database_provider.dart';

final goalRepositoryProvider = FutureProvider<IGoalRepository>((ref) async {
  final isar = await ref.watch(databaseProvider.future);
  return GoalRepository(isar);
});

final goalsRefreshProvider = StreamProvider<int>((ref) async* {
  final repository = await ref.watch(goalRepositoryProvider.future);
  var tick = 0;

  await for (final _ in repository.watchGoals()) {
    yield tick++;
  }
});

final allGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  ref.watch(goalsRefreshProvider);
  final repository = await ref.watch(goalRepositoryProvider.future);
  return repository.getAllGoals();
});

final savingsGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  ref.watch(goalsRefreshProvider);
  final repository = await ref.watch(goalRepositoryProvider.future);
  return repository.getSavingsGoals();
});

final streakGoalsProvider = FutureProvider<List<Goal>>((ref) async {
  ref.watch(goalsRefreshProvider);
  final repository = await ref.watch(goalRepositoryProvider.future);
  return repository.getStreakGoals();
});

class GoalsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addGoal(Goal goal) async {
    final repository = await ref.read(goalRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.addGoal(goal);
      _refreshGoalQueries();
    });
  }

  Future<void> updateGoal(Goal goal) async {
    final repository = await ref.read(goalRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateGoal(goal);
      _refreshGoalQueries();
    });
  }

  Future<void> deleteGoal(int id) async {
    final repository = await ref.read(goalRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.deleteGoal(id);
      _refreshGoalQueries();
    });
  }

  Future<void> updateGoalProgress(int id, double currentAmount) async {
    final repository = await ref.read(goalRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateGoalProgress(id, currentAmount);
      _refreshGoalQueries();
    });
  }

  void _refreshGoalQueries() {
    ref.invalidate(allGoalsProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(streakGoalsProvider);
  }
}

final goalsControllerProvider = AsyncNotifierProvider<GoalsController, void>(
  GoalsController.new,
);
