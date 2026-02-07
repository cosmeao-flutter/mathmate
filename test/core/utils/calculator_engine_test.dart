import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/utils/calculator_engine.dart';

/// Tests for the CalculatorEngine class.
///
/// Following TDD (Test-Driven Development):
/// 1. Write a failing test
/// 2. Write minimal code to make it pass
/// 3. Refactor
///
/// These tests cover:
/// - Basic arithmetic operations
/// - PEMDAS order of operations
/// - Decimal handling
/// - Parentheses (including auto-balance)
/// - Implicit multiplication
/// - Error handling
void main() {
  late CalculatorEngine engine;

  // Create a fresh engine instance before each test
  setUp(() {
    engine = CalculatorEngine();
  });

  // ==========================================================
  // GROUP: Basic Arithmetic
  // ==========================================================
  group('Basic Arithmetic', () {
    test('addition: 2 + 3 = 5', () {
      final result = engine.evaluate('2 + 3');
      expect(result.value, equals(5));
      expect(result.isError, isFalse);
    });

    test('subtraction: 10 - 4 = 6', () {
      final result = engine.evaluate('10 - 4');
      expect(result.value, equals(6));
      expect(result.isError, isFalse);
    });

    test('multiplication: 6 * 7 = 42', () {
      final result = engine.evaluate('6 * 7');
      expect(result.value, equals(42));
      expect(result.isError, isFalse);
    });

    test('division: 20 / 4 = 5', () {
      final result = engine.evaluate('20 / 4');
      expect(result.value, equals(5));
      expect(result.isError, isFalse);
    });

    test('negative result: 5 - 10 = -5', () {
      final result = engine.evaluate('5 - 10');
      expect(result.value, equals(-5));
      expect(result.isError, isFalse);
    });

    test('zero: 0 + 0 = 0', () {
      final result = engine.evaluate('0 + 0');
      expect(result.value, equals(0));
      expect(result.isError, isFalse);
    });

    test('large numbers: 1000000 * 1000000', () {
      final result = engine.evaluate('1000000 * 1000000');
      expect(result.value, equals(1000000000000));
      expect(result.isError, isFalse);
    });
  });

  // ==========================================================
  // GROUP: PEMDAS Order of Operations
  // ==========================================================
  group('PEMDAS Order of Operations', () {
    test('multiplication before addition: 2 + 3 * 4 = 14', () {
      final result = engine.evaluate('2 + 3 * 4');
      expect(result.value, equals(14));
    });

    test('division before subtraction: 10 - 6 / 2 = 7', () {
      final result = engine.evaluate('10 - 6 / 2');
      expect(result.value, equals(7));
    });

    test('parentheses override precedence: (2 + 3) * 4 = 20', () {
      final result = engine.evaluate('(2 + 3) * 4');
      expect(result.value, equals(20));
    });

    test('complex expression: 2 + 3 * 4 - 5 / 5 = 13', () {
      // 2 + 12 - 1 = 13
      final result = engine.evaluate('2 + 3 * 4 - 5 / 5');
      expect(result.value, equals(13));
    });

    test('nested parentheses: ((2 + 3) * 2) + 1 = 11', () {
      final result = engine.evaluate('((2 + 3) * 2) + 1');
      expect(result.value, equals(11));
    });

    test('multiple parentheses: (1 + 2) * (3 + 4) = 21', () {
      final result = engine.evaluate('(1 + 2) * (3 + 4)');
      expect(result.value, equals(21));
    });
  });

  // ==========================================================
  // GROUP: Decimal Handling
  // ==========================================================
  group('Decimal Handling', () {
    test('decimal addition: 1.5 + 2.5 = 4', () {
      final result = engine.evaluate('1.5 + 2.5');
      expect(result.value, equals(4));
    });

    test('decimal multiplication: 3.14 * 2 = 6.28', () {
      final result = engine.evaluate('3.14 * 2');
      expect(result.value, closeTo(6.28, 0.001));
    });

    test('decimal division: 10 / 4 = 2.5', () {
      final result = engine.evaluate('10 / 4');
      expect(result.value, equals(2.5));
    });

    test('small decimals: 0.1 + 0.2', () {
      final result = engine.evaluate('0.1 + 0.2');
      // Floating point: 0.1 + 0.2 is approximately 0.3
      expect(result.value, closeTo(0.3, 0.0001));
    });

    test('leading zero decimal: 0.5 * 2 = 1', () {
      final result = engine.evaluate('0.5 * 2');
      expect(result.value, equals(1));
    });
  });

  // ==========================================================
  // GROUP: Parentheses Auto-Balance
  // ==========================================================
  group('Parentheses Auto-Balance', () {
    test('auto-close single unclosed paren: (2 + 3 = 5', () {
      final result = engine.evaluate('(2 + 3');
      expect(result.value, equals(5));
      expect(result.isError, isFalse);
    });

    test('auto-close multiple unclosed parens: ((2 + 3 = 5', () {
      final result = engine.evaluate('((2 + 3');
      expect(result.value, equals(5));
      expect(result.isError, isFalse);
    });

    test('auto-close nested unclosed: (2 * (3 + 4 = 14', () {
      final result = engine.evaluate('(2 * (3 + 4');
      expect(result.value, equals(14));
      expect(result.isError, isFalse);
    });

    test('properly closed parens still work: (2 + 3) * 2 = 10', () {
      final result = engine.evaluate('(2 + 3) * 2');
      expect(result.value, equals(10));
    });
  });

  // ==========================================================
  // GROUP: Implicit Multiplication
  // ==========================================================
  group('Implicit Multiplication', () {
    test('number before paren: 2(3 + 4) = 14', () {
      final result = engine.evaluate('2(3 + 4)');
      expect(result.value, equals(14));
    });

    test('paren before number: (2 + 3)4 = 20', () {
      final result = engine.evaluate('(2 + 3)4');
      expect(result.value, equals(20));
    });

    test('paren next to paren: (2)(3) = 6', () {
      final result = engine.evaluate('(2)(3)');
      expect(result.value, equals(6));
    });

    test('complex implicit: 2(3 + 4)(2) = 28', () {
      final result = engine.evaluate('2(3 + 4)(2)');
      expect(result.value, equals(28));
    });
  });

  // ==========================================================
  // GROUP: Percentage
  // ==========================================================
  group('Percentage', () {
    test('simple percent: 50% = 0.5', () {
      final result = engine.evaluate('50%');
      expect(result.value, equals(0.5));
    });

    test('percent in expression: 100 * 50% = 50', () {
      final result = engine.evaluate('100 * 50%');
      expect(result.value, equals(50));
    });

    test('percent addition: 100 + 10% = 100.1', () {
      // 100 + 0.1 = 100.1 (10% becomes 0.1)
      final result = engine.evaluate('100 + 10%');
      expect(result.value, equals(100.1));
    });
  });

  // ==========================================================
  // GROUP: Error Handling
  // ==========================================================
  group('Error Handling', () {
    test('division by zero returns error', () {
      final result = engine.evaluate('5 / 0');
      expect(result.isError, isTrue);
      expect(result.errorType, CalculationErrorType.divisionByZero);
    });

    test('invalid expression returns error', () {
      // Using an expression that cannot be parsed
      final result = engine.evaluate('2 * / 3');
      expect(result.isError, isTrue);
    });

    test('empty expression returns error', () {
      final result = engine.evaluate('');
      expect(result.isError, isTrue);
    });

    test('only operators returns error', () {
      final result = engine.evaluate('+ - *');
      expect(result.isError, isTrue);
    });

    test('mismatched parentheses (extra close) returns error', () {
      final result = engine.evaluate('(2 + 3))');
      expect(result.isError, isTrue);
    });
  });

  // ==========================================================
  // GROUP: Edge Cases
  // ==========================================================
  group('Edge Cases', () {
    test('single number returns itself: 42', () {
      final result = engine.evaluate('42');
      expect(result.value, equals(42));
    });

    test('negative number: -5', () {
      final result = engine.evaluate('-5');
      expect(result.value, equals(-5));
    });

    test('double negative: --5 = 5', () {
      final result = engine.evaluate('--5');
      expect(result.value, equals(5));
    });

    test('expression with spaces: 2  +  3', () {
      final result = engine.evaluate('2  +  3');
      expect(result.value, equals(5));
    });

    test('expression with Unicode operators: 2 × 3', () {
      // The engine should handle Unicode multiplication sign
      final result = engine.evaluate('2 × 3');
      expect(result.value, equals(6));
    });

    test('expression with Unicode division: 10 ÷ 2', () {
      final result = engine.evaluate('10 ÷ 2');
      expect(result.value, equals(5));
    });

    test('expression with Unicode minus: 5 − 3', () {
      final result = engine.evaluate('5 − 3');
      expect(result.value, equals(2));
    });
  });

  // ==========================================================
  // GROUP: Result Formatting
  // ==========================================================
  group('Result Formatting', () {
    test('integer result displays without decimal', () {
      final result = engine.evaluate('4 / 2');
      expect(result.displayValue, equals('2'));
    });

    test('decimal result displays with decimals', () {
      final result = engine.evaluate('5 / 2');
      expect(result.displayValue, equals('2.5'));
    });

    test('very large number uses scientific notation', () {
      final result = engine.evaluate('9999999999999999');
      // Should be displayed in scientific notation or truncated
      expect(result.displayValue.length, lessThanOrEqualTo(15));
    });

    test('very small decimal uses scientific notation', () {
      final result = engine.evaluate('0.0000000001');
      expect(result.displayValue, contains('e'));
    });
  });
}
