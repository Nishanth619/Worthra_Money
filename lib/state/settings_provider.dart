import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_auth_service.dart';
import '../models/app_settings.dart';
import 'notification_provider.dart';
import 'database_provider.dart';
import 'local_auth_provider.dart';

final settingsRefreshProvider = StreamProvider<int>((ref) async* {
  final repository = await ref.watch(settingsRepositoryProvider.future);
  var tick = 0;

  await for (final _ in repository.watchSettings()) {
    yield tick++;
  }
});

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  ref.watch(settingsRefreshProvider);
  final repository = await ref.watch(settingsRepositoryProvider.future);
  return repository.getSettings();
});

final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final preference = settings != null
      ? AppThemePreferenceX.fromStorage(settings.themeMode)
      : AppThemePreference.light;

  return switch (preference) {
    AppThemePreference.dark => ThemeMode.dark,
    AppThemePreference.light => ThemeMode.light,
  };
});

final appLocaleProvider = Provider<Locale>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final code = settings?.languageCode ?? AppLanguagePreferenceX.defaultValue;
  return Locale(code);
});

final currencyCodeProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsProvider).value;
  return settings?.currencyCode ?? 'USD';
});

final currencySymbolProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsProvider).value;
  return settings?.currencySymbol ?? '\$';
});

final insightsPeriodProvider = Provider<InsightsPeriodPreference>((ref) {
  final settings = ref.watch(settingsProvider).value;
  if (settings != null) {
    return InsightsPeriodPreferenceX.fromStorage(settings.insightsPeriod);
  }
  return InsightsPeriodPreference.weekly;
});

final dailyReminderEnabledProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsProvider).value;
  return settings?.dailyReminderEnabled ?? false;
});

class SettingsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> setThemeMode(AppThemePreference themeMode) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateThemeMode(themeMode);
    });
  }

  Future<void> setCurrency({
    required String currencyCode,
    required String currencySymbol,
  }) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateCurrency(
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
      );
    });
  }

  Future<void> setBiometricLock(bool enabled) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    final authService = ref.read(localAuthServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (enabled) {
        await authService.ensureBiometricsAvailable();
        final result = await authService.authenticate(
          reason: 'Authenticate to enable biometric app lock.',
        );
        if (!result.isAuthenticated) {
          throw const LocalAuthFailure(
            'Biometric authentication was cancelled.',
          );
        }
      } else {
        await authService.cancelAuthentication();
      }
      await repository.updateBiometricLock(enabled);
    });
  }

  Future<void> setDailyReminderEnabled(bool enabled) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    final notificationService = ref.read(notificationServiceProvider);
    final settings = await repository.getSettings();

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (enabled) {
        await notificationService.ensureReminderPermissions();
      }

      await repository.updateDailyReminder(
        enabled: enabled,
        hour: settings.dailyReminderHour,
        minute: settings.dailyReminderMinute,
      );

      if (enabled) {
        await notificationService.syncDailyReminder(
          enabled: true,
          hour: settings.dailyReminderHour,
          minute: settings.dailyReminderMinute,
        );
      } else {
        await notificationService.cancelDailyReminder();
      }
    });
  }

  Future<void> setDailyReminderTime(TimeOfDay time) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    final notificationService = ref.read(notificationServiceProvider);
    final settings = await repository.getSettings();

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateDailyReminder(
        enabled: settings.dailyReminderEnabled,
        hour: time.hour,
        minute: time.minute,
      );

      if (settings.dailyReminderEnabled) {
        await notificationService.syncDailyReminder(
          enabled: true,
          hour: time.hour,
          minute: time.minute,
        );
      }
    });
  }

  Future<void> setInsightsPeriod(InsightsPeriodPreference period) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateInsightsPeriod(period);
    });
  }

  Future<void> setLanguage(AppLanguagePreference language) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateLanguage(language);
    });
  }

  Future<void> setLocalProfile({String? name, required int avatarIndex}) async {
    final repository = await ref.read(settingsRepositoryProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateLocalProfile(name: name, avatarIndex: avatarIndex);
    });
  }

  Future<String> exportTransactionsCsv() async {
    final repository = await ref.read(appDataRepositoryProvider.future);
    final currencySymbol = ref.read(currencySymbolProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.exportTransactionsCsv(currencySymbol: currencySymbol),
    );
    state = result.whenData((_) {});
    if (result.hasError) {
      throw result.error!;
    }
    return result.requireValue;
  }

  Future<String> exportInsightsReport() async {
    final repository = await ref.read(appDataRepositoryProvider.future);
    final currencySymbol = ref.read(currencySymbolProvider);
    final period = ref.read(insightsPeriodProvider);
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => repository.exportInsightsReport(
        period: period,
        currencySymbol: currencySymbol,
      ),
    );
    state = result.whenData((_) {});
    if (result.hasError) {
      throw result.error!;
    }
    return result.requireValue;
  }

  Future<void> clearAllData() async {
    final repository = await ref.read(appDataRepositoryProvider.future);
    final notificationService = ref.read(notificationServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await notificationService.cancelDailyReminder();
      await repository.clearAllAppData();
    });
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, void>(SettingsController.new);
