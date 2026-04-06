import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goal.dart';
import '../models/transaction.dart';
import '../repositories/goal_repository.dart';
import '../repositories/transaction_repository.dart';
import 'database_provider.dart';
import 'goals_provider.dart';
import 'notification_provider.dart';
import 'sync_provider.dart';

/// Initializes the local database with demo content on first launch so the
/// UI has meaningful offline data immediately.
///
/// After bootstrap, if the user is authenticated and online, kicks off a
/// background full sync. Also registers an ongoing listener so any future
/// reconnect after going offline also triggers an auto-sync.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  // Ensure the splash screen is visible long enough for the 2.2s animation to play.
  await Future.delayed(const Duration(milliseconds: 2500));

  await ref.watch(databaseProvider.future);
  final transactionRepository = await ref.watch(
    transactionRepositoryProvider.future,
  );
  final goalRepository = await ref.watch(goalRepositoryProvider.future);
  final settingsRepository = await ref.watch(settingsRepositoryProvider.future);

  final settings = await settingsRepository.getSettings();
  if (!settings.hasCompletedInitialSeed) {
    await _seedTransactionsIfEmpty(transactionRepository);
    await _seedGoalsIfEmpty(goalRepository);
    await settingsRepository.markInitialSeedCompleted();
  }

  final notificationService = ref.read(notificationServiceProvider);
  try {
    await notificationService.initialize();
    await notificationService.syncDailyReminder(
      enabled: settings.dailyReminderEnabled,
      hour: settings.dailyReminderHour,
      minute: settings.dailyReminderMinute,
    );
  } catch (_) {
    // Reminders are best-effort and should never block app startup.
  }

  // Wire auto-sync on reconnect (fire-and-forget, never blocks bootstrap)
  _scheduleBackgroundSync(ref, settings.lastSyncAt);
});

void _scheduleBackgroundSync(Ref ref, String? lastSyncAt) {
  final networkMonitor = ref.read(networkMonitorProvider);
  final lastSync = lastSyncAt != null ? DateTime.tryParse(lastSyncAt) : null;

  // Trigger immediately if online (fire-and-forget).
  unawaited(
    networkMonitor.isOnline.then((online) {
      if (online) {
        ref
            .read(syncControllerProvider.notifier)
            .triggerSync(lastSyncAt: lastSync);
      }
    }),
  );

  // Re-trigger whenever connectivity is restored.
  final reconnectSubscription = networkMonitor.onConnected.listen((_) {
    ref.read(syncControllerProvider.notifier).triggerSync();
  });
  ref.onDispose(reconnectSubscription.cancel);
}

Future<void> _seedTransactionsIfEmpty(ITransactionRepository repository) async {
  final existing = await repository.getAllTransactions();
  if (existing.isNotEmpty) return;

  final now = DateTime.now();
  final seedTransactions = <Transaction>[
    Transaction(
      amount: 45,
      isExpense: true,
      category: 'Food & Dining',
      date: now.subtract(const Duration(hours: 2)),
      notes: 'Vegetarian Groceries',
    ),
    Transaction(
      amount: 4.5,
      isExpense: true,
      category: 'Food & Dining',
      date: now.subtract(const Duration(hours: 6)),
      notes: 'Cafe',
    ),
    Transaction(
      amount: 1200,
      isExpense: true,
      category: 'Housing',
      date: now.subtract(const Duration(days: 1, hours: 3)),
      notes: 'Monthly Rent',
    ),
    Transaction(
      amount: 18,
      isExpense: true,
      category: 'Transport',
      date: now.subtract(const Duration(days: 1, hours: 8)),
      notes: 'Metro Recharge',
    ),
    Transaction(
      amount: 120,
      isExpense: true,
      category: 'Gifts',
      date: now.subtract(const Duration(days: 2)),
      notes: 'Gift for Ananya',
    ),
    Transaction(
      amount: 15,
      isExpense: true,
      category: 'Work & Tech',
      date: now.subtract(const Duration(days: 2, hours: 8)),
      notes: 'Server Hosting',
    ),
    Transaction(
      amount: 5000,
      isExpense: false,
      category: 'Salary',
      date: DateTime(now.year, now.month, 1, 9),
      notes: 'Monthly Salary',
    ),
    Transaction(
      amount: 850,
      isExpense: false,
      category: 'Freelance',
      date: now.subtract(const Duration(days: 1, hours: 10)),
      notes: 'Freelance Payment',
    ),
  ];

  await repository.addTransactions(seedTransactions);
}

Future<void> _seedGoalsIfEmpty(IGoalRepository repository) async {
  final existing = await repository.getAllGoals();
  if (existing.isNotEmpty) return;

  final seedGoals = <Goal>[
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
  ];

  await repository.addGoals(seedGoals);
}
