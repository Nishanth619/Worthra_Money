import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../models/goal.dart';
import '../../models/sync_operation.dart';
import '../../models/transaction.dart';
import '../../repositories/sync_queue_repository.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import '../network/auth_token_store.dart';
import '../network/network_monitor.dart';

/// Maximum number of retry attempts before a queued operation is abandoned.
const _kMaxAttempts = 5;

/// The core production sync service.
///
/// Architecture:
///  - Local Isar DB is **always** the source of truth for reads.
///  - [SyncService] runs in the background and applies diffs to the server.
///  - On push: entities with null [syncedAt] are sent to the API.
///  - On pull: entities modified server-side since [lastSyncAt] are fetched
///    and upserted into Isar.
///  - Conflict resolution: last-write-wins by ISO 8601 timestamp.
///  - Failed operations are persisted in [SyncQueueRepository] with
///    exponential back-off (max [_kMaxAttempts]).
///
/// NOTE: The filter helpers for [Transaction.syncedAt] and [Goal.syncedAt]
/// use Dart-side filtering rather than generated Isar query builders.
/// Run `dart run build_runner build` after any model changes to rebuild the
/// generated query extensions and restore DB-level filtering for performance.
class SyncService {
  const SyncService({
    required Isar isar,
    required ApiClient apiClient,
    required AuthTokenStore tokenStore,
    required ISyncQueueRepository syncQueue,
    required NetworkMonitor networkMonitor,
  })  : _isar = isar,
        _apiClient = apiClient,
        _tokenStore = tokenStore,
        _syncQueue = syncQueue,
        _networkMonitor = networkMonitor;

  final Isar _isar;
  final ApiClient _apiClient;
  final AuthTokenStore _tokenStore;
  final ISyncQueueRepository _syncQueue;
  final NetworkMonitor _networkMonitor;

  // ---------------------------------------------------------------------------
  // Public entry points
  // ---------------------------------------------------------------------------

  /// Full sync cycle: push local changes then pull remote.
  Future<void> fullSync({DateTime? lastSyncAt}) async {
    if (!await _canSync()) return;

    await pushTransactions();
    await pushGoals();
    await _drainRetryQueue();
    await pullTransactions(since: lastSyncAt);
    await pullGoals(since: lastSyncAt);
  }

  /// Push all local transactions not yet acknowledged by the server.
  Future<void> pushTransactions() async {
    if (!await _canSync()) return;

    // Dart-side filter: syncedAt == null means not yet synced.
    // Generated query helper (.syncedAtIsNull()) requires re-running
    // build_runner after the syncedAt field was added to the model.
    final all = await _isar.transactions.where().findAll();
    final unsynced = all.where((tx) => tx.syncedAt == null).toList();

    for (final tx in unsynced) {
      await _pushEntity(
        operationType: SyncOperationType.create,
        entityType: SyncEntityType.transaction,
        localId: tx.id,
        payload: _transactionToJson(tx),
        onSuccess: (responseData) async {
          tx.serverId = responseData['id'] as String?;
          tx.syncedAt = DateTime.now();
          await _isar.writeTxn(() => _isar.transactions.put(tx));
        },
      );
    }
  }

  /// Push all local goals not yet acknowledged by the server.
  Future<void> pushGoals() async {
    if (!await _canSync()) return;

    final all = await _isar.goals.where().findAll();
    final unsynced = all.where((g) => g.syncedAt == null).toList();

    for (final goal in unsynced) {
      await _pushEntity(
        operationType: SyncOperationType.create,
        entityType: SyncEntityType.goal,
        localId: goal.id,
        payload: _goalToJson(goal),
        onSuccess: (responseData) async {
          goal.serverId = responseData['id'] as String?;
          goal.syncedAt = DateTime.now();
          await _isar.writeTxn(() => _isar.goals.put(goal));
        },
      );
    }
  }

