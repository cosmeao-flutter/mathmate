import 'package:flutter/foundation.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing onboarding preferences in SharedPreferences.
class _StorageKeys {
  static const String completed = 'onboarding_completed';
}

/// Repository for persisting onboarding completion status.
///
/// Tracks whether the user has completed the onboarding tutorial.
/// Returns `false` by default (first launch).
///
/// Usage:
/// ```dart
/// final repository = await OnboardingRepository.create();
///
/// // Check if onboarding was completed
/// final done = repository.loadCompleted(); // false on first launch
///
/// // Mark onboarding as completed
/// await repository.saveCompleted(value: true);
/// ```
class OnboardingRepository {
  OnboardingRepository._(this._prefs, this._logger);

  /// Creates an [OnboardingRepository] for testing with injected
  /// dependencies.
  @visibleForTesting
  OnboardingRepository.forTesting(
    this._prefs, {
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a new [OnboardingRepository] instance.
  static Future<OnboardingRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return OnboardingRepository._(prefs, logger ?? AppLogger());
  }

  /// Saves the onboarding completion status.
  Future<void> saveCompleted({required bool value}) async {
    try {
      await _prefs.setBool(_StorageKeys.completed, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save onboarding completed', e, stackTrace);
    }
  }

  /// Loads the onboarding completion status.
  ///
  /// Returns `false` if not saved (first launch).
  bool loadCompleted() {
    return _prefs.getBool(_StorageKeys.completed) ?? false;
  }
}
