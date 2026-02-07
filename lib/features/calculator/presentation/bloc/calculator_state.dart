import 'package:equatable/equatable.dart';
import 'package:math_mate/core/utils/calculator_engine.dart';

/// Base class for all calculator states.
///
/// States represent the current condition of the calculator UI.
/// Using sealed classes enables exhaustive pattern matching in widgets.
sealed class CalculatorState extends Equatable {
  const CalculatorState({
    required this.expression,
    required this.display,
  });

  /// The current expression being built (e.g., "2 + 3 × 4").
  final String expression;

  /// The value shown in the main display area.
  final String display;

  @override
  List<Object?> get props => [expression, display];
}

/// Initial state when the calculator first loads.
///
/// Shows "0" in the display with an empty expression.
final class CalculatorInitial extends CalculatorState {
  const CalculatorInitial()
      : super(
          expression: '',
          display: '0',
        );
}

/// State while user is actively inputting an expression.
///
/// Shows the expression being built and a live result preview.
final class CalculatorInput extends CalculatorState {
  const CalculatorInput({
    required super.expression,
    required super.display,
    required this.liveResult,
  });

  /// Live preview of the result (updates as user types).
  /// Shows the evaluated result or empty string if expression is incomplete.
  final String liveResult;

  @override
  List<Object?> get props => [expression, display, liveResult];
}

/// State after pressing equals with a successful calculation.
///
/// Shows the completed expression and the final result.
final class CalculatorResult extends CalculatorState {
  const CalculatorResult({
    required super.expression,
    required super.display,
    required this.result,
  });

  /// The final calculated result value.
  final String result;

  @override
  List<Object?> get props => [expression, display, result];
}

/// State when an error occurs during calculation.
///
/// Stores the error type so the UI layer can resolve it to a localized string.
final class CalculatorError extends CalculatorState {
  const CalculatorError({
    required super.expression,
    required this.errorType,
  }) : super(display: '');

  /// The type of error that occurred.
  /// Resolved to a localized string in the UI layer via BuildContext.
  final CalculationErrorType errorType;

  @override
  List<Object?> get props => [expression, errorType];
}
