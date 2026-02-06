import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_button.dart';

/// A 6×4 grid of calculator buttons.
///
/// The keypad layout follows Google Calculator design:
/// ```
/// ┌─────┬─────┬─────┬─────┐
/// │ AC  │  ⌫  │     │     │  ← Control row (2 slots for future)
/// ├─────┼─────┼─────┼─────┤
/// │  (  │  )  │  %  │  ÷  │  ← Functions & division
/// ├─────┼─────┼─────┼─────┤
/// │  7  │  8  │  9  │  ×  │
/// ├─────┼─────┼─────┼─────┤
/// │  4  │  5  │  6  │  −  │
/// ├─────┼─────┼─────┼─────┤
/// │  1  │  2  │  3  │  +  │
/// ├─────┼─────┼─────┼─────┤
/// │  ±  │  0  │  .  │  =  │  ← Plus/minus, zero, decimal, equals
/// └─────┴─────┴─────┴─────┘
/// ```
///
/// Each button press triggers the appropriate callback.
class CalculatorKeypad extends StatelessWidget {
  /// Creates a calculator keypad.
  ///
  /// All callbacks are required to handle button presses.
  /// [onSettingsPressed] is optional and shows a settings button when provided.
  const CalculatorKeypad({
    required this.onDigitPressed,
    required this.onOperatorPressed,
    required this.onEqualsPressed,
    required this.onBackspacePressed,
    required this.onAllClearPressed,
    required this.onDecimalPressed,
    required this.onPercentPressed,
    required this.onPlusMinusPressed,
    required this.onParenthesisPressed,
    this.onSettingsPressed,
    super.key,
  });

  /// Called when a digit (0-9) is pressed.
  final void Function(String digit) onDigitPressed;

  /// Called when an operator (+, −, ×, ÷) is pressed.
  final void Function(String operator) onOperatorPressed;

  /// Called when equals (=) is pressed.
  final VoidCallback onEqualsPressed;

  /// Called when backspace (⌫) is pressed - removes last character.
  final VoidCallback onBackspacePressed;

  /// Called when all clear (AC) is pressed - resets calculator.
  final VoidCallback onAllClearPressed;

  /// Called when decimal (.) is pressed.
  final VoidCallback onDecimalPressed;

  /// Called when percent (%) is pressed.
  final VoidCallback onPercentPressed;

  /// Called when plus/minus (±) is pressed.
  final VoidCallback onPlusMinusPressed;

  /// Called when a parenthesis is pressed.
  /// [isOpen] is true for '(' and false for ')'.
  final void Function({required bool isOpen}) onParenthesisPressed;

  /// Called when settings (⚙) is pressed. Optional.
  final VoidCallback? onSettingsPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: AC, ⌫, [empty], ⚙
          _buildRow([
            _buildFunctionButton(AppStrings.allClear, onAllClearPressed),
            _buildFunctionButton(AppStrings.backspace, onBackspacePressed),
            _buildPlaceholderButton(),
            _buildSettingsButton(),
          ]),

          const SizedBox(height: AppDimensions.buttonSpacing),

          // Row 2: (, ), %, ÷
          _buildRow([
            _buildParenthesisButton(AppStrings.openParen, isOpen: true),
            _buildParenthesisButton(AppStrings.closeParen, isOpen: false),
            _buildFunctionButton(AppStrings.percent, onPercentPressed),
            _buildOperatorButton(AppStrings.divide),
          ]),

          const SizedBox(height: AppDimensions.buttonSpacing),

          // Row 3: 7, 8, 9, ×
          _buildRow([
            _buildDigitButton('7'),
            _buildDigitButton('8'),
            _buildDigitButton('9'),
            _buildOperatorButton(AppStrings.multiply),
          ]),

          const SizedBox(height: AppDimensions.buttonSpacing),

          // Row 4: 4, 5, 6, −
          _buildRow([
            _buildDigitButton('4'),
            _buildDigitButton('5'),
            _buildDigitButton('6'),
            _buildOperatorButton(AppStrings.minus),
          ]),

          const SizedBox(height: AppDimensions.buttonSpacing),

          // Row 5: 1, 2, 3, +
          _buildRow([
            _buildDigitButton('1'),
            _buildDigitButton('2'),
            _buildDigitButton('3'),
            _buildOperatorButton(AppStrings.plus),
          ]),

          const SizedBox(height: AppDimensions.buttonSpacing),

