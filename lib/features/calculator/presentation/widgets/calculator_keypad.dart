import 'package:flutter/material.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:math_mate/l10n/app_localizations.dart';

/// Calculator keypad with orientation-aware grid layout.
///
/// Portrait: 6×4 grid (6 rows, 4 columns):
/// ```
/// ┌─────┬─────┬─────┬─────┐
/// │ AC  │  ⌫  │  🕐 │  ⚙  │
/// │  (  │  )  │  %  │  ÷  │
/// │  7  │  8  │  9  │  ×  │
/// │  4  │  5  │  6  │  −  │
/// │  1  │  2  │  3  │  +  │
/// │  ±  │  0  │  .  │  =  │
/// └─────┴─────┴─────┴─────┘
/// ```
///
/// Landscape: 4×6 grid (4 rows, 6 columns):
/// ```
/// ┌─────┬─────┬─────┬─────┬─────┬─────┐
/// │ AC  │  ⌫  │  7  │  8  │  9  │  ÷  │
/// │  (  │  )  │  4  │  5  │  6  │  ×  │
/// │  %  │  ±  │  1  │  2  │  3  │  −  │
/// │  🕐 │  ⚙  │  0  │  .  │  =  │  +  │
/// └─────┴─────┴─────┴─────┴─────┴─────┘
/// ```
///
/// Each button press triggers the appropriate callback.
class CalculatorKeypad extends StatelessWidget {
  /// Creates a calculator keypad.
  ///
  /// All callbacks are required to handle button presses.
  /// [onHistoryPressed] and [onSettingsPressed] are optional.
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
    this.onHistoryPressed,
    this.onSettingsPressed,
    this.dimensions,
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
  /// `isOpen` is true for '(' and false for ')'.
  final void Function({required bool isOpen}) onParenthesisPressed;

  /// Called when history (🕐) is pressed. Optional.
  final VoidCallback? onHistoryPressed;

  /// Called when settings (⚙) is pressed. Optional.
  final VoidCallback? onSettingsPressed;

  /// Optional responsive dimensions for scaling button sizes
  /// and spacing. When null, falls back to [AppDimensions] defaults.
  final ResponsiveDimensions? dimensions;

