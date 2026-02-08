import 'package:flutter/foundation.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for storing calculator state in SharedPreferences.
class _StorageKeys {
  static const String expression = 'calculator_expression';
  static const String result = 'calculator_result';
}

/// Data class representing saved calculator state.
class SavedCalculatorState {
  const SavedCalculatorState({
    required this.expression,
    required this.result,
  });

  /// The saved expression (e.g., "2 + 3 × 4").
  final String expression;

  /// The saved result (e.g., "14").
  final String result;
}

/// Repository for persisting calculator state using SharedPreferences.
///
/// This repository handles saving and restoring the calculator's expression
/// and result across app restarts.
///
/// Usage:
/// ```dart
/// final repository = await CalculatorRepository.create();
///
/// // Save state
/// await repository.saveState(expression: '2 + 3', result: '5');
///
/// // Load state
/// final state = repository.loadState();
/// print(state.expression); // '2 + 3'
/// print(state.result);     // '5'
/// ```
class CalculatorRepository {
  CalculatorRepository._(this._prefs, this._logger);

  /// Creates a [CalculatorRepository] for testing with injected dependencies.
  @visibleForTesting
  CalculatorRepository.forTesting(this._prefs, {AppLogger? logger})
      : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a new [CalculatorRepository] instance.
  ///
  /// This is an async factory because SharedPreferences requires initialization.
  static Future<CalculatorRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return CalculatorRepository._(prefs, logger ?? AppLogger());
  }

  /// Saves the calculator state to persistent storage.
  ///
  /// [expression] is the current expression being displayed.
  /// [result] is the calculated result or live preview.
  Future<void> saveState({
    required String expression,
    required String result,
  }) async {
    try {
      await _prefs.setString(_StorageKeys.expression, expression);
      await _prefs.setString(_StorageKeys.result, result);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to save calculator state', e, stackTrace);
    }
  }

  /// Loads the saved calculator state from persistent storage.
  ///
  /// Returns a [SavedCalculatorState] with empty strings if nothing is saved.
  SavedCalculatorState loadState() {
    final expression = _prefs.getString(_StorageKeys.expression) ?? '';
    final result = _prefs.getString(_StorageKeys.result) ?? '';

    return SavedCalculatorState(
      expression: expression,
      result: result,
    );
  }

  /// Clears all saved calculator state.
  Future<void> clearState() async {
    try {
      await _prefs.remove(_StorageKeys.expression);
      await _prefs.remove(_StorageKeys.result);
    } on Exception catch (e, stackTrace) {
      _logger.error('Failed to clear calculator state', e, stackTrace);
    }
  }

  /// Returns true if there is any saved state.
  bool get hasState {
    return _prefs.containsKey(_StorageKeys.expression) ||
        _prefs.containsKey(_StorageKeys.result);
  }
}
