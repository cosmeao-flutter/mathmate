import 'package:flutter/foundation.dart';
import 'package:math_mate/core/services/app_logger.dart';
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
  ReminderRepository._(this._prefs, this._logger);

  /// Creates a [ReminderRepository] for testing with injected
  /// dependencies.
  @visibleForTesting
  ReminderRepository.forTesting(
    this._prefs, {
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a new [ReminderRepository] instance.
  static Future<ReminderRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderRepository._(prefs, logger ?? AppLogger());
  }

  /// Saves the reminder enabled preference to persistent storage.
  Future<void> saveReminderEnabled({required bool value}) async {
    try {
      await _prefs.setBool(
        _StorageKeys.reminderEnabled,
        value,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save reminder enabled',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the saved reminder enabled preference.
  ///
  /// Returns `false` if nothing is saved (reminder disabled by default).
  bool loadReminderEnabled() {
    return _prefs.getBool(_StorageKeys.reminderEnabled) ?? false;
  }

  /// Saves the reminder hour to persistent storage.
  Future<void> saveReminderHour({required int value}) async {
    try {
      await _prefs.setInt(_StorageKeys.reminderHour, value);
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save reminder hour',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the saved reminder hour.
  ///
  /// Returns `16` (4:00 PM) if nothing is saved.
  int loadReminderHour() {
    return _prefs.getInt(_StorageKeys.reminderHour) ?? 16;
  }

  /// Saves the reminder minute to persistent storage.
  Future<void> saveReminderMinute({required int value}) async {
    try {
      await _prefs.setInt(_StorageKeys.reminderMinute, value);
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save reminder minute',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the saved reminder minute.
  ///
  /// Returns `0` if nothing is saved.
  int loadReminderMinute() {
    return _prefs.getInt(_StorageKeys.reminderMinute) ?? 0;
  }
}
