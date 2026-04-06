import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import 'dashboard_state.dart';
import 'database_provider.dart';

/// Emits a new tick whenever transaction data changes in the repository.
final transactionRefreshProvider = StreamProvider<int>((ref) async* {
  final repository = await ref.watch(transactionRepositoryProvider.future);
  var tick = 0;

  await for (final _ in repository.watchTransactions()) {
    yield tick++;
  }
});

/// Exposes the full transaction list to the UI, sorted by date descending.
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  ref.watch(transactionRefreshProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  return repository.getAllTransactions();
});

/// Owns transaction mutations so widgets don't talk to repositories directly.
class TransactionsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addTransaction(Transaction transaction) async {
    final repository = await ref.read(transactionRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.addTransaction(transaction);
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardStateProvider);
    });
  }

  Future<void> deleteTransaction(int id) async {
    final repository = await ref.read(transactionRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.deleteTransaction(id);
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardStateProvider);
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final repository = await ref.read(transactionRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateTransaction(transaction);
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardStateProvider);
    });
  }
}

final transactionsControllerProvider =
    AsyncNotifierProvider<TransactionsController, void>(
      TransactionsController.new,
    );