          // Row 6: ±, 0, ., =
          _buildRow([
            _buildFunctionButton(AppStrings.plusMinus, onPlusMinusPressed),
            _buildDigitButton('0'),
            _buildDecimalButton(),
            _buildEqualsButton(),
          ]),
        ],
      ),
    );
  }

  /// Builds a row of buttons with equal spacing.
  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map(
            (child) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.buttonSpacing / 2,
                ),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Builds a digit button (0-9).
  Widget _buildDigitButton(String digit) {
    return CalculatorButton(
      label: digit,
      onPressed: () => onDigitPressed(digit),
      type: CalculatorButtonType.number,
      semanticLabel: _digitSemanticLabel(digit),
    );
  }

  /// Builds an operator button (+, −, ×, ÷).
  Widget _buildOperatorButton(String operator) {
    return CalculatorButton(
      label: operator,
      onPressed: () => onOperatorPressed(operator),
      type: CalculatorButtonType.operator,
      semanticLabel: _operatorSemanticLabel(operator),
    );
  }

  /// Builds a function button (AC, ⌫, ±, %).
  Widget _buildFunctionButton(String label, VoidCallback onPressed) {
    return CalculatorButton(
      label: label,
      onPressed: onPressed,
      type: CalculatorButtonType.function,
      semanticLabel: _functionSemanticLabel(label),
    );
  }

  /// Builds a parenthesis button.
  Widget _buildParenthesisButton(String label, {required bool isOpen}) {
    return CalculatorButton(
      label: label,
      onPressed: () => onParenthesisPressed(isOpen: isOpen),
      type: CalculatorButtonType.function,
      semanticLabel:
          isOpen ? AppStrings.a11yOpenParen : AppStrings.a11yCloseParen,
    );
  }

  /// Builds the decimal button.
  Widget _buildDecimalButton() {
    return CalculatorButton(
      label: AppStrings.decimal,
      onPressed: onDecimalPressed,
      type: CalculatorButtonType.number,
      semanticLabel: AppStrings.a11yDecimal,
    );
  }

  /// Builds the equals button.
  Widget _buildEqualsButton() {
    return CalculatorButton(
      label: AppStrings.equals,
      onPressed: onEqualsPressed,
      type: CalculatorButtonType.equals,
      semanticLabel: AppStrings.a11yEquals,
    );
  }

  /// Builds a placeholder button for future features.
  ///
  /// These empty slots are reserved for history and settings buttons.
  Widget _buildPlaceholderButton() {
    return CalculatorButton(
      label: '',
      onPressed: () {},
      type: CalculatorButtonType.function,
      semanticLabel: '',
    );
  }

  /// Builds the settings button.
  ///
  /// Shows a placeholder if [onSettingsPressed] is not provided.
  Widget _buildSettingsButton() {
    if (onSettingsPressed == null) {
      return _buildPlaceholderButton();
    }
    return CalculatorButton(
      label: AppStrings.settings,
      onPressed: onSettingsPressed!,
      type: CalculatorButtonType.function,
      semanticLabel: AppStrings.a11ySettings,
    );
  }

  /// Returns semantic label for a digit.
  String _digitSemanticLabel(String digit) {
    const labels = {
      '0': AppStrings.a11yZero,
      '1': AppStrings.a11yOne,
      '2': AppStrings.a11yTwo,
      '3': AppStrings.a11yThree,
      '4': AppStrings.a11yFour,
      '5': AppStrings.a11yFive,
      '6': AppStrings.a11ySix,
      '7': AppStrings.a11ySeven,
      '8': AppStrings.a11yEight,
      '9': AppStrings.a11yNine,
    };
    return labels[digit] ?? digit;
  }

  /// Returns semantic label for an operator.
  String _operatorSemanticLabel(String operator) {
    if (operator == AppStrings.plus) return AppStrings.a11yPlus;
    if (operator == AppStrings.minus) return AppStrings.a11yMinus;
    if (operator == AppStrings.multiply) return AppStrings.a11yMultiply;
    if (operator == AppStrings.divide) return AppStrings.a11yDivide;
    return operator;
  }

  /// Returns semantic label for a function button.
  String _functionSemanticLabel(String label) {
    if (label == AppStrings.allClear) return AppStrings.a11yAllClear;
    if (label == AppStrings.backspace) return AppStrings.a11yBackspace;
    if (label == AppStrings.plusMinus) return AppStrings.a11yPlusMinus;
    if (label == AppStrings.percent) return AppStrings.a11yPercent;
    return label;
  }
}
