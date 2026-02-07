import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing reminder preferences in SharedPreferences.
class _StorageKeys {
  static const String reminderEnabled = 'reminder_enabled';
  static const String reminderHour = 'reminder_hour';
  static const String reminderMinute = 'reminder_minute';
}

/// Repository for persisting homework reminder preferences using
/// SharedPreferences.
///
/// Stores whether the reminder is enabled and the scheduled time (hour and
/// minute). Defaults to disabled at 4:00 PM.
class ReminderRepository {
  ReminderRepository._(this._prefs);

  final SharedPreferences _prefs;

  /// Creates a new [ReminderRepository] instance.
  static Future<ReminderRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderRepository._(prefs);
  }

  /// Saves the reminder enabled preference to persistent storage.
  Future<void> saveReminderEnabled({required bool value}) async {
    await _prefs.setBool(_StorageKeys.reminderEnabled, value);
  }

  /// Loads the saved reminder enabled preference.
  ///
  /// Returns `false` if nothing is saved (reminder disabled by default).
  bool loadReminderEnabled() {
    return _prefs.getBool(_StorageKeys.reminderEnabled) ?? false;
  }

  /// Saves the reminder hour to persistent storage.
  Future<void> saveReminderHour({required int value}) async {
    await _prefs.setInt(_StorageKeys.reminderHour, value);
  }

  /// Loads the saved reminder hour.
  ///
  /// Returns `16` (4:00 PM) if nothing is saved.
  int loadReminderHour() {
    return _prefs.getInt(_StorageKeys.reminderHour) ?? 16;
  }

  /// Saves the reminder minute to persistent storage.
  Future<void> saveReminderMinute({required int value}) async {
    await _prefs.setInt(_StorageKeys.reminderMinute, value);
  }

  /// Loads the saved reminder minute.
  ///
  /// Returns `0` if nothing is saved.
  int loadReminderMinute() {
    return _prefs.getInt(_StorageKeys.reminderMinute) ?? 0;
  }
}
