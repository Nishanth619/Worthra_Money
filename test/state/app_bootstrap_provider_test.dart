import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/models/app_settings.dart';
import 'package:personal_finance_app/core/network/network_monitor.dart';
import 'package:personal_finance_app/state/app_bootstrap_provider.dart';
import 'package:personal_finance_app/state/database_provider.dart';
import 'package:personal_finance_app/state/goals_provider.dart';
import 'package:personal_finance_app/state/settings_provider.dart';
import 'package:personal_finance_app/state/sync_provider.dart';

import '../helpers/test_database.dart';

class _FakeOfflineNetworkMonitor extends NetworkMonitor {
  @override
  Future<bool> get isOnline async => false;

  @override
  Stream<void> get onConnected => const Stream<void>.empty();
}

void main() {
  test(
    'seeds transactions and goals once without duplicating records',
    () async {
      final database = await TestDatabase.open(name: 'app_bootstrap_test');
      addTearDown(database.dispose);

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWith((ref) async => database.isar),
          networkMonitorProvider.overrideWith((ref) => _FakeOfflineNetworkMonitor()),
        ],
      );
      addTearDown(container.dispose);

      await container.read(appBootstrapProvider.future);

      final transactionRepository = await container.read(
        transactionRepositoryProvider.future,
      );
      final goalRepository = await container.read(
        goalRepositoryProvider.future,
      );
      final settingsRepository = await container.read(
        settingsRepositoryProvider.future,
      );

      expect((await transactionRepository.getAllTransactions()).length, 8);
      expect((await goalRepository.getAllGoals()).length, 3);
      expect(
        (await settingsRepository.getSettings()).hasCompletedInitialSeed,
        isTrue,
      );

      container.invalidate(appBootstrapProvider);
      await container.read(appBootstrapProvider.future);

      expect((await transactionRepository.getAllTransactions()).length, 8);
      expect((await goalRepository.getAllGoals()).length, 3);
      expect(
        AppThemePreferenceX.fromStorage(
          (await container.read(settingsProvider.future)).themeMode,
        ),
        AppThemePreference.light,
      );
    },
  );
}