  @override
  Widget build(BuildContext context) {
    final spacing = dimensions?.buttonSpacing ??
        AppDimensions.buttonSpacing;
    final padding = dimensions?.keypadPadding ??
        AppDimensions.spacingMd;
    final isLandscape = dimensions?.isLandscape ?? false;
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: isLandscape
          ? _buildLandscapeGrid(spacing, l10n)
          : _buildPortraitGrid(spacing, l10n),
    );
  }

  /// Portrait 6×4 grid layout.
  Widget _buildPortraitGrid(double spacing, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: AC, ⌫, 🕐, ⚙
        _buildRow([
          _buildFunctionButton(
            AppStrings.allClear,
            onAllClearPressed,
            l10n,
          ),
          _buildFunctionButton(
            AppStrings.backspace,
            onBackspacePressed,
            l10n,
          ),
          _buildHistoryButton(l10n),
          _buildSettingsButton(l10n),
        ]),
        SizedBox(height: spacing),
        // Row 2: (, ), %, ÷
        _buildRow([
          _buildParenthesisButton(
            AppStrings.openParen,
            isOpen: true,
            l10n: l10n,
          ),
          _buildParenthesisButton(
            AppStrings.closeParen,
            isOpen: false,
            l10n: l10n,
          ),
          _buildFunctionButton(
            AppStrings.percent,
            onPercentPressed,
            l10n,
          ),
          _buildOperatorButton(AppStrings.divide, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 3: 7, 8, 9, ×
        _buildRow([
          _buildDigitButton('7', l10n),
          _buildDigitButton('8', l10n),
          _buildDigitButton('9', l10n),
          _buildOperatorButton(AppStrings.multiply, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 4: 4, 5, 6, −
        _buildRow([
          _buildDigitButton('4', l10n),
          _buildDigitButton('5', l10n),
          _buildDigitButton('6', l10n),
          _buildOperatorButton(AppStrings.minus, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 5: 1, 2, 3, +
        _buildRow([
          _buildDigitButton('1', l10n),
          _buildDigitButton('2', l10n),
          _buildDigitButton('3', l10n),
          _buildOperatorButton(AppStrings.plus, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 6: ±, 0, ., =
        _buildRow([
          _buildFunctionButton(
            AppStrings.plusMinus,
            onPlusMinusPressed,
            l10n,
          ),
          _buildDigitButton('0', l10n),
          _buildDecimalButton(l10n),
          _buildEqualsButton(l10n),
        ]),
      ],
    );
  }

  /// Landscape 4×6 grid layout.
  ///
  /// ```
  /// ┌─────┬─────┬─────┬─────┬─────┬─────┐
  /// │ AC  │  ⌫  │  7  │  8  │  9  │  ÷  │
  /// ├─────┼─────┼─────┼─────┼─────┼─────┤
  /// │  (  │  )  │  4  │  5  │  6  │  ×  │
  /// ├─────┼─────┼─────┼─────┼─────┼─────┤
  /// │  %  │  ±  │  1  │  2  │  3  │  −  │
  /// ├─────┼─────┼─────┼─────┼─────┼─────┤
  /// │  🕐 │  ⚙  │  0  │  .  │  =  │  +  │
  /// └─────┴─────┴─────┴─────┴─────┴─────┘
  /// ```
  Widget _buildLandscapeGrid(double spacing, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: AC, ⌫, 7, 8, 9, ÷
        _buildRow([
          _buildFunctionButton(
            AppStrings.allClear,
            onAllClearPressed,
            l10n,
          ),
          _buildFunctionButton(
            AppStrings.backspace,
            onBackspacePressed,
            l10n,
          ),
          _buildDigitButton('7', l10n),
          _buildDigitButton('8', l10n),
          _buildDigitButton('9', l10n),
          _buildOperatorButton(AppStrings.divide, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 2: (, ), 4, 5, 6, ×
        _buildRow([
          _buildParenthesisButton(
            AppStrings.openParen,
            isOpen: true,
            l10n: l10n,
          ),
          _buildParenthesisButton(
            AppStrings.closeParen,
            isOpen: false,
            l10n: l10n,
          ),
          _buildDigitButton('4', l10n),
          _buildDigitButton('5', l10n),
          _buildDigitButton('6', l10n),
          _buildOperatorButton(AppStrings.multiply, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 3: %, ±, 1, 2, 3, −
        _buildRow([
          _buildFunctionButton(
            AppStrings.percent,
            onPercentPressed,
            l10n,
          ),
          _buildFunctionButton(
            AppStrings.plusMinus,
            onPlusMinusPressed,
            l10n,
          ),
          _buildDigitButton('1', l10n),
          _buildDigitButton('2', l10n),
          _buildDigitButton('3', l10n),
          _buildOperatorButton(AppStrings.minus, l10n),
        ]),
        SizedBox(height: spacing),
        // Row 4: 🕐, ⚙, 0, ., =, +
        _buildRow([
          _buildHistoryButton(l10n),
          _buildSettingsButton(l10n),
          _buildDigitButton('0', l10n),
          _buildDecimalButton(l10n),
          _buildEqualsButton(l10n),
          _buildOperatorButton(AppStrings.plus, l10n),
        ]),
      ],
    );
  }

  /// Builds a row of buttons with equal spacing.
  Widget _buildRow(List<Widget> children) {
    final hSpacing = (dimensions?.buttonSpacing ??
            AppDimensions.buttonSpacing) /
        2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children
          .map(
            (child) => Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: hSpacing,
                ),
                child: child,
              ),
            ),
          )
          .toList(),
    );
  }

  /// Builds a digit button (0-9).
  Widget _buildDigitButton(String digit, AppLocalizations l10n) {
    return CalculatorButton(
      label: digit,
      onPressed: () => onDigitPressed(digit),
      type: CalculatorButtonType.number,
      semanticLabel: _digitSemanticLabel(digit, l10n),
      dimensions: dimensions,
    );
  }

  /// Builds an operator button (+, −, ×, ÷).
  Widget _buildOperatorButton(String operator, AppLocalizations l10n) {
    return CalculatorButton(
      label: operator,
      onPressed: () => onOperatorPressed(operator),
      type: CalculatorButtonType.operator,
      semanticLabel: _operatorSemanticLabel(operator, l10n),
      dimensions: dimensions,
    );
  }

  /// Builds a function button (AC, ⌫, ±, %).
  Widget _buildFunctionButton(
    String label,
    VoidCallback onPressed,
    AppLocalizations l10n,
  ) {
    return CalculatorButton(
      label: label,
      onPressed: onPressed,
      type: CalculatorButtonType.function,
      semanticLabel: _functionSemanticLabel(label, l10n),
      dimensions: dimensions,
    );
  }

  /// Builds a parenthesis button.
  Widget _buildParenthesisButton(
    String label, {
    required bool isOpen,
    required AppLocalizations l10n,
  }) {
    return CalculatorButton(
      label: label,
      onPressed: () => onParenthesisPressed(isOpen: isOpen),
      type: CalculatorButtonType.function,
      semanticLabel: isOpen
          ? l10n.a11yOpenParen
          : l10n.a11yCloseParen,
      dimensions: dimensions,
    );
  }

  /// Builds the decimal button.
  Widget _buildDecimalButton(AppLocalizations l10n) {
    return CalculatorButton(
      label: AppStrings.decimal,
      onPressed: onDecimalPressed,
      type: CalculatorButtonType.number,
      semanticLabel: l10n.a11yDecimal,
      dimensions: dimensions,
    );
  }

  /// Builds the equals button.
  Widget _buildEqualsButton(AppLocalizations l10n) {
    return CalculatorButton(
      label: AppStrings.equals,
      onPressed: onEqualsPressed,
      type: CalculatorButtonType.equals,
      semanticLabel: l10n.a11yEquals,
      dimensions: dimensions,
    );
  }

  /// Builds a placeholder button for future features.
  Widget _buildPlaceholderButton() {
    return CalculatorButton(
      label: '',
      onPressed: () {},
      type: CalculatorButtonType.function,
      semanticLabel: '',
      dimensions: dimensions,
    );
  }

  /// Builds the history button.
  ///
  /// Shows a placeholder if [onHistoryPressed] is not provided.
  Widget _buildHistoryButton(AppLocalizations l10n) {
    if (onHistoryPressed == null) {
      return _buildPlaceholderButton();
    }
    return CalculatorButton(
      label: AppStrings.history,
      onPressed: onHistoryPressed!,
      type: CalculatorButtonType.function,
      semanticLabel: l10n.a11yHistory,
      dimensions: dimensions,
    );
  }

  /// Builds the settings button.
  ///
  /// Shows a placeholder if [onSettingsPressed] is not provided.
  Widget _buildSettingsButton(AppLocalizations l10n) {
    if (onSettingsPressed == null) {
      return _buildPlaceholderButton();
    }
    return CalculatorButton(
      label: AppStrings.settings,
      onPressed: onSettingsPressed!,
      type: CalculatorButtonType.function,
      semanticLabel: l10n.a11ySettings,
      dimensions: dimensions,
    );
  }

  /// Returns semantic label for a digit.
  String _digitSemanticLabel(String digit, AppLocalizations l10n) {
    final labels = {
      '0': l10n.a11yZero,
      '1': l10n.a11yOne,
      '2': l10n.a11yTwo,
      '3': l10n.a11yThree,
      '4': l10n.a11yFour,
      '5': l10n.a11yFive,
      '6': l10n.a11ySix,
      '7': l10n.a11ySeven,
      '8': l10n.a11yEight,
      '9': l10n.a11yNine,
    };
    return labels[digit] ?? digit;
  }

  /// Returns semantic label for an operator.
  String _operatorSemanticLabel(String operator, AppLocalizations l10n) {
    if (operator == AppStrings.plus) return l10n.a11yPlus;
    if (operator == AppStrings.minus) return l10n.a11yMinus;
    if (operator == AppStrings.multiply) return l10n.a11yMultiply;
    if (operator == AppStrings.divide) return l10n.a11yDivide;
    return operator;
  }

  /// Returns semantic label for a function button.
  String _functionSemanticLabel(String label, AppLocalizations l10n) {
    if (label == AppStrings.allClear) return l10n.a11yAllClear;
    if (label == AppStrings.backspace) return l10n.a11yBackspace;
    if (label == AppStrings.plusMinus) return l10n.a11yPlusMinus;
    if (label == AppStrings.percent) return l10n.a11yPercent;
    return label;
  }
}
