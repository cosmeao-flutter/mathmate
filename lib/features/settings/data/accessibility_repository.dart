import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing accessibility preferences in SharedPreferences.
class _StorageKeys {
  static const String reduceMotion = 'reduce_motion';
  static const String hapticFeedback = 'haptic_feedback';
  static const String soundFeedback = 'sound_feedback';
}

/// Repository for persisting accessibility preferences using SharedPreferences.
///
/// This repository handles saving and restoring the user's accessibility
/// settings including reduce motion, haptic feedback, and sound feedback.
///
/// Usage:
/// ```dart
/// final repository = await AccessibilityRepository.create();
///
/// // Save reduce motion preference
/// await repository.saveReduceMotion(value: true);
///
/// // Load reduce motion preference (defaults to false)
/// final reduceMotion = repository.loadReduceMotion();
///
/// // Save haptic feedback preference
/// await repository.saveHapticFeedback(value: false);
///
/// // Load haptic feedback preference (defaults to true)
/// final hapticFeedback = repository.loadHapticFeedback();
///
/// // Save sound feedback preference
/// await repository.saveSoundFeedback(value: true);
///
/// // Load sound feedback preference (defaults to false)
/// final soundFeedback = repository.loadSoundFeedback();
/// ```
class AccessibilityRepository {
  AccessibilityRepository._(this._prefs);

  final SharedPreferences _prefs;

  /// Creates a new [AccessibilityRepository] instance.
  ///
  /// This is an async factory because SharedPreferences requires
  /// initialization.
  static Future<AccessibilityRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AccessibilityRepository._(prefs);
  }

  /// Saves the reduce motion preference to persistent storage.
  Future<void> saveReduceMotion({required bool value}) async {
    await _prefs.setBool(_StorageKeys.reduceMotion, value);
  }

  /// Loads the saved reduce motion preference from persistent storage.
  ///
  /// Returns `false` if nothing is saved (animations enabled by default).
  bool loadReduceMotion() {
    return _prefs.getBool(_StorageKeys.reduceMotion) ?? false;
  }

  /// Saves the haptic feedback preference to persistent storage.
  Future<void> saveHapticFeedback({required bool value}) async {
    await _prefs.setBool(_StorageKeys.hapticFeedback, value);
  }

  /// Loads the saved haptic feedback preference from persistent storage.
  ///
  /// Returns `true` if nothing is saved (haptic feedback enabled by default).
  bool loadHapticFeedback() {
    return _prefs.getBool(_StorageKeys.hapticFeedback) ?? true;
  }

  /// Saves the sound feedback preference to persistent storage.
  Future<void> saveSoundFeedback({required bool value}) async {
    await _prefs.setBool(_StorageKeys.soundFeedback, value);
  }

  /// Loads the saved sound feedback preference from persistent storage.
  ///
  /// Returns `false` if nothing is saved (sound feedback disabled by default).
  bool loadSoundFeedback() {
    return _prefs.getBool(_StorageKeys.soundFeedback) ?? false;
  }
}
