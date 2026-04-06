import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPermissionFailure implements Exception {
  const NotificationPermissionFailure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      'NotificationPermissionFailure(message: $message, cause: $cause)';
}

abstract class INotificationService {
  Future<void> initialize();
  Future<void> ensureReminderPermissions();
  Future<void> syncDailyReminder({
    required bool enabled,
    required int hour,
    required int minute,
  });
  Future<void> cancelDailyReminder();
}

class NotificationService implements INotificationService {
  NotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _dailyReminderId = 9001;
  static const _channelId = 'daily_finance_reminders';
  static const _channelName = 'Daily finance reminders';
  static const _channelDescription =
      'Daily reminders to review spending and log transactions.';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  bool get _supportsScheduledReminders =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Future<void> initialize() async {
    if (_initialized || !_supportsScheduledReminders) {
      return;
    }

    try {
      tz.initializeTimeZones();
      final localTimeZone = await _resolveLocalTimeZone();
      if (localTimeZone != null) {
        tz.setLocalLocation(tz.getLocation(localTimeZone));
      }
    } catch (_) {
      // Best effort only. If the exact timezone cannot be resolved, the plugin
      // still works with the default timezone configuration.
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
    );

    _initialized = true;
  }

  @override
  Future<void> ensureReminderPermissions() async {
    if (!_supportsScheduledReminders) {
      return;
    }

    await initialize();

    try {
      if (Platform.isAndroid) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final notificationsEnabled = await android?.areNotificationsEnabled();
        if (notificationsEnabled != true) {
          final granted = await android?.requestNotificationsPermission();
          if (granted == false) {
            throw const NotificationPermissionFailure(
              'Notification permission was denied. Enable notifications in system settings to use reminders.',
            );
          }
        }

        final canScheduleExact = await android?.canScheduleExactNotifications();
        if (canScheduleExact == false) {
          final exactGranted = await android?.requestExactAlarmsPermission();
          if (exactGranted == false) {
            throw const NotificationPermissionFailure(
              'Exact alarm permission was denied. Allow alarms in Android settings so reminders can trigger on time.',
            );
          }
        }
      } else if (Platform.isIOS) {
        final ios = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        final granted = await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (granted == false) {
          throw const NotificationPermissionFailure(
            'Notification permission was denied. Enable notifications in system settings to use reminders.',
          );
        }
      }
    } on NotificationPermissionFailure {
      rethrow;
    } catch (error) {
      throw NotificationPermissionFailure(
        'Unable to request notification permission on this device.',
        error,
      );
    }
  }

  @override
  Future<void> syncDailyReminder({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    if (!_supportsScheduledReminders) {
      return;
    }

    await initialize();
    await cancelDailyReminder();

    if (!enabled) {
      return;
    }

    final scheduledTime = _nextOccurrence(hour: hour, minute: minute);
    await _plugin.zonedSchedule(
      id: _dailyReminderId,
      title: 'Review today\'s spending',
      body: 'Log your latest transactions and keep your budget on track.',
      scheduledDate: scheduledTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          channelShowBadge: false,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'daily_reminder',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelDailyReminder() async {
    if (!_supportsScheduledReminders) {
      return;
    }

    await initialize();
    await _plugin.cancel(id: _dailyReminderId);
  }

  tz.TZDateTime _nextOccurrence({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour.clamp(0, 23).toInt(),
      minute.clamp(0, 59).toInt(),
    );

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  Future<String?> _resolveLocalTimeZone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return null;
    }
  }
}
