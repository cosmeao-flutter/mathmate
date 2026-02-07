import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service class wrapping `flutter_local_notifications` for scheduling
/// daily homework reminders.
///
/// Unlike repository classes (which wrap SharedPreferences), this service
/// wraps a native plugin that interacts with the OS notification system.
class NotificationService {
  NotificationService._(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _notificationId = 0;
  static const _channelId = 'homework_reminder';
  static const _channelName = 'Homework Reminder';
  static const _channelDescription = 'Daily homework reminder notifications';

  /// Creates and initializes a [NotificationService].
  ///
  /// Initializes the notification plugin and timezone data.
  static Future<NotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await plugin.initialize(settings);

    // Initialize timezone data
    tz.initializeTimeZones();
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } on Exception {
      // Fallback to UTC if device timezone cannot be determined
      tz.setLocalLocation(tz.UTC);
    }

    return NotificationService._(plugin);
  }

  /// Requests notification permission from the user (iOS).
  ///
  /// Returns `true` if permission was granted, `false` otherwise.
  Future<bool> requestPermission() async {
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin == null) return true;

    final result = await iosPlugin.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    return result ?? false;
  }

  /// Schedules a daily notification at the given [hour] and [minute].
  ///
  /// Uses `zonedSchedule` with `DateTimeComponents.time` for daily
  /// recurrence. Cancels any existing reminder before scheduling.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await cancelReminder();

    final scheduledTime = _nextInstanceOfTime(hour, minute);

    await _plugin.zonedSchedule(
      _notificationId,
      'Homework Time!',
      "Don't forget to do your homework today.",
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Cancels the scheduled daily reminder.
  Future<void> cancelReminder() async {
    await _plugin.cancel(_notificationId);
  }

  /// Computes the next occurrence of [hour]:[minute] in the local timezone.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
