import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:personal_finance_app/core/services/local_auth_service.dart';
import 'package:personal_finance_app/core/services/notification_service.dart';
import 'package:personal_finance_app/state/database_provider.dart';
import 'package:personal_finance_app/state/local_auth_provider.dart';
import 'package:personal_finance_app/state/notification_provider.dart';
import 'package:personal_finance_app/state/settings_provider.dart';

import '../helpers/test_database.dart';

void main() {
  test(
    'enabling biometric lock authenticates before persisting the setting',
    () async {
      final database = await TestDatabase.open(name: 'settings_provider_test');
      addTearDown(database.dispose);

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWith((ref) async => database.isar),
          localAuthServiceProvider.overrideWithValue(
            _FakeLocalAuthService(
              availability: const LocalAuthAvailability(
                isDeviceSupported: true,
                canCheckBiometrics: true,
                availableBiometrics: [BiometricType.strong],
              ),
              authenticateResult: const LocalAuthResult(isAuthenticated: true),
            ),
          ),
          notificationServiceProvider.overrideWithValue(
            _FakeNotificationService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(settingsControllerProvider.notifier);
      await controller.setBiometricLock(true);

      final settings = await container.read(settingsProvider.future);
      expect(settings.biometricLockEnabled, isTrue);
    },
  );

  test(
    'enabling biometric lock fails when biometrics are unavailable',
    () async {
      final database = await TestDatabase.open(
        name: 'settings_provider_unavailable_test',
      );
      addTearDown(database.dispose);

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWith((ref) async => database.isar),
          localAuthServiceProvider.overrideWithValue(
            _FakeLocalAuthService(
              availability: const LocalAuthAvailability(
                isDeviceSupported: true,
                canCheckBiometrics: false,
                availableBiometrics: [],
              ),
              authenticateResult: const LocalAuthResult(isAuthenticated: false),
            ),
          ),
          notificationServiceProvider.overrideWithValue(
            _FakeNotificationService(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(settingsControllerProvider.notifier);
      await controller.setBiometricLock(true);

      final settings = await container.read(settingsProvider.future);
      final controllerState = container.read(settingsControllerProvider);

      expect(settings.biometricLockEnabled, isFalse);
      expect(controllerState.hasError, isTrue);
      expect(controllerState.error, isA<LocalAuthFailure>());
    },
  );

  test(
    'enabling daily reminders persists the setting and schedules a reminder',
    () async {
      final database = await TestDatabase.open(
        name: 'settings_provider_reminder_test',
      );
      addTearDown(database.dispose);
      final notifications = _FakeNotificationService();

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWith((ref) async => database.isar),
          localAuthServiceProvider.overrideWithValue(
            _FakeLocalAuthService(
              availability: const LocalAuthAvailability(
                isDeviceSupported: true,
                canCheckBiometrics: true,
                availableBiometrics: [BiometricType.strong],
              ),
              authenticateResult: const LocalAuthResult(isAuthenticated: true),
            ),
          ),
          notificationServiceProvider.overrideWithValue(notifications),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(settingsControllerProvider.notifier);
      await controller.setDailyReminderEnabled(true);

      final settings = await container.read(settingsProvider.future);
      expect(settings.dailyReminderEnabled, isTrue);
      expect(notifications.permissionRequested, isTrue);
      expect(notifications.scheduledHour, 20);
      expect(notifications.scheduledMinute, 0);
    },
  );
}

class _FakeLocalAuthService implements ILocalAuthService {
  const _FakeLocalAuthService({
    required this.availability,
    required this.authenticateResult,
  });

  final LocalAuthAvailability availability;
  final LocalAuthResult authenticateResult;

  @override
  Future<LocalAuthResult> authenticate({required String reason}) async {
    return authenticateResult;
  }

  @override
  Future<void> cancelAuthentication() async {}

  @override
  Future<void> ensureBiometricsAvailable() async {
    if (!availability.isDeviceSupported) {
      throw const LocalAuthFailure(
        'This device does not support secure local authentication.',
      );
    }
    if (!availability.canCheckBiometrics) {
      throw const LocalAuthFailure(
        'Biometric hardware is unavailable on this device.',
      );
    }
    if (!availability.hasEnrolledBiometrics) {
      throw const LocalAuthFailure(
        'No biometrics are enrolled. Add a fingerprint or face unlock first.',
      );
    }
  }

  @override
  Future<LocalAuthAvailability> getAvailability() async => availability;
}

class _FakeNotificationService implements INotificationService {
  bool permissionRequested = false;
  bool cancelled = false;
  int? scheduledHour;
  int? scheduledMinute;

  @override
  Future<void> cancelDailyReminder() async {
    cancelled = true;
  }

  @override
  Future<void> ensureReminderPermissions() async {
    permissionRequested = true;
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<void> syncDailyReminder({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    if (!enabled) {
      return;
    }
    scheduledHour = hour;
    scheduledMinute = minute;
  }
}
