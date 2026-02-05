import 'package:math_expressions/math_expressions.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/app_strings.dart';

/// Result of a calculator evaluation.
///
/// This class encapsulates both successful results and errors,
/// providing a clean way to handle calculation outcomes.
///
/// Example usage:
/// ```dart
/// final result = engine.evaluate('2 + 3');
/// if (result.isError) {
///   print('Error: ${result.errorMessage}');
/// } else {
///   print('Result: ${result.displayValue}');
/// }
/// ```
class CalculationResult {
  /// Creates a successful result with a numeric value.
  CalculationResult.success(this.value)
      : isError = false,
        errorMessage = null;

  /// Creates an error result with an error message.
  CalculationResult.error(this.errorMessage)
      : isError = true,
        value = double.nan;

  /// The numeric result of the calculation.
  /// Will be NaN if [isError] is true.
  final double value;

  /// Whether this result represents an error.
  final bool isError;

  /// The error message if [isError] is true, null otherwise.
  final String? errorMessage;

  /// Returns the result formatted for display.
  ///
  /// - Integers are displayed without decimal points (e.g., "5" not "5.0")
  /// - Large/small numbers use scientific notation
  /// - Respects maximum display digits
  String get displayValue {
    if (isError) {
      return AppStrings.error;
    }

    // Check for special values
    if (value.isNaN || value.isInfinite) {
      return AppStrings.error;
    }

    // Check if the number is an integer (no fractional part)
    if (value == value.truncateToDouble()) {
      final intValue = value.toInt();
      final intString = intValue.toString();

      // Use scientific notation for very large integers
      if (intString.length > AppDimensions.maxDisplayDigits) {
        return _toScientificNotation(value);
      }

      return intString;
    }

    // For decimals, format appropriately
    var formatted = value.toString();

    // Check if we need scientific notation
    if (value.abs() >= 1e15 || (value.abs() < 1e-10 && value != 0)) {
      return _toScientificNotation(value);
    }

    // Limit decimal places if too long
    if (formatted.length > AppDimensions.maxDisplayDigits) {
      // Calculate how many decimal places we can show
      final intPartLength = value.truncate().toString().length;
      final availableDecimals =
          AppDimensions.maxDisplayDigits - intPartLength - 1;

      if (availableDecimals > 0) {
        formatted = value.toStringAsFixed(availableDecimals);
        // Remove trailing zeros
        formatted = _removeTrailingZeros(formatted);
      } else {
        return _toScientificNotation(value);
      }
    }

    return formatted;
  }

  /// Converts a number to scientific notation (e.g., 1.23e+10).
  String _toScientificNotation(double val) {
    return val.toStringAsExponential(2);
  }

  /// Removes trailing zeros from a decimal string.
  /// E.g., "2.500" becomes "2.5", "3.000" becomes "3"
  String _removeTrailingZeros(String str) {
    if (!str.contains('.')) return str;

    var result = str;
    while (result.endsWith('0')) {
      result = result.substring(0, result.length - 1);
    }
    if (result.endsWith('.')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }
}

/// Calculator engine for evaluating mathematical expressions.
///
/// This class handles:
/// - Parsing and evaluating expressions using PEMDAS
/// - Auto-balancing unclosed parentheses
/// - Implicit multiplication (e.g., 2(3) = 6)
/// - Converting Unicode operators to ASCII
/// - Error handling for invalid expressions
///
/// Uses the `math_expressions` package for parsing.
///
/// Example:
/// ```dart
/// final engine = CalculatorEngine();
/// final result = engine.evaluate('2 + 3 * 4');
/// print(result.displayValue); // "14"
/// ```
class CalculatorEngine {
  /// Parser for mathematical expressions.
  final GrammarParser _parser = GrammarParser();

  /// Context model for variable binding (not used in basic calculator).
  final ContextModel _contextModel = ContextModel();

