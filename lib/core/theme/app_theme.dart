import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_mate/core/constants/app_colors.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';

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
    );
  }

  /// Dark theme for the app (future implementation).
  ///
  /// Placeholder for Phase 3 when we add theme switching.
  static ThemeData get dark {
    // For now, return light theme (dark theme coming in Phase 3)
    return light;
  }
}
