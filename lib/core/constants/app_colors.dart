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

  // ============================================================
  // DARK THEME COLORS
  // ============================================================

  /// Dark theme primary - slightly brighter blue for visibility.
  static const Color primaryDarkTheme = Color(0xFF42A5F5);

  /// Dark theme primary dark shade.
  static const Color primaryDarkThemeDark = Color(0xFF1E88E5);

  /// Dark theme primary light shade.
  static const Color primaryDarkThemeLight = Color(0xFF90CAF9);

  // Dark theme backgrounds
  /// Dark theme main background - near black.
  static const Color backgroundDark = Color(0xFF121212);

  /// Dark theme display background - slightly lighter.
  static const Color displayBackgroundDark = Color(0xFF1E1E1E);

  /// Dark theme surface color.
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Dark theme button colors
  /// Dark theme number buttons - dark gray.
  static const Color numberButtonDark = Color(0xFF2C2C2C);

  /// Dark theme number button pressed.
  static const Color numberButtonPressedDark = Color(0xFF3D3D3D);

  /// Dark theme operator buttons - primary blue.
  static const Color operatorButtonDark = primaryDarkTheme;

  /// Dark theme operator button pressed.
  static const Color operatorButtonPressedDark = primaryDarkThemeDark;

  /// Dark theme function buttons - medium gray.
  static const Color functionButtonDark = Color(0xFF3D3D3D);

  /// Dark theme function button pressed.
  static const Color functionButtonPressedDark = Color(0xFF4D4D4D);

  /// Dark theme equals button.
  static const Color equalsButtonDark = primaryDarkTheme;

  /// Dark theme equals button pressed.
  static const Color equalsButtonPressedDark = primaryDarkThemeDark;

  // Dark theme text colors
  /// Dark theme primary text - white.
  static const Color textPrimaryDark = Color(0xFFFFFFFF);

  /// Dark theme secondary text - light gray.
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  /// Dark theme text on primary buttons.
  static const Color textOnPrimaryDark = Color(0xFF000000);

  /// Dark theme text on number buttons.
  static const Color textOnNumberDark = Color(0xFFFFFFFF);

  /// Dark theme text on function buttons.
  static const Color textOnFunctionDark = Color(0xFFFFFFFF);

  // Dark theme feedback colors
  /// Dark theme error color.
  static const Color errorDark = Color(0xFFEF5350);

  /// Dark theme error text.
  static const Color errorTextDark = Color(0xFFFF8A80);

  /// Dark theme warning color.
  static const Color warningDark = Color(0xFFFFB74D);

  // Dark theme miscellaneous
  /// Dark theme divider color.
  static const Color dividerDark = Color(0xFF3D3D3D);

  /// Dark theme shadow color.
  static const Color shadowDark = Color(0x3D000000);

  /// Dark theme ripple color.
  static const Color rippleDark = Color(0x1FFFFFFF);
}
