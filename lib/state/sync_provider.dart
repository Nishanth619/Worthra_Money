import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/network_monitor.dart';
import '../core/services/sync_service.dart';
import 'auth_provider.dart';
import 'database_provider.dart';

// ---------------------------------------------------------------------------
// Sync Status
// ---------------------------------------------------------------------------

enum SyncStatus { idle, syncing, success, error }

// ---------------------------------------------------------------------------
// Network monitor provider
// ---------------------------------------------------------------------------

final networkMonitorProvider = Provider<NetworkMonitor>((ref) {
  return NetworkMonitor();
});

// ---------------------------------------------------------------------------
// Sync service provider
// (lives here, not in database_provider, to avoid circular imports)
// ---------------------------------------------------------------------------

final syncServiceProvider = FutureProvider<SyncService>((ref) async {
  final isar = await ref.watch(databaseProvider.future);
  final apiClient = ref.watch(apiClientProvider);
  final tokenStore = ref.watch(authTokenStoreProvider);
  final syncQueue = await ref.watch(syncQueueRepositoryProvider.future);
  final networkMonitor = ref.watch(networkMonitorProvider);

  return SyncService(
    isar: isar,
    apiClient: apiClient,
    tokenStore: tokenStore,
    syncQueue: syncQueue,
    networkMonitor: networkMonitor,
  );
});

// ---------------------------------------------------------------------------
// Sync controller
// ---------------------------------------------------------------------------

class SyncController extends AsyncNotifier<SyncStatus> {
  bool _disposed = false;

  @override
  Future<SyncStatus> build() async {
    ref.onDispose(() => _disposed = true);
    return SyncStatus.idle;
  }

  Future<void> triggerSync({DateTime? lastSyncAt}) async {
    // Prevent double-trigger if already syncing
    if (state.asData?.value == SyncStatus.syncing) return;

    state = const AsyncData(SyncStatus.syncing);

    try {
      final syncService = await ref.read(syncServiceProvider.future);
      await syncService.fullSync(lastSyncAt: lastSyncAt);

      if (!_disposed) state = const AsyncData(SyncStatus.success);

      // Reset to idle after a brief window so the UI can show "completed"
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!_disposed) state = const AsyncData(SyncStatus.idle);
    } catch (_) {
      if (!_disposed) state = const AsyncData(SyncStatus.error);
    }
  }
}

final syncControllerProvider =
    AsyncNotifierProvider<SyncController, SyncStatus>(SyncController.new);

// ---------------------------------------------------------------------------
// Last synced timestamp (derived from AppSettings)
// ---------------------------------------------------------------------------

final lastSyncAtProvider = Provider<DateTime?>((ref) {
  return null; // populated once AppSettings.lastSyncAt is wired via bootstrap
});
