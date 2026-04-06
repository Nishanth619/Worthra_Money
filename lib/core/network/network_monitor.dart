import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps [Connectivity] to expose a simple [isOnline] bool and an
/// [onConnected] stream that fires each time the device transitions from
/// offline → online. Used by [SyncService] to auto-sync on reconnect.
class NetworkMonitor {
  NetworkMonitor([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  bool _previouslyOnline = true;

  /// Returns `true` if the device currently has any network access.
  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  /// Stream that emits a void event each time connectivity is restored after
  /// having been lost. Does not fire on the initial check.
  Stream<void> get onConnected {
    return _connectivity.onConnectivityChanged.asyncMap((results) async {
      final online = _hasConnection(results);
      final wasOffline = !_previouslyOnline;
      _previouslyOnline = online;
      return online && wasOffline ? Object() : null;
    }).where((event) => event != null);
  }

  static bool _hasConnection(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }
}
