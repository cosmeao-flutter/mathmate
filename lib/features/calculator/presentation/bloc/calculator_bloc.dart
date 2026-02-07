import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/utils/calculator_engine.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:math_mate/features/history/data/history_repository.dart';

/// BLoC for managing calculator state and handling user input.
///
/// This BLoC processes calculator events (button presses) and emits
/// corresponding states to update the UI. It uses [CalculatorEngine]
/// for expression evaluation.
///
/// Optionally accepts a [CalculatorRepository] for state persistence.
/// When provided, the calculator state will be saved and restored
/// across app restarts.
///
/// Optionally accepts a [HistoryRepository] to save successful calculations
/// to the history.
///
/// Example:
/// ```dart
/// final repository = await CalculatorRepository.create();
/// final bloc = CalculatorBloc(repository: repository);
/// bloc.add(const CalculatorStarted()); // Loads saved state
/// bloc.add(const DigitPressed('5'));
/// // State will be auto-saved on changes
/// ```
class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc({this.repository, this.historyRepository})
      : super(const CalculatorInitial()) {
    on<DigitPressed>(_onDigitPressed);
    on<OperatorPressed>(_onOperatorPressed);
    on<DecimalPressed>(_onDecimalPressed);
    on<EqualsPressed>(_onEqualsPressed);
    on<ClearPressed>(_onClearPressed);
    on<AllClearPressed>(_onAllClearPressed);
    on<BackspacePressed>(_onBackspacePressed);
    on<ParenthesisPressed>(_onParenthesisPressed);
    on<PlusMinusPressed>(_onPlusMinusPressed);
    on<PercentPressed>(_onPercentPressed);
    on<CalculatorStarted>(_onCalculatorStarted);
    on<HistoryEntryLoaded>(_onHistoryEntryLoaded);
  }

  /// Optional repository for persisting calculator state.
  final CalculatorRepository? repository;

  /// Optional repository for saving calculation history.
  final HistoryRepository? historyRepository;

  final CalculatorEngine _engine = CalculatorEngine();

  /// Handles digit button presses (0-9).
  void _onDigitPressed(DigitPressed event, Emitter<CalculatorState> emit) {
    final currentState = state;

    // After result or error, start fresh with new digit
    if (currentState is CalculatorResult || currentState is CalculatorError) {
      final newExpression = event.digit;
      emit(_createInputState(newExpression));
      return;
    }

    // From initial state, replace 0 with digit (unless it's 0)
    if (currentState is CalculatorInitial) {
      final newExpression = event.digit;
      emit(_createInputState(newExpression));
      return;
    }

    // Append digit to expression
    final newExpression = currentState.expression + event.digit;
    emit(_createInputState(newExpression));
  }

  /// Handles operator button presses (+, −, ×, ÷).
  void _onOperatorPressed(
    OperatorPressed event,
    Emitter<CalculatorState> emit,
  ) {
    final currentState = state;

    // Ignore operator after error
    if (currentState is CalculatorError) {
      return;
    }

    // After result, continue calculation with result
    if (currentState is CalculatorResult) {
      final newExpression = '${currentState.result} ${event.operator} ';
      emit(_createInputState(newExpression));
      return;
    }

    // From initial state, use 0 as starting point
    if (currentState is CalculatorInitial) {
      final newExpression = '0 ${event.operator} ';
      emit(_createInputState(newExpression));
      return;
    }

    // Replace existing operator if expression ends with one
    if (_endsWithOperator(currentState.expression)) {
      final newExpression =
          _replaceLastOperator(currentState.expression, event.operator);
      emit(_createInputState(newExpression));
      return;
    }

    // Append operator with spaces
    final newExpression = '${currentState.expression} ${event.operator} ';
    emit(_createInputState(newExpression));
  }

  /// Handles decimal point button press.
  void _onDecimalPressed(DecimalPressed event, Emitter<CalculatorState> emit) {
    final currentState = state;

    // After result or error, start fresh with 0.
    if (currentState is CalculatorResult || currentState is CalculatorError) {
      emit(_createInputState('0.'));
      return;
    }

    // From initial state, start with 0.
    if (currentState is CalculatorInitial) {
      emit(_createInputState('0.'));
      return;
    }

    // Don't add decimal if current number already has one
    if (_currentNumberHasDecimal(currentState.expression)) {
      return;
    }

    // If expression ends with operator, add 0.
    if (_endsWithOperator(currentState.expression)) {
      final newExpression = '${currentState.expression}0.';
      emit(_createInputState(newExpression));
      return;
    }

    // Append decimal
    final newExpression = '${currentState.expression}.';
    emit(_createInputState(newExpression));
  }

  /// Handles equals button press - evaluates the expression.
  Future<void> _onEqualsPressed(
    EqualsPressed event,
    Emitter<CalculatorState> emit,
  ) async {
    final currentState = state;

    // Nothing to evaluate from initial state
    if (currentState is CalculatorInitial) {
      return;
    }

    // Re-pressing equals after result does nothing
    if (currentState is CalculatorResult) {
      return;
    }

    // Can't evaluate error state
    if (currentState is CalculatorError) {
      return;
    }

    final expression = currentState.expression;
    if (expression.isEmpty) {
      return;
    }

    // Evaluate the expression
    final result = _engine.evaluate(expression);

    if (result.isError) {
      emit(CalculatorError(
        expression: expression,
        errorType: result.errorType ?? CalculationErrorType.generic,
      ));
    } else {
      // Save to history on successful calculation
      await historyRepository?.addEntry(
        expression: expression,
        result: result.displayValue,
      );

      emit(CalculatorResult(
        expression: expression,
        display: result.displayValue,
        result: result.displayValue,
      ));
    }
  }

  /// Handles clear button press - deletes last character or resets.
  void _onClearPressed(ClearPressed event, Emitter<CalculatorState> emit) {
    _deleteLastCharacter(emit);
  }

  /// Deletes the last character or operator from the expression.
  ///
  /// Shared logic used by both [ClearPressed] and [BackspacePressed] events.
  void _deleteLastCharacter(Emitter<CalculatorState> emit) {
    final currentState = state;

    // From result or error, go to initial
    if (currentState is CalculatorResult || currentState is CalculatorError) {
      emit(const CalculatorInitial());
      return;
    }

    // From initial, nothing to clear
    if (currentState is CalculatorInitial) {
      return;
    }

    var expression = currentState.expression;

    // If ends with operator and spaces, remove all of " X "
    if (_endsWithOperator(expression)) {
      expression = expression.trimRight();
      // Remove operator
      expression = expression.substring(0, expression.length - 1);
      // Remove leading space
      expression = expression.trimRight();
    } else {
      // Remove last character
      expression = expression.substring(0, expression.length - 1);
    }

    // If expression is now empty, go to initial
    if (expression.isEmpty) {
      emit(const CalculatorInitial());
      return;
    }

    emit(_createInputState(expression));
  }

  /// Handles all clear button press - resets to initial state.
  void _onAllClearPressed(
    AllClearPressed event,
    Emitter<CalculatorState> emit,
  ) {
    emit(const CalculatorInitial());
  }

  /// Handles backspace button press - deletes last character.
  ///
  /// Uses the same logic as [_onClearPressed].
  void _onBackspacePressed(
    BackspacePressed event,
    Emitter<CalculatorState> emit,
  ) {
    _deleteLastCharacter(emit);
  }

  /// Handles parenthesis button press.
  void _onParenthesisPressed(
    ParenthesisPressed event,
    Emitter<CalculatorState> emit,
  ) {
    final currentState = state;
    final paren = event.isOpen ? '(' : ')';

    // After result or error, start fresh
    if (currentState is CalculatorResult || currentState is CalculatorError) {
      emit(_createInputState(paren));
      return;
    }

    // From initial state
    if (currentState is CalculatorInitial) {
      emit(_createInputState(paren));
      return;
    }

    // Append parenthesis
    final newExpression = currentState.expression + paren;
    emit(_createInputState(newExpression));
  }

  /// Handles plus/minus toggle button press.
  void _onPlusMinusPressed(
    PlusMinusPressed event,
    Emitter<CalculatorState> emit,
  ) {
    final currentState = state;

    // From initial, nothing to negate
    if (currentState is CalculatorInitial) {
      return;
    }

    // After result, negate the result
    if (currentState is CalculatorResult) {
      final result = currentState.result;
      if (result.startsWith('-')) {
        emit(_createInputState(result.substring(1)));
      } else {
        emit(_createInputState('(-$result'));
      }
      return;
    }

    // After error, ignore
    if (currentState is CalculatorError) {
      return;
    }

    final expression = currentState.expression;

    // Check if current number is already negated
    if (_isCurrentNumberNegated(expression)) {
      // Remove the negation: find "(-" and remove it
      final newExpression = _removeNegation(expression);
      emit(_createInputState(newExpression));
    } else {
      // Add negation to current number
      final newExpression = _addNegation(expression);
      emit(_createInputState(newExpression));
    }
  }

  /// Handles percent button press.
  void _onPercentPressed(PercentPressed event, Emitter<CalculatorState> emit) {
    final currentState = state;

    // From initial, 0% = 0
    if (currentState is CalculatorInitial) {
      emit(_createInputState('0%'));
      return;
    }

    // After result, append % to result
    if (currentState is CalculatorResult) {
      emit(_createInputState('${currentState.result}%'));
      return;
    }

    // After error, ignore
    if (currentState is CalculatorError) {
      return;
    }

    // Append % to expression
    final newExpression = '${currentState.expression}%';
    emit(_createInputState(newExpression));
  }

  /// Handles calculator initialization.
  ///
  /// Loads any saved state from the repository if available.
  void _onCalculatorStarted(
    CalculatorStarted event,
    Emitter<CalculatorState> emit,
  ) {
    if (repository == null || !repository!.hasState) {
      return;
    }

    final savedState = repository!.loadState();

    // If we have a saved expression, restore it
    if (savedState.expression.isNotEmpty) {
      emit(_createInputState(savedState.expression));
    } else if (savedState.result.isNotEmpty) {
      // If we only have a result (after equals was pressed), restore as result
      emit(CalculatorResult(
        expression: '',
        display: savedState.result,
        result: savedState.result,
      ));
    }
  }

  /// Handles loading an expression from history.
  void _onHistoryEntryLoaded(
    HistoryEntryLoaded event,
    Emitter<CalculatorState> emit,
  ) {
    emit(_createInputState(event.expression));
  }

  @override
  void onChange(Change<CalculatorState> change) {
    super.onChange(change);
    _saveState(change.nextState);
  }

  /// Saves the current state to the repository.
  void _saveState(CalculatorState state) {
    if (repository == null) return;

    switch (state) {
      case CalculatorInitial():
        // Clear saved state when reset
        repository!.clearState();
      case CalculatorInput(:final expression, :final liveResult):
        // Save expression and live result
        repository!.saveState(expression: expression, result: liveResult);
      case CalculatorResult(:final expression, :final result):
        // Save expression and final result
        repository!.saveState(expression: expression, result: result);
      case CalculatorError():
        // Don't save error states
        break;
    }
  }

  /// Creates an input state with live result preview.
  CalculatorInput _createInputState(String expression) {
    final liveResult = _calculateLiveResult(expression);
    return CalculatorInput(
      expression: expression,
      display: expression,
      liveResult: liveResult,
    );
  }

  /// Calculates the live result preview for the current expression.
  String _calculateLiveResult(String expression) {
    if (expression.isEmpty) {
      return '';
    }

    final result = _engine.evaluate(expression);
    if (result.isError) {
      // For incomplete expressions, try to show partial result
      // by trimming trailing operators
      var trimmed = expression.trimRight();
      while (trimmed.isNotEmpty && _endsWithOperatorChar(trimmed)) {
        trimmed = trimmed.substring(0, trimmed.length - 1).trimRight();
      }

      if (trimmed.isNotEmpty && trimmed != expression) {
        final partialResult = _engine.evaluate(trimmed);
        if (!partialResult.isError) {
          return partialResult.displayValue;
        }
      }
      return '';
    }

    return result.displayValue;
  }

  /// Checks if expression ends with an operator (with trailing space).
  bool _endsWithOperator(String expression) {
    final trimmed = expression.trimRight();
    return _endsWithOperatorChar(trimmed);
  }

  /// Checks if expression ends with an operator character.
  bool _endsWithOperatorChar(String expression) {
    if (expression.isEmpty) return false;
    final lastChar = expression[expression.length - 1];
    return ['+', '−', '×', '÷', '-', '*', '/'].contains(lastChar);
  }

  /// Replaces the last operator in the expression.
  String _replaceLastOperator(String expression, String newOperator) {
    var trimmed = expression.trimRight();
    // Remove last operator
    trimmed = trimmed.substring(0, trimmed.length - 1).trimRight();
    return '$trimmed $newOperator ';
  }

  /// Checks if the current number in the expression has a decimal.
  bool _currentNumberHasDecimal(String expression) {
    // Find the last number in the expression
    final parts = expression.split(RegExp(r'[\+\−\×\÷\s]+'));
    final lastPart = parts.isNotEmpty ? parts.last : '';
    return lastPart.contains('.');
  }

  /// Checks if the current number is negated.
  bool _isCurrentNumberNegated(String expression) {
    // Look for pattern "(-" followed by digits
    return expression.contains('(-');
  }

  /// Removes negation from the current number.
  String _removeNegation(String expression) {
    // Find the last "(-" and remove it along with the matching logic
    final lastNegStart = expression.lastIndexOf('(-');
    if (lastNegStart == -1) return expression;

    // Remove "(-" prefix
    final before = expression.substring(0, lastNegStart);
    final after = expression.substring(lastNegStart + 2);
    return before + after;
  }

  /// Adds negation to the current number.
  String _addNegation(String expression) {
    // Find the start of the current number
    final lastOpIndex = _findLastOperatorIndex(expression);

    if (lastOpIndex == -1) {
      // No operator, negate the whole expression
      return '(-$expression';
    }

    // Insert "(-" before the current number
    final before = expression.substring(0, lastOpIndex + 1);
    final number = expression.substring(lastOpIndex + 1).trimLeft();
    return '$before(-$number';
  }

  /// Finds the index of the last operator in the expression.
  int _findLastOperatorIndex(String expression) {
    var lastIndex = -1;
    for (var i = expression.length - 1; i >= 0; i--) {
      final char = expression[i];
      if (['+', '−', '×', '÷', '-', '*', '/'].contains(char)) {
        // Make sure it's not a negative sign at the start of a number
        if (i > 0 && expression[i - 1] == '(') {
          continue; // This is a negation sign, not an operator
        }
        lastIndex = i;
        break;
      }
    }
    return lastIndex;
  }
}
