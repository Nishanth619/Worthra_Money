import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/models/app_settings.dart';
import 'package:personal_finance_app/repositories/settings_repository.dart';

import '../helpers/test_database.dart';

void main() {
  TestDatabase? database;
  SettingsRepository? repository;

  setUp(() async {
    database = await TestDatabase.open(name: 'settings_repository_test');
    repository = SettingsRepository(database!.isar);
  });

  tearDown(() async {
    if (database != null) {
      await database!.dispose();
    }
  });

  test('returns persisted default settings when none exist yet', () async {
    final settings = await repository!.getSettings();

    expect(settings.id, SettingsRepository.settingsId);
    expect(settings.currencyCode, 'USD');
    expect(settings.currencySymbol, '\$');
    expect(
      AppThemePreferenceX.fromStorage(settings.themeMode),
      AppThemePreference.light,
    );
    expect(
      InsightsPeriodPreferenceX.fromStorage(settings.insightsPeriod),
      InsightsPeriodPreference.weekly,
    );
    expect(settings.biometricLockEnabled, isFalse);
    expect(settings.dailyReminderEnabled, isFalse);
    expect(settings.dailyReminderHour, 20);
    expect(settings.dailyReminderMinute, 0);
  });

  test('updates theme, currency, biometric lock, and period', () async {
    await repository!.updateThemeMode(AppThemePreference.dark);
    await repository!.updateCurrency(
      currencyCode: 'INR',
      currencySymbol: '\u20B9',
    );
    await repository!.updateBiometricLock(true);
    await repository!.updateDailyReminder(enabled: true, hour: 21, minute: 15);
    await repository!.updateInsightsPeriod(InsightsPeriodPreference.monthly);
    await repository!.markInitialSeedCompleted();

    final settings = await repository!.getSettings();
    expect(
      AppThemePreferenceX.fromStorage(settings.themeMode),
      AppThemePreference.dark,
    );
    expect(settings.currencyCode, 'INR');
    expect(settings.currencySymbol, '\u20B9');
    expect(settings.biometricLockEnabled, isTrue);
    expect(settings.dailyReminderEnabled, isTrue);
    expect(settings.dailyReminderHour, 21);
    expect(settings.dailyReminderMinute, 15);
    expect(
      InsightsPeriodPreferenceX.fromStorage(settings.insightsPeriod),
      InsightsPeriodPreference.monthly,
    );
    expect(settings.hasCompletedInitialSeed, isTrue);
  });
}
