import 'package:flutter/foundation.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing locale preferences in SharedPreferences.
class _StorageKeys {
  static const String locale = 'locale';
}

/// Repository for persisting the user's language preference.
///
/// Stores an optional language code (e.g., 'en', 'es').
/// A null value means "follow system default".
///
/// Usage:
/// ```dart
/// final repository = await LocaleRepository.create();
///
/// // Save Spanish
/// await repository.saveLocale('es');
///
/// // Load saved locale (null = system default)
/// final code = repository.loadLocale();
///
/// // Clear to system default
/// await repository.saveLocale(null);
/// ```
class LocaleRepository {
  LocaleRepository._(this._prefs, this._logger);

  /// Creates a [LocaleRepository] for testing with injected
  /// dependencies.
  @visibleForTesting
  LocaleRepository.forTesting(
    this._prefs, {
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a new [LocaleRepository] instance.
  static Future<LocaleRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return LocaleRepository._(prefs, logger ?? AppLogger());
  }

  /// Saves the language code to persistent storage.
  ///
  /// Pass `null` to remove the saved locale (revert to system
  /// default).
  Future<void> saveLocale(String? languageCode) async {
    try {
      if (languageCode == null) {
        await _prefs.remove(_StorageKeys.locale);
      } else {
        await _prefs.setString(
          _StorageKeys.locale,
          languageCode,
        );
      }
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save locale', e, stackTrace);
    }
  }

  /// Loads the saved language code from persistent storage.
  ///
  /// Returns `null` if no locale is saved (system default).
  String? loadLocale() {
    return _prefs.getString(_StorageKeys.locale);
  }
}
