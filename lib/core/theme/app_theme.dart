import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/constants/app_colors.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/theme/calculator_colors.dart';

/// App theme configuration for MathMate calculator.
///
/// This class provides the ThemeData used throughout the app.
/// Currently implements light theme only (MVP).
///
/// Flutter's theming system allows us to define:
/// - Colors (colorScheme)
/// - Typography (textTheme)
/// - Component styles (elevatedButtonTheme, etc.)
///
/// By defining everything here, widgets automatically inherit
/// consistent styling without hardcoding values.
abstract class AppTheme {
  /// Light theme for the app (default).
  ///
  /// This is the main theme used in the MVP.
  /// Based on Material 3 design with custom colors.
  static ThemeData get light {
    // Define the color scheme based on our app colors
    const colorScheme = ColorScheme.light(
      // Primary colors
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,

      // Secondary colors (same as primary for MVP)
      secondary: AppColors.primary,
      onSecondary: AppColors.textOnPrimary,

      // Surface color
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      // Error colors
      error: AppColors.error,
    );

    return ThemeData(
      // Enable Material 3 design
      useMaterial3: true,

      // Apply our color scheme
      colorScheme: colorScheme,

      // Background color for Scaffold
      scaffoldBackgroundColor: AppColors.background,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Text theme with custom sizes
      textTheme: const TextTheme(
        // Display large - for main result
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontSizeResult,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          letterSpacing: -1,
        ),

        // Display medium - for expression
        displayMedium: TextStyle(
          fontSize: AppDimensions.fontSizeExpression,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondary,
        ),

        // Title large - for button text
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontSizeButton,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),

        // Body small - for error messages
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSizeError,
          fontWeight: FontWeight.w400,
          color: AppColors.errorText,
        ),
      ),

      // Elevated button theme (for calculator buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Default colors (will be overridden per button type)
          backgroundColor: AppColors.numberButton,
          foregroundColor: AppColors.textOnNumber,

          // Shape
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.buttonBorderRadius,
            ),
          ),

          // Size
          minimumSize: const Size(
            AppDimensions.buttonMinSize,
            AppDimensions.buttonHeight,
          ),

          // Elevation
          elevation: AppDimensions.buttonElevation,

          // Animation
          animationDuration: const Duration(
            milliseconds: AppDimensions.animationFast,
          ),

          // Text style
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeButton,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Splash/ripple effect
      splashFactory: InkRipple.splashFactory,

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),

      // Custom calculator colors extension
      extensions: const [CalculatorColors.light],
    );
  }

  /// Dark theme for the app.
  ///
  /// Matches the light theme structure but with dark colors.
  /// Uses brighter accent colors for visibility against dark backgrounds.
  static ThemeData get dark {
    // Define the color scheme for dark mode
    const colorScheme = ColorScheme.dark(
      // Primary colors - brighter blue for dark mode
      primary: AppColors.primaryDarkTheme,
      onPrimary: AppColors.textOnPrimaryDark,

      // Secondary colors (same as primary for MVP)
      secondary: AppColors.primaryDarkTheme,
      onSecondary: AppColors.textOnPrimaryDark,

      // Surface color
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,

      // Error colors
      error: AppColors.errorDark,
    );

    return ThemeData(
      // Enable Material 3 design
      useMaterial3: true,

      // Apply our color scheme
      colorScheme: colorScheme,

      // Background color for Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // Text theme with custom sizes
      textTheme: const TextTheme(
        // Display large - for main result
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontSizeResult,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
          letterSpacing: -1,
        ),

        // Display medium - for expression
        displayMedium: TextStyle(
          fontSize: AppDimensions.fontSizeExpression,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondaryDark,
        ),

        // Title large - for button text
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontSizeButton,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),

        // Body small - for error messages
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSizeError,
          fontWeight: FontWeight.w400,
          color: AppColors.errorTextDark,
        ),
      ),

      // Elevated button theme (for calculator buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Default colors for dark mode
          backgroundColor: AppColors.numberButtonDark,
          foregroundColor: AppColors.textOnNumberDark,

          // Shape
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.buttonBorderRadius,
            ),
          ),

          // Size
          minimumSize: const Size(
            AppDimensions.buttonMinSize,
            AppDimensions.buttonHeight,
          ),

          // Elevation
          elevation: AppDimensions.buttonElevation,

          // Animation
          animationDuration: const Duration(
            milliseconds: AppDimensions.animationFast,
          ),

          // Text style
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeButton,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Splash/ripple effect
      splashFactory: InkRipple.splashFactory,

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),

      // Custom calculator colors extension
      extensions: const [CalculatorColors.dark],
    );
  }

  /// Creates a light theme with a custom accent color.
  ///
  /// Use this when the user has selected a custom accent color.
  static ThemeData lightWithAccent(AccentColor accent) {
    // For default blue, use the optimized static theme
    if (accent == AccentColor.blue) {
      return light;
    }

    final colorScheme = ColorScheme.light(
      primary: accent.primaryLight,
      onPrimary: accent.onPrimaryLight,
      secondary: accent.primaryLight,
      onSecondary: accent.onPrimaryLight,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontSizeResult,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: AppDimensions.fontSizeExpression,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondary,
        ),
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontSizeButton,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSizeError,
          fontWeight: FontWeight.w400,
          color: AppColors.errorText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.numberButton,
          foregroundColor: AppColors.textOnNumber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.buttonBorderRadius,
            ),
          ),
          minimumSize: const Size(
            AppDimensions.buttonMinSize,
            AppDimensions.buttonHeight,
          ),
          elevation: AppDimensions.buttonElevation,
          animationDuration: const Duration(
            milliseconds: AppDimensions.animationFast,
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeButton,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      splashFactory: InkRipple.splashFactory,
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      extensions: [CalculatorColors.fromAccentLight(accent)],
    );
  }

  /// Creates a dark theme with a custom accent color.
  ///
  /// Use this when the user has selected a custom accent color.
  static ThemeData darkWithAccent(AccentColor accent) {
    // For default blue, use the optimized static theme
    if (accent == AccentColor.blue) {
      return dark;
    }

    final colorScheme = ColorScheme.dark(
      primary: accent.primaryDark,
      onPrimary: accent.onPrimaryDark,
      secondary: accent.primaryDark,
      onSecondary: accent.onPrimaryDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.errorDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppDimensions.fontSizeResult,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
          letterSpacing: -1,
        ),
        displayMedium: TextStyle(
          fontSize: AppDimensions.fontSizeExpression,
          fontWeight: FontWeight.w300,
          color: AppColors.textSecondaryDark,
        ),
        titleLarge: TextStyle(
          fontSize: AppDimensions.fontSizeButton,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        bodySmall: TextStyle(
          fontSize: AppDimensions.fontSizeError,
          fontWeight: FontWeight.w400,
          color: AppColors.errorTextDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.numberButtonDark,
          foregroundColor: AppColors.textOnNumberDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.buttonBorderRadius,
            ),
          ),
          minimumSize: const Size(
            AppDimensions.buttonMinSize,
            AppDimensions.buttonHeight,
          ),
          elevation: AppDimensions.buttonElevation,
          animationDuration: const Duration(
            milliseconds: AppDimensions.animationFast,
          ),
          textStyle: const TextStyle(
            fontSize: AppDimensions.fontSizeButton,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      splashFactory: InkRipple.splashFactory,
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),
      extensions: [CalculatorColors.fromAccentDark(accent)],
    );
  }
}