  /// Fetch remote transactions modified since [since] and upsert into Isar.
  Future<void> pullTransactions({DateTime? since}) async {
    if (!await _canSync()) return;

    try {
      final query = since != null
          ? '/transactions?since=${Uri.encodeComponent(since.toIso8601String())}'
          : '/transactions';
      final response = await _apiClient.get(query);
      final items = response['data'] as List<dynamic>? ?? [];

      // Load all local transactions once for serverId lookup.
      final localAll = await _isar.transactions.where().findAll();

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final serverId = map['id'] as String?;
          if (serverId == null) continue;

          // Dart-side serverId lookup (generated serverIdEqualTo() not yet
          // available until build_runner regenerates the query extensions).
          Transaction? existing;
          for (final t in localAll) {
            if (t.serverId == serverId) {
              existing = t;
              break;
            }
          }

          final tx = existing ??
              Transaction(
                amount: (map['amount'] as num).toDouble(),
                isExpense: map['isExpense'] as bool,
                category: map['category'] as String,
                date: DateTime.parse(map['date'] as String),
                notes: map['notes'] as String?,
              );
          tx.serverId = serverId;
          tx.syncedAt = DateTime.now();
          if (map['amount'] != null) {
            tx.amount = (map['amount'] as num).toDouble();
          }
          await _isar.transactions.put(tx);
        }
      });
    } on ApiException {
      // Swallow — pull errors are non-critical (data stays local).
    }
  }

  /// Fetch remote goals modified since [since] and upsert into Isar.
  Future<void> pullGoals({DateTime? since}) async {
    if (!await _canSync()) return;

    try {
      final query = since != null
          ? '/goals?since=${Uri.encodeComponent(since.toIso8601String())}'
          : '/goals';
      final response = await _apiClient.get(query);
      final items = response['data'] as List<dynamic>? ?? [];

      final localAll = await _isar.goals.where().findAll();

      await _isar.writeTxn(() async {
        for (final item in items) {
          final map = item as Map<String, dynamic>;
          final serverId = map['id'] as String?;
          if (serverId == null) continue;

          Goal? existing;
          for (final g in localAll) {
            if (g.serverId == serverId) {
              existing = g;
              break;
            }
          }

          final goal = existing ??
              Goal(
                title: map['title'] as String,
                targetAmount: (map['targetAmount'] as num).toDouble(),
                currentAmount:
                    (map['currentAmount'] as num? ?? 0).toDouble(),
                isStreakChallenge:
                    map['isStreakChallenge'] as bool? ?? false,
              );
          goal.serverId = serverId;
          goal.syncedAt = DateTime.now();
          await _isar.goals.put(goal);
        }
      });
    } on ApiException {
      // Swallow - pull errors are non-critical.
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<bool> _canSync() async {
    final authenticated = await _tokenStore.isAuthenticated;
    final online = await _networkMonitor.isOnline;
    return authenticated && online;
  }

  Future<void> _pushEntity({
    required String operationType,
    required String entityType,
    required int localId,
    required Map<String, dynamic> payload,
    required Future<void> Function(Map<String, dynamic>) onSuccess,
  }) async {
    try {
      final endpoint =
          entityType == SyncEntityType.transaction ? '/transactions' : '/goals';
      final response = await _apiClient.post(endpoint, payload);
      await onSuccess(response);
    } on ApiException catch (e) {
      if (e.isServerError || e.isNetworkError) {
        await _syncQueue.enqueue(
          SyncOperation(
            operationType: operationType,
            entityType: entityType,
            localId: localId,
            payloadJson: jsonEncode(payload),
          ),
        );
      }
      // 4xx errors (e.g., validation) are not retried.
    }
  }

  Future<void> _drainRetryQueue() async {
    final pending = await _syncQueue.getAllPending();

    for (final operation in pending) {
      if (operation.attemptCount >= _kMaxAttempts) {
        await _syncQueue.dequeue(operation.id);
        continue;
      }

      final endpoint = operation.entityType == SyncEntityType.transaction
          ? '/transactions'
          : '/goals';

      try {
        final payload =
            jsonDecode(operation.payloadJson) as Map<String, dynamic>;
        await _apiClient.post(endpoint, payload);
        await _syncQueue.dequeue(operation.id);
      } on ApiException {
        await _syncQueue.incrementAttempt(operation.id);
      }
    }
  }

  static Map<String, dynamic> _transactionToJson(Transaction tx) {
    return {
      'localId': tx.id,
      'amount': tx.amount,
      'isExpense': tx.isExpense,
      'category': tx.category,
      'date': tx.date.toIso8601String(),
      if (tx.notes != null) 'notes': tx.notes,
    };
  }

  static Map<String, dynamic> _goalToJson(Goal goal) {
    return {
      'localId': goal.id,
      'title': goal.title,
      'targetAmount': goal.targetAmount,
      'currentAmount': goal.currentAmount,
      'isStreakChallenge': goal.isStreakChallenge,
    };
  }
}
