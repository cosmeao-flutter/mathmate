import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing theme preferences in SharedPreferences.
class _StorageKeys {
  static const String themeMode = 'theme_mode';
  static const String accentColor = 'accent_color';
}

/// Repository for persisting theme preferences using SharedPreferences.
///
/// This repository handles saving and restoring the user's theme mode
/// (light/dark/system) and accent color preferences.
///
/// Usage:
/// ```dart
/// final repository = await ThemeRepository.create();
///
/// // Save theme mode
/// await repository.saveThemeMode(ThemeMode.dark);
///
/// // Load theme mode
/// final mode = repository.loadThemeMode(); // ThemeMode.dark
///
/// // Save accent color
/// await repository.saveAccentColor(AccentColor.purple);
///
/// // Load accent color
/// final color = repository.loadAccentColor(); // AccentColor.purple
/// ```
class ThemeRepository {
  ThemeRepository._(this._prefs, this._logger);

  /// Creates a [ThemeRepository] for testing with injected dependencies.
  @visibleForTesting
  ThemeRepository.forTesting(this._prefs, {AppLogger? logger})
      : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a new [ThemeRepository] instance.
  ///
  /// This is an async factory because SharedPreferences requires
  /// initialization.
  static Future<ThemeRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeRepository._(prefs, logger ?? AppLogger());
  }

  /// Saves the theme mode to persistent storage.
  Future<void> saveThemeMode(ThemeMode mode) async {
    try {
      final value = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await _prefs.setString(_StorageKeys.themeMode, value);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save theme mode', e, stackTrace);
    }
  }

  /// Loads the saved theme mode from persistent storage.
  ///
  /// Returns [ThemeMode.system] if nothing is saved or value is invalid.
  ThemeMode loadThemeMode() {
    final value = _prefs.getString(_StorageKeys.themeMode);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  /// Saves the accent color to persistent storage.
  Future<void> saveAccentColor(AccentColor color) async {
    try {
      await _prefs.setString(
        _StorageKeys.accentColor,
        color.name,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save accent color',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the saved accent color from persistent storage.
  ///
  /// Returns [AccentColor.blue] if nothing is saved or value is invalid.
  AccentColor loadAccentColor() {
    final value = _prefs.getString(_StorageKeys.accentColor);
    if (value == null) return AccentColor.blue;

    return AccentColor.values
            .where((c) => c.name == value)
            .firstOrNull ??
        AccentColor.blue;
  }
}
