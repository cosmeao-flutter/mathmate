import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/app_fonts.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/theme/calculator_colors.dart';

/// A dual-line calculator display showing expression and result.
///
/// The display has two sections:
/// - **Top line**: Current expression (smaller, secondary text color)
/// - **Bottom line**: Result or live preview (larger, primary text color)
///
/// When an error occurs, the error message replaces the result line
/// and is displayed in red.
///
/// Example usage:
/// ```dart
/// CalculatorDisplay(
///   expression: '2 + 3 × 4',
///   result: '14',
/// )
/// ```
///
/// With error:
/// ```dart
/// CalculatorDisplay(
///   expression: '5 ÷ 0',
///   result: '',
///   errorMessage: 'Cannot divide by zero',
/// )
/// ```
class CalculatorDisplay extends StatelessWidget {
  /// Creates a calculator display widget.
  ///
  /// Both [expression] and [result] are required.
  /// [errorMessage] is optional and when provided, replaces the
  /// result display.
  /// [dimensions] is optional for responsive scaling.
  const CalculatorDisplay({
    required this.expression,
    required this.result,
    super.key,
    this.errorMessage,
    this.dimensions,
    this.onExpressionLongPress,
    this.onResultLongPress,
  });

  /// The current expression being built (shown on top line).
  final String expression;

  /// The result or live preview (shown on bottom line).
  /// Ignored when [errorMessage] is provided.
  final String result;

  /// Optional error message to display instead of result.
  /// When provided, shown in red on the bottom line.
  final String? errorMessage;

  /// Optional responsive dimensions for scaling font sizes and
  /// padding. When null, falls back to [AppDimensions] defaults.
  final ResponsiveDimensions? dimensions;

  /// Called when the user long-presses the expression line.
  /// Used by the parent to copy expression text to clipboard.
  final VoidCallback? onExpressionLongPress;

  /// Called when the user long-presses the result line.
  /// Used by the parent to copy result text to clipboard.
  final VoidCallback? onResultLongPress;

  @override
  Widget build(BuildContext context) {
    // Get calculator colors from theme extension
    final colors =
        Theme.of(context).extension<CalculatorColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.displayBackground,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          dimensions?.displayPadding ??
              AppDimensions.displayPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expression line (top) - smaller, secondary color
            _buildExpressionLine(colors),

            const SizedBox(height: AppDimensions.spacingSm),

            // Result line (bottom) - larger, primary color
            // Shows error message when errorMessage is provided
            _buildResultLine(colors),
          ],
        ),
      ),
    );
  }

  /// Builds the expression line (top section).
  Widget _buildExpressionLine(CalculatorColors colors) {
    final child = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Text(
        expression,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: AppFonts.calculatorDisplay,
          fontSize: dimensions?.fontSizeExpression ??
              AppDimensions.fontSizeExpression,
          fontWeight: FontWeight.w300,
          color: colors.expressionText,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (onExpressionLongPress == null) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onExpressionLongPress,
      child: child,
    );
  }

  /// Builds the result line (bottom section).
  ///
  /// Shows error message in red when [errorMessage] is provided,
  /// otherwise shows the result in primary color.
  Widget _buildResultLine(CalculatorColors colors) {
    final hasError =
        errorMessage != null && errorMessage!.isNotEmpty;

    if (hasError) {
      return Text(
        errorMessage!,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: dimensions?.fontSizeError ??
              AppDimensions.fontSizeError,
          fontWeight: FontWeight.w400,
          color: colors.errorText,
        ),
      );
    }

    final child = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerRight,
      child: Text(
        result,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: AppFonts.calculatorDisplay,
          fontSize: dimensions?.fontSizeResult ??
              AppDimensions.fontSizeResult,
          fontWeight: FontWeight.w400,
          color: colors.resultText,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (onResultLongPress == null) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: onResultLongPress,
      child: child,
    );
  }
}
