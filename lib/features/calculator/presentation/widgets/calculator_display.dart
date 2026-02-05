import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/app_colors.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';

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
  /// [errorMessage] is optional and when provided, replaces the result display.
  const CalculatorDisplay({
    required this.expression,
    required this.result,
    super.key,
    this.errorMessage,
  });

  /// The current expression being built (shown on top line).
  final String expression;

  /// The result or live preview (shown on bottom line).
  /// Ignored when [errorMessage] is provided.
  final String result;

  /// Optional error message to display instead of result.
  /// When provided, shown in red on the bottom line.
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.displayBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.displayPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Expression line (top) - smaller, secondary color
            _buildExpressionLine(),

            const SizedBox(height: AppDimensions.spacingSm),

            // Result line (bottom) - larger, primary color
            // Shows error message when errorMessage is provided
            _buildResultLine(),
          ],
        ),
      ),
    );
  }

  /// Builds the expression line (top section).
  Widget _buildExpressionLine() {
    return Text(
      expression,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeExpression,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the result line (bottom section).
  ///
  /// Shows error message in red when [errorMessage] is provided,
  /// otherwise shows the result in primary color.
  Widget _buildResultLine() {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    if (hasError) {
      return Text(
        errorMessage!,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: AppDimensions.fontSizeError,
          fontWeight: FontWeight.w400,
          color: AppColors.error,
        ),
      );
    }

    return Text(
      result,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: AppDimensions.fontSizeResult,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
