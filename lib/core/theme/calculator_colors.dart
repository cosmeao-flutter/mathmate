import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/constants/app_colors.dart';

/// Custom theme extension for calculator-specific colors.
///
/// This class extends Flutter's theming system with colors specific
/// to our calculator that don't fit in the standard ColorScheme.
///
/// Usage:
/// ```dart
/// final colors = Theme.of(context).extension<CalculatorColors>()!;
/// Container(color: colors.numberButton);
/// ```
///
/// This is the recommended Material 3 approach for custom colors.
@immutable
class CalculatorColors extends ThemeExtension<CalculatorColors> {
  const CalculatorColors({
    // Button backgrounds
    required this.numberButton,
    required this.operatorButton,
    required this.functionButton,
    required this.equalsButton,
    // Button text colors
    required this.textOnNumber,
    required this.textOnOperator,
    required this.textOnFunction,
    required this.textOnEquals,
    // Display colors
    required this.displayBackground,
    required this.expressionText,
    required this.resultText,
    required this.errorText,
  });

  /// Creates light theme calculator colors with a custom accent color.
  ///
  /// The accent color affects operator and equals buttons.
  /// Other colors remain consistent with the light theme.
  factory CalculatorColors.fromAccentLight(AccentColor accent) {
    return CalculatorColors(
      // Button backgrounds - accent affects operator and equals
      numberButton: AppColors.numberButton,
      operatorButton: accent.primaryLight,
      functionButton: AppColors.functionButton,
      equalsButton: accent.primaryLight,
      // Button text colors
      textOnNumber: AppColors.textOnNumber,
      textOnOperator: accent.onPrimaryLight,
      textOnFunction: AppColors.textOnFunction,
      textOnEquals: accent.onPrimaryLight,
      // Display colors
      displayBackground: AppColors.displayBackground,
      expressionText: AppColors.textSecondary,
      resultText: AppColors.textPrimary,
      errorText: AppColors.error,
    );
  }

  /// Creates dark theme calculator colors with a custom accent color.
  ///
  /// The accent color affects operator and equals buttons.
  /// Other colors remain consistent with the dark theme.
  factory CalculatorColors.fromAccentDark(AccentColor accent) {
    return CalculatorColors(
      // Button backgrounds - accent affects operator and equals
      numberButton: AppColors.numberButtonDark,
      operatorButton: accent.primaryDark,
      functionButton: AppColors.functionButtonDark,
      equalsButton: accent.primaryDark,
      // Button text colors
      textOnNumber: AppColors.textOnNumberDark,
      textOnOperator: accent.onPrimaryDark,
      textOnFunction: AppColors.textOnFunctionDark,
      textOnEquals: accent.onPrimaryDark,
      // Display colors
      displayBackground: AppColors.displayBackgroundDark,
      expressionText: AppColors.textSecondaryDark,
      resultText: AppColors.textPrimaryDark,
      errorText: AppColors.errorDark,
    );
  }

  // Button backgrounds
  final Color numberButton;
  final Color operatorButton;
  final Color functionButton;
  final Color equalsButton;

  // Button text colors
  final Color textOnNumber;
  final Color textOnOperator;
  final Color textOnFunction;
  final Color textOnEquals;

  // Display colors
  final Color displayBackground;
  final Color expressionText;
  final Color resultText;
  final Color errorText;

  /// Light theme calculator colors (default blue accent).
  static const light = CalculatorColors(
    // Button backgrounds
    numberButton: AppColors.numberButton,
    operatorButton: AppColors.operatorButton,
    functionButton: AppColors.functionButton,
    equalsButton: AppColors.equalsButton,
    // Button text colors
    textOnNumber: AppColors.textOnNumber,
    textOnOperator: AppColors.textOnPrimary,
    textOnFunction: AppColors.textOnFunction,
    textOnEquals: AppColors.textOnPrimary,
    // Display colors
    displayBackground: AppColors.displayBackground,
    expressionText: AppColors.textSecondary,
    resultText: AppColors.textPrimary,
    errorText: AppColors.error,
  );

  /// Dark theme calculator colors (default blue accent).
  static const dark = CalculatorColors(
    // Button backgrounds
    numberButton: AppColors.numberButtonDark,
    operatorButton: AppColors.operatorButtonDark,
    functionButton: AppColors.functionButtonDark,
    equalsButton: AppColors.equalsButtonDark,
    // Button text colors
    textOnNumber: AppColors.textOnNumberDark,
    textOnOperator: AppColors.textOnPrimaryDark,
    textOnFunction: AppColors.textOnFunctionDark,
    textOnEquals: AppColors.textOnPrimaryDark,
    // Display colors
    displayBackground: AppColors.displayBackgroundDark,
    expressionText: AppColors.textSecondaryDark,
    resultText: AppColors.textPrimaryDark,
    errorText: AppColors.errorDark,
  );

  @override
  CalculatorColors copyWith({
    Color? numberButton,
    Color? operatorButton,
    Color? functionButton,
    Color? equalsButton,
    Color? textOnNumber,
    Color? textOnOperator,
    Color? textOnFunction,
    Color? textOnEquals,
    Color? displayBackground,
    Color? expressionText,
    Color? resultText,
    Color? errorText,
  }) {
    return CalculatorColors(
      numberButton: numberButton ?? this.numberButton,
      operatorButton: operatorButton ?? this.operatorButton,
      functionButton: functionButton ?? this.functionButton,
      equalsButton: equalsButton ?? this.equalsButton,
      textOnNumber: textOnNumber ?? this.textOnNumber,
      textOnOperator: textOnOperator ?? this.textOnOperator,
      textOnFunction: textOnFunction ?? this.textOnFunction,
      textOnEquals: textOnEquals ?? this.textOnEquals,
      displayBackground: displayBackground ?? this.displayBackground,
      expressionText: expressionText ?? this.expressionText,
      resultText: resultText ?? this.resultText,
      errorText: errorText ?? this.errorText,
    );
  }

  @override
  CalculatorColors lerp(CalculatorColors? other, double t) {
    if (other is! CalculatorColors) return this;
    return CalculatorColors(
      numberButton: Color.lerp(numberButton, other.numberButton, t)!,
      operatorButton: Color.lerp(operatorButton, other.operatorButton, t)!,
      functionButton: Color.lerp(functionButton, other.functionButton, t)!,
      equalsButton: Color.lerp(equalsButton, other.equalsButton, t)!,
      textOnNumber: Color.lerp(textOnNumber, other.textOnNumber, t)!,
      textOnOperator: Color.lerp(textOnOperator, other.textOnOperator, t)!,
      textOnFunction: Color.lerp(textOnFunction, other.textOnFunction, t)!,
      textOnEquals: Color.lerp(textOnEquals, other.textOnEquals, t)!,
      displayBackground:
          Color.lerp(displayBackground, other.displayBackground, t)!,
      expressionText: Color.lerp(expressionText, other.expressionText, t)!,
      resultText: Color.lerp(resultText, other.resultText, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
    );
  }
}
