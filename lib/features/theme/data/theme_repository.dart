import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
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
  ThemeRepository._(this._prefs);

  final SharedPreferences _prefs;

  /// Creates a new [ThemeRepository] instance.
  ///
  /// This is an async factory because SharedPreferences requires
  /// initialization.
  static Future<ThemeRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeRepository._(prefs);
  }

  /// Saves the theme mode to persistent storage.
  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_StorageKeys.themeMode, value);
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
    await _prefs.setString(_StorageKeys.accentColor, color.name);
  }

  /// Loads the saved accent color from persistent storage.
  ///
  /// Returns [AccentColor.blue] if nothing is saved or value is invalid.
  AccentColor loadAccentColor() {
    final value = _prefs.getString(_StorageKeys.accentColor);
    if (value == null) return AccentColor.blue;

    return AccentColor.values.where((c) => c.name == value).firstOrNull ??
        AccentColor.blue;
  }
}
