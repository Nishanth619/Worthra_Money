import 'package:isar_community/isar.dart';

import '../models/app_settings.dart';
import 'repository_exception.dart';

abstract class ISettingsRepository {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> updateThemeMode(AppThemePreference themeMode);
  Future<void> updateCurrency({
    required String currencyCode,
    required String currencySymbol,
  });
  Future<void> updateBiometricLock(bool enabled);
  Future<void> updateDailyReminder({
    required bool enabled,
    required int hour,
    required int minute,
  });
  Future<void> updateInsightsPeriod(InsightsPeriodPreference period);
  Future<void> updateLanguage(AppLanguagePreference language);
  Future<void> markInitialSeedCompleted();
  Future<void> resetSettings({bool preserveInitialSeedFlag = true});
  Future<void> updateUserId(String? userId);
  Future<void> updateLocalProfile({String? name, required int avatarIndex});
  Future<void> updateLastSyncAt(DateTime syncedAt);
  Stream<void> watchSettings();
}

class SettingsRepository implements ISettingsRepository {
  SettingsRepository(this._isar);

  static const settingsId = 1;

  final Isar _isar;

  IsarCollection<AppSettings> get _settings => _isar.appSettings;

  @override
  Future<AppSettings> getSettings() async {
    try {
      final existing = await _settings.get(settingsId);
      if (existing != null) {
        return existing;
      }

      final defaults = AppSettings(id: settingsId);
      await saveSettings(defaults);
      return defaults;
    } catch (error) {
      throw RepositoryException('Failed to load app settings.', error);
    }
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      settings.id = settingsId;
      await _isar.writeTxn(() async {
        await _settings.put(settings);
      });
    } catch (error) {
      throw RepositoryException('Failed to save app settings.', error);
    }
  }

  @override
  Future<void> updateThemeMode(AppThemePreference themeMode) async {
    final settings = await getSettings();
    settings.themeMode = themeMode.storageValue;
    await saveSettings(settings);
  }

  @override
  Future<void> updateCurrency({
    required String currencyCode,
    required String currencySymbol,
  }) async {
    final settings = await getSettings();
    settings.currencyCode = currencyCode;
    settings.currencySymbol = currencySymbol;
    await saveSettings(settings);
  }

  @override
  Future<void> updateBiometricLock(bool enabled) async {
    final settings = await getSettings();
    settings.biometricLockEnabled = enabled;
    await saveSettings(settings);
  }

  @override
  Future<void> updateDailyReminder({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    final settings = await getSettings();
    settings.dailyReminderEnabled = enabled;
    settings.dailyReminderHour = hour.clamp(0, 23).toInt();
    settings.dailyReminderMinute = minute.clamp(0, 59).toInt();
    await saveSettings(settings);
  }

  @override
  Future<void> updateInsightsPeriod(InsightsPeriodPreference period) async {
    final settings = await getSettings();
    settings.insightsPeriod = period.storageValue;
    await saveSettings(settings);
  }

  @override
  Future<void> updateLanguage(AppLanguagePreference language) async {
    final settings = await getSettings();
    settings.languageCode = language.storageValue;
    await saveSettings(settings);
  }

  @override
  Future<void> markInitialSeedCompleted() async {
    final settings = await getSettings();
    if (settings.hasCompletedInitialSeed) {
      return;
    }

    settings.hasCompletedInitialSeed = true;
    await saveSettings(settings);
  }

  @override
  Future<void> resetSettings({bool preserveInitialSeedFlag = true}) async {
    final current = await getSettings();
    final reset = AppSettings(
      id: settingsId,
      hasCompletedInitialSeed: preserveInitialSeedFlag
          ? current.hasCompletedInitialSeed
          : false,
    );
    await saveSettings(reset);
  }

  @override
  Future<void> updateUserId(String? userId) async {
    final settings = await getSettings();
    settings.userId = userId;
    await saveSettings(settings);
  }

  @override
  Future<void> updateLocalProfile({
    String? name,
    required int avatarIndex,
  }) async {
    final settings = await getSettings();
    settings.localUserName = name;
    settings.localUserAvatarIndex = avatarIndex;
    await saveSettings(settings);
  }

  @override
  Future<void> updateLastSyncAt(DateTime syncedAt) async {
    final settings = await getSettings();
    settings.lastSyncAt = syncedAt.toIso8601String();
    await saveSettings(settings);
  }

  @override
  Stream<void> watchSettings() {
    return _settings.watchLazy(fireImmediately: true);
  }
}
