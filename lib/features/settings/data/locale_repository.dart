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
  LocaleRepository._(this._prefs);

  final SharedPreferences _prefs;

  /// Creates a new [LocaleRepository] instance.
  static Future<LocaleRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocaleRepository._(prefs);
  }

  /// Saves the language code to persistent storage.
  ///
  /// Pass `null` to remove the saved locale (revert to system default).
  Future<void> saveLocale(String? languageCode) async {
    if (languageCode == null) {
      await _prefs.remove(_StorageKeys.locale);
    } else {
      await _prefs.setString(_StorageKeys.locale, languageCode);
    }
  }

  /// Loads the saved language code from persistent storage.
  ///
  /// Returns `null` if no locale is saved (system default).
  String? loadLocale() {
    return _prefs.getString(_StorageKeys.locale);
  }
}
