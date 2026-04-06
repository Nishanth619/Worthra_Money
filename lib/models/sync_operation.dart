import 'package:isar_community/isar.dart';

part 'sync_operation.g.dart';

// Regenerate with:
// dart run build_runner build --delete-conflicting-outputs

/// Persists a pending sync operation that has not yet been acknowledged by
/// the remote server. Drained by [SyncService] with exponential back-off.
@collection
class SyncOperation {
  SyncOperation({
    this.id = Isar.autoIncrement,
    required this.operationType,
    required this.entityType,
    required this.localId,
    required this.payloadJson,
    this.attemptCount = 0,
    DateTime? createdAtValue,
  }) : createdAt = createdAtValue ?? DateTime.now();

  Id id;

  /// 'create' | 'update' | 'delete'
  late String operationType;

  /// 'transaction' | 'goal'
  late String entityType;

  /// Isar local ID of the entity being synced.
  late int localId;

  /// JSON-encoded payload for the API call.
  late String payloadJson;

  /// Number of retry attempts made so far.
  int attemptCount;

  @Index()
  late DateTime createdAt;
}

/// Type-safe constants used when constructing [SyncOperation] objects.
abstract class SyncOperationType {
  static const create = 'create';
  static const update = 'update';
  static const delete = 'delete';
}

abstract class SyncEntityType {
  static const transaction = 'transaction';
  static const goal = 'goal';
}
