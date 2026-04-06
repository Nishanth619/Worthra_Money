import 'package:isar_community/isar.dart';

part 'app_settings.g.dart';

// Generate the schema with:
// dart run build_runner build --delete-conflicting-outputs
@collection
class AppSettings {
  AppSettings({
    this.id = 1,
    this.themeMode = AppThemePreferenceX.lightValue,
    this.currencyCode = 'USD',
    this.currencySymbol = '\$',
    this.biometricLockEnabled = false,
    this.dailyReminderEnabled = false,
    this.dailyReminderHour = 20,
    this.dailyReminderMinute = 0,
    this.insightsPeriod = InsightsPeriodPreferenceX.weeklyValue,
    this.languageCode = AppLanguagePreferenceX.defaultValue,
    this.hasCompletedInitialSeed = false,
    this.lastSyncAt,
    this.userId,
    this.localUserName,
    this.localUserAvatarIndex = 0,
  });

  Id id;
  String themeMode;
  String currencyCode;
  String currencySymbol;
  bool biometricLockEnabled;
  bool dailyReminderEnabled;
  int dailyReminderHour;
  int dailyReminderMinute;
  String insightsPeriod;

  /// BCP-47 language code for the app UI locale (e.g. 'en', 'es').
  String languageCode;

  bool hasCompletedInitialSeed;

  /// ISO 8601 timestamp of the last successful cloud sync cycle.
  String? lastSyncAt;

  /// Server-assigned user UUID. Null when running in offline-only mode.
  String? userId;

  /// Custom offline user name since account is not required.
  String? localUserName;

  /// Index representing the selected predefined avatar character.
  int localUserAvatarIndex;
}

enum AppThemePreference { light, dark }

extension AppThemePreferenceX on AppThemePreference {
  static const lightValue = 'light';
  static const darkValue = 'dark';

  String get storageValue {
    switch (this) {
      case AppThemePreference.light:
        return lightValue;
      case AppThemePreference.dark:
        return darkValue;
    }
  }

  static AppThemePreference fromStorage(String value) {
    return switch (value) {
      darkValue => AppThemePreference.dark,
      _ => AppThemePreference.light,
    };
  }
}

enum InsightsPeriodPreference { weekly, monthly }

extension InsightsPeriodPreferenceX on InsightsPeriodPreference {
  static const weeklyValue = 'weekly';
  static const monthlyValue = 'monthly';

  String get storageValue {
    switch (this) {
      case InsightsPeriodPreference.weekly:
        return weeklyValue;
      case InsightsPeriodPreference.monthly:
        return monthlyValue;
    }
  }

  static InsightsPeriodPreference fromStorage(String value) {
    return switch (value) {
      monthlyValue => InsightsPeriodPreference.monthly,
      _ => InsightsPeriodPreference.weekly,
    };
  }
}

// ---------------------------------------------------------------------------
// Language preference
// ---------------------------------------------------------------------------

enum AppLanguagePreference { english, spanish }

extension AppLanguagePreferenceX on AppLanguagePreference {
  static const defaultValue = 'en';

  static const _map = {
    'en': AppLanguagePreference.english,
    'es': AppLanguagePreference.spanish,
  };

  String get storageValue {
    switch (this) {
      case AppLanguagePreference.english:
        return 'en';
      case AppLanguagePreference.spanish:
        return 'es';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguagePreference.english:
        return 'English';
      case AppLanguagePreference.spanish:
        return 'Español';
    }
  }

  static AppLanguagePreference fromStorage(String value) {
    return _map[value] ?? AppLanguagePreference.english;
  }
}
