import 'package:equatable/equatable.dart';

/// Base class for all calculator events.
///
/// Events represent user actions that trigger state changes in the calculator.
/// Using sealed classes enables exhaustive pattern matching in the BLoC.
sealed class CalculatorEvent extends Equatable {
  const CalculatorEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed a digit button (0-9).
///
/// Example: DigitPressed('5') appends "5" to the current expression.
final class DigitPressed extends CalculatorEvent {
  const DigitPressed(this.digit);

  /// The digit that was pressed ('0' through '9').
  final String digit;

  @override
  List<Object?> get props => [digit];
}

/// User pressed an operator button (+, −, ×, ÷).
///
/// Example: OperatorPressed('+') appends "+" to the expression.
final class OperatorPressed extends CalculatorEvent {
  const OperatorPressed(this.operator);

  /// The operator symbol (use display symbols: +, −, ×, ÷).
  final String operator;

  @override
  List<Object?> get props => [operator];
}

/// User pressed the decimal point button.
///
/// Adds a decimal point to the current number if one doesn't exist.
final class DecimalPressed extends CalculatorEvent {
  const DecimalPressed();
}

/// User pressed the equals button.
///
/// Triggers evaluation of the current expression.
final class EqualsPressed extends CalculatorEvent {
  const EqualsPressed();
}

/// User pressed the clear button (C).
///
/// Clears the last entry or character from the expression.
final class ClearPressed extends CalculatorEvent {
  const ClearPressed();
}

/// User pressed the all clear button (AC).
///
/// Resets the calculator to its initial state.
final class AllClearPressed extends CalculatorEvent {
  const AllClearPressed();
}

/// User pressed the backspace button (⌫).
///
/// Deletes the last character or operator from the expression.
final class BackspacePressed extends CalculatorEvent {
  const BackspacePressed();
}

/// User pressed a parenthesis button.
///
/// Adds an opening or closing parenthesis to the expression.
final class ParenthesisPressed extends CalculatorEvent {
  const ParenthesisPressed({required this.isOpen});

  /// True for opening parenthesis '(', false for closing ')'.
  final bool isOpen;

  @override
  List<Object?> get props => [isOpen];
}

/// User pressed the plus/minus toggle button (±).
///
/// Toggles the sign of the current number.
final class PlusMinusPressed extends CalculatorEvent {
  const PlusMinusPressed();
}

/// User pressed the percent button (%).
///
/// Converts the current number to a percentage (divides by 100).
final class PercentPressed extends CalculatorEvent {
  const PercentPressed();
}

/// Calculator initialization event.
///
/// Dispatched when the calculator starts to restore any saved state.
final class CalculatorStarted extends CalculatorEvent {
  const CalculatorStarted();
}
