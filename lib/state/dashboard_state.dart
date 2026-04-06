import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/transaction_repository.dart';
import 'dashboard_summary.dart';
import 'database_provider.dart';

/// Keeps the dashboard totals in sync with the local database.
///
/// Data flow:
/// 1. The provider resolves the repository from dependency injection.
/// 2. It loads the current month totals once for the initial UI state.
/// 3. It subscribes to repository change notifications and recalculates when
///    transactions are added or deleted.
class DashboardStateNotifier extends AsyncNotifier<DashboardSummary> {
  StreamSubscription<void>? _subscription;
  var _disposed = false;

  @override
  Future<DashboardSummary> build() async {
    final repository = await ref.watch(transactionRepositoryProvider.future);

    await _subscription?.cancel();
    _subscription = repository.watchTransactions().listen(
      (_) => unawaited(
        _loadSummary(repository).then((summary) {
          if (!_disposed) state = AsyncData(summary);
        }).catchError((Object error, StackTrace stackTrace) {
          if (!_disposed) state = AsyncError(error, stackTrace);
        }),
      ),
      onError: (Object error, StackTrace stackTrace) {
        if (!_disposed) {
          state = AsyncError(error, stackTrace);
        }
      },
    );

    ref.onDispose(() {
      _disposed = true;
      _subscription?.cancel();
    });

    return _loadSummary(repository);
  }

  Future<DashboardSummary> refresh() async {
    final repository = await ref.read(transactionRepositoryProvider.future);
    final summary = await _loadSummary(repository);
    state = AsyncData(summary);
    return summary;
  }

  Future<DashboardSummary> _loadSummary(
    ITransactionRepository repository,
  ) async {
    final currentBalance = await repository.getTotalBalance();
    final monthlyIncome = await repository.getTotalIncome();
    final monthlyExpense = await repository.getTotalExpense();

    return DashboardSummary(
      currentBalance: currentBalance,
      monthlyIncome: monthlyIncome,
      monthlyExpense: monthlyExpense,
    );
  }
}

final dashboardStateProvider =
    AsyncNotifierProvider<DashboardStateNotifier, DashboardSummary>(
      DashboardStateNotifier.new,
    );
