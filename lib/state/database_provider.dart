import 'package:isar_community/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';
import '../models/goal.dart';
import '../models/sync_operation.dart';
import '../models/transaction.dart';
import '../repositories/app_data_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/sync_queue_repository.dart';
import '../repositories/transaction_repository.dart';

const _databaseName = 'personal_finance_app_v3';

/// Opens the local offline database once and shares it across the app.
/// Has ZERO dependencies on auth or sync providers — pure DB infrastructure.
final databaseProvider = FutureProvider<Isar>((ref) async {
  try {
    final directory = await getApplicationSupportDirectory();
    final isar = await Isar.open(
      [
        AppSettingsSchema,
        TransactionSchema,
        GoalSchema,
        SyncOperationSchema,
      ],
      directory: directory.path,
      // Use a versioned database name because older installs can still carry
      // an incompatible Isar file from the pre-sync schema layout.
      name: _databaseName,
    );

    ref.onDispose(() {
      if (isar.isOpen) isar.close();
    });

    return isar;
  } catch (error, stackTrace) {
    Error.throwWithStackTrace(
      StateError('Failed to initialize the local database: $error'),
      stackTrace,
    );
  }
});

final transactionRepositoryProvider =
    FutureProvider<ITransactionRepository>((ref) async {
  final isar = await ref.watch(databaseProvider.future);
  return TransactionRepository(isar);
});

final settingsRepositoryProvider =
    FutureProvider<ISettingsRepository>((ref) async {
  final isar = await ref.watch(databaseProvider.future);
  return SettingsRepository(isar);
});

final appDataRepositoryProvider =
    FutureProvider<IAppDataRepository>((ref) async {
  final isar = await ref.watch(databaseProvider.future);
  final transactions = await ref.watch(transactionRepositoryProvider.future);
  final settings = await ref.watch(settingsRepositoryProvider.future);
  return AppDataRepository(isar, transactions, settings);
});

// Note: goalRepositoryProvider lives in goals_provider.dart (alongside its
// controller) to keep all goal logic co-located. It is NOT duplicated here.

final syncQueueRepositoryProvider =
    FutureProvider<ISyncQueueRepository>((ref) async {
  final isar = await ref.watch(databaseProvider.future);
  return SyncQueueRepository(isar);
});
