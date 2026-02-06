import 'package:flutter/material.dart';

/// Available accent color options for the calculator.
///
/// Each accent color defines a primary color that is used for
/// operator buttons, equals button, and other accent elements.
enum AccentColor {
  /// Blue accent (default) - Google Calculator inspired.
  blue,

  /// Green accent - nature/calm theme.
  green,

  /// Purple accent - creative/modern theme.
  purple,

  /// Orange accent - energetic/warm theme.
  orange,

  /// Teal accent - professional/balanced theme.
  teal,
}

/// Extension to provide color values for each accent.
extension AccentColorValues on AccentColor {
  /// Display name for settings UI.
  String get displayName {
    switch (this) {
      case AccentColor.blue:
        return 'Blue';
      case AccentColor.green:
        return 'Green';
      case AccentColor.purple:
        return 'Purple';
      case AccentColor.orange:
        return 'Orange';
      case AccentColor.teal:
        return 'Teal';
    }
  }

  // ============================================================
  // LIGHT THEME COLORS
  // ============================================================

  /// Primary color for light theme.
  Color get primaryLight {
    switch (this) {
      case AccentColor.blue:
        return const Color(0xFF2196F3);
      case AccentColor.green:
        return const Color(0xFF4CAF50);
      case AccentColor.purple:
        return const Color(0xFF9C27B0);
      case AccentColor.orange:
        return const Color(0xFFFF9800);
      case AccentColor.teal:
        return const Color(0xFF009688);
    }
  }

  /// Darker shade for pressed states (light theme).
  Color get primaryDarkLight {
    switch (this) {
      case AccentColor.blue:
        return const Color(0xFF1976D2);
      case AccentColor.green:
        return const Color(0xFF388E3C);
      case AccentColor.purple:
        return const Color(0xFF7B1FA2);
      case AccentColor.orange:
        return const Color(0xFFF57C00);
      case AccentColor.teal:
        return const Color(0xFF00796B);
    }
  }

  /// Lighter shade for highlights (light theme).
  Color get primaryLightLight {
    switch (this) {
      case AccentColor.blue:
        return const Color(0xFF64B5F6);
      case AccentColor.green:
        return const Color(0xFF81C784);
      case AccentColor.purple:
        return const Color(0xFFBA68C8);
      case AccentColor.orange:
        return const Color(0xFFFFB74D);
      case AccentColor.teal:
        return const Color(0xFF4DB6AC);
    }
  }

  /// Text color on primary background (light theme).
  /// Most colors use white, but orange uses dark for better contrast.
  Color get onPrimaryLight {
    switch (this) {
      case AccentColor.blue:
      case AccentColor.green:
      case AccentColor.purple:
      case AccentColor.teal:
        return const Color(0xFFFFFFFF);
      case AccentColor.orange:
        return const Color(0xFF212121);
    }
  }

  // ============================================================
  // DARK THEME COLORS
  // ============================================================

  /// Primary color for dark theme (brighter for visibility).
  Color get primaryDark {
    switch (this) {
      case AccentColor.blue:
        return const Color(0xFF42A5F5);
      case AccentColor.green:
        return const Color(0xFF66BB6A);
      case AccentColor.purple:
        return const Color(0xFFAB47BC);
      case AccentColor.orange:
        return const Color(0xFFFFB74D);
      case AccentColor.teal:
        return const Color(0xFF26A69A);
    }
  }

  /// Darker shade for pressed states (dark theme).
  Color get primaryDarkDark {
    switch (this) {
      case AccentColor.blue:
        return const Color(0xFF1E88E5);
      case AccentColor.green:
        return const Color(0xFF43A047);
      case AccentColor.purple:
        return const Color(0xFF8E24AA);
      case AccentColor.orange:
        return const Color(0xFFFFA726);
      case AccentColor.teal:
        return const Color(0xFF00897B);
    }
  }

  /// Lighter shade for highlights (dark theme).
  Color get primaryLightDark {
    switch (this) {
      case AccentColor.blue:
        return const Color(0xFF90CAF9);
      case AccentColor.green:
        return const Color(0xFFA5D6A7);
      case AccentColor.purple:
        return const Color(0xFFCE93D8);
      case AccentColor.orange:
        return const Color(0xFFFFCC80);
      case AccentColor.teal:
        return const Color(0xFF80CBC4);
    }
  }

  /// Text color on primary background (dark theme).
  /// Dark theme accent buttons typically use dark text for contrast.
  Color get onPrimaryDark {
    return const Color(0xFF000000);
  }
}