  /// Evaluates a mathematical expression and returns the result.
  ///
  /// [expression] - The expression to evaluate (e.g., "2 + 3 * 4")
  ///
  /// Returns a [CalculationResult] containing either:
  /// - A successful result with the numeric value
  /// - An error result with an error message
  CalculationResult evaluate(String expression) {
    // Handle empty expression
    if (expression.trim().isEmpty) {
      return CalculationResult.error(AppStrings.errorInvalidExpression);
    }

    try {
      // Step 1: Preprocess the expression
      final processedExpression = _preprocessExpression(expression);

      // Step 2: Check for division by zero before evaluation
      if (_containsDivisionByZero(processedExpression)) {
        return CalculationResult.error(AppStrings.errorDivisionByZero);
      }

      // Step 3: Parse the expression
      final exp = _parser.parse(processedExpression);

      // Step 4: Evaluate the expression
      final result = exp.evaluate(EvaluationType.REAL, _contextModel) as double;

      // Step 5: Check for invalid results
      if (result.isNaN) {
        return CalculationResult.error(AppStrings.errorUndefined);
      }
      if (result.isInfinite) {
        return CalculationResult.error(AppStrings.errorOverflow);
      }

      return CalculationResult.success(result);
    } catch (e) {
      // Handle parsing or evaluation errors
      return CalculationResult.error(AppStrings.errorInvalidExpression);
    }
  }

  /// Preprocesses the expression before evaluation.
  ///
  /// This method:
  /// 1. Converts Unicode operators to ASCII
  /// 2. Handles implicit multiplication
  /// 3. Auto-balances unclosed parentheses
  /// 4. Converts percentages
  String _preprocessExpression(String expression) {
    var result = expression;

    // Step 1: Convert Unicode operators to ASCII equivalents
    result = _convertUnicodeOperators(result);

    // Step 2: Handle percentage (convert 50% to 0.5)
    result = _convertPercentages(result);

    // Step 3: Handle implicit multiplication
    result = _addImplicitMultiplication(result);

    // Step 4: Auto-balance parentheses
    result = _autoBalanceParentheses(result);

    return result;
  }

  /// Converts Unicode mathematical operators to ASCII.
  ///
  /// - × (U+00D7) → *
  /// - ÷ (U+00F7) → /
  /// - − (U+2212) → -
  String _convertUnicodeOperators(String expression) {
    return expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-');
  }

  /// Converts percentage notation to decimal.
  ///
  /// - 50% → (50/100) → 0.5
  /// - 100% → (100/100) → 1
  String _convertPercentages(String expression) {
    // Match a number followed by %
    final percentRegex = RegExp(r'(\d+\.?\d*)%');

    return expression.replaceAllMapped(percentRegex, (match) {
      final number = double.parse(match.group(1)!);
      final decimal = number / 100;
      return decimal.toString();
    });
  }

  /// Adds explicit multiplication operators for implicit multiplication.
  ///
  /// Examples:
  /// - "2(3)" → "2*(3)"
  /// - "(2)(3)" → "(2)*(3)"
  /// - "(2+3)4" → "(2+3)*4"
  String _addImplicitMultiplication(String expression) {
    var result = expression;

    // Pattern: number followed by opening parenthesis → number * (
    // e.g., "2(" → "2*("
    result = result.replaceAllMapped(
      RegExp(r'(\d)\('),
      (match) => '${match.group(1)}*(',
    );

    // Pattern: closing parenthesis followed by number → ) * number
    // e.g., ")2" → ")*2"
    result = result.replaceAllMapped(
      RegExp(r'\)(\d)'),
      (match) => ')*${match.group(1)}',
    );

    // Pattern: closing parenthesis followed by opening parenthesis → ) * (
    // e.g., ")(" → ")*("
    result = result.replaceAll(')(', ')*(');

    return result;
  }

  /// Auto-balances unclosed parentheses by adding closing parens at the end.
  ///
  /// Examples:
  /// - "(2 + 3" → "(2 + 3)"
  /// - "((2 + 3" → "((2 + 3))"
  String _autoBalanceParentheses(String expression) {
    var openCount = 0;
    var closeCount = 0;

    // Count parentheses
    for (final char in expression.runes) {
      if (String.fromCharCode(char) == '(') {
        openCount++;
      } else if (String.fromCharCode(char) == ')') {
        closeCount++;
      }
    }

    // If there are more opening than closing, add closing parens
    if (openCount > closeCount) {
      final missingClose = openCount - closeCount;
      return expression + ')' * missingClose;
    }

    // If there are more closing than opening, this is an error
    // (will be caught during parsing)
    return expression;
  }

  /// Checks if the expression contains division by zero.
  ///
  /// This is a simple check that looks for patterns like "/ 0" or "/0".
  /// It's not perfect (won't catch "/ (1-1)") but handles common cases.
  bool _containsDivisionByZero(String expression) {
    // Pattern: division followed by zero (with optional spaces)
    // but not followed by a decimal point (e.g., "/ 0.5" is valid)
    final divByZeroRegex = RegExp(r'/\s*0(?![.\d])');
    return divByZeroRegex.hasMatch(expression);
  }
}
