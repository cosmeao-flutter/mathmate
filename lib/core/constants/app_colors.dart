import 'package:flutter/material.dart';

/// App color palette for MathMate calculator.
///
/// This class contains all the colors used throughout the app.
/// Using a centralized color system makes it easy to:
/// - Maintain consistency across the app
/// - Update colors in one place
/// - Support future theming (dark mode, custom colors)
///
/// Color scheme inspired by Google Calculator with a blue accent.
abstract class AppColors {
  // ============================================================
  // PRIMARY COLORS
  // ============================================================

  /// Primary blue accent color - used for operators and equals button.
  /// This is the main brand color of the app.
  static const Color primary = Color(0xFF2196F3);

  /// Darker shade of primary for pressed states.
  static const Color primaryDark = Color(0xFF1976D2);

  /// Lighter shade of primary for highlights.
  static const Color primaryLight = Color(0xFF64B5F6);

  // ============================================================
  // BACKGROUND COLORS
  // ============================================================

  /// Main app background color - light gray.
  static const Color background = Color(0xFFF5F5F5);

  /// Display area background - white for contrast.
  static const Color displayBackground = Color(0xFFFFFFFF);

  /// Surface color for cards, dialogs, etc.
  static const Color surface = Color(0xFFFFFFFF);

  // ============================================================
  // BUTTON COLORS
  // ============================================================

  /// Number buttons (0-9) - white background.
  static const Color numberButton = Color(0xFFFFFFFF);

  /// Number button when pressed.
  static const Color numberButtonPressed = Color(0xFFE0E0E0);

  /// Operator buttons (+, −, ×, ÷) - primary blue.
  static const Color operatorButton = primary;

  /// Operator button when pressed.
  static const Color operatorButtonPressed = primaryDark;

  /// Function buttons (C, %, ±, parentheses) - light gray.
  static const Color functionButton = Color(0xFFE0E0E0);

  /// Function button when pressed.
  static const Color functionButtonPressed = Color(0xFFBDBDBD);

  /// Equals button - same as primary.
  static const Color equalsButton = primary;

  /// Equals button when pressed.
  static const Color equalsButtonPressed = primaryDark;

  // ============================================================
  // TEXT COLORS
  // ============================================================

  /// Primary text color - dark gray for readability.
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary text color - medium gray for less emphasis.
  static const Color textSecondary = Color(0xFF757575);

  /// Text on primary/operator buttons - white.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text on number buttons - dark.
  static const Color textOnNumber = textPrimary;

  /// Text on function buttons - dark.
  static const Color textOnFunction = textPrimary;

  // ============================================================
  // FEEDBACK COLORS
  // ============================================================

  /// Error color - for error messages and invalid states.
  static const Color error = Color(0xFFE53935);

  /// Error text color.
  static const Color errorText = Color(0xFFB71C1C);

  /// Warning color - for unmatched parentheses, etc.
  static const Color warning = Color(0xFFFF9800);

  // ============================================================
  // MISCELLANEOUS
  // ============================================================

  /// Divider/separator color.
  static const Color divider = Color(0xFFE0E0E0);

  /// Shadow color with opacity.
  static const Color shadow = Color(0x1A000000);

  /// Ripple effect color for buttons.
  static const Color ripple = Color(0x1F000000);
}
