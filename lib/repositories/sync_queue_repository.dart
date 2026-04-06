import 'package:isar_community/isar.dart';

import '../models/sync_operation.dart';
import 'repository_exception.dart';

abstract class ISyncQueueRepository {
  Future<void> enqueue(SyncOperation operation);
  Future<List<SyncOperation>> getAllPending();
  Future<void> incrementAttempt(int id);
  Future<void> dequeue(int id);
  Future<void> clearAll();
}

class SyncQueueRepository implements ISyncQueueRepository {
  const SyncQueueRepository(this._isar);

  final Isar _isar;

  IsarCollection<SyncOperation> get _queue => _isar.syncOperations;

  @override
  Future<void> enqueue(SyncOperation operation) async {
    try {
      await _isar.writeTxn(() => _queue.put(operation));
    } catch (error) {
      throw RepositoryException('Failed to enqueue sync operation.', error);
    }
  }

  @override
  Future<List<SyncOperation>> getAllPending() async {
    try {
      return _queue.where().sortByCreatedAt().findAll();
    } catch (error) {
      throw RepositoryException('Failed to read sync queue.', error);
    }
  }

  @override
  Future<void> incrementAttempt(int id) async {
    try {
      await _isar.writeTxn(() async {
        final operation = await _queue.get(id);
        if (operation != null) {
          operation.attemptCount += 1;
          await _queue.put(operation);
        }
      });
    } catch (error) {
      throw RepositoryException('Failed to update sync attempt count.', error);
    }
  }

  @override
  Future<void> dequeue(int id) async {
    try {
      await _isar.writeTxn(() => _queue.delete(id));
    } catch (error) {
      throw RepositoryException('Failed to remove sync operation $id.', error);
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _isar.writeTxn(() => _queue.clear());
    } catch (error) {
      throw RepositoryException('Failed to clear sync queue.', error);
    }
  }
}
