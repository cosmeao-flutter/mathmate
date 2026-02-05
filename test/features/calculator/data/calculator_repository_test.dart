import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CalculatorRepository', () {
    late CalculatorRepository repository;

    setUp(() {
      // Set up fake SharedPreferences values before each test
      SharedPreferences.setMockInitialValues({});
    });

    group('saveState', () {
      test('saves expression to SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: '2 + 3',
          result: '5',
        );

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('calculator_expression'), equals('2 + 3'));
      });

      test('saves result to SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: '2 + 3',
          result: '5',
        );

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('calculator_result'), equals('5'));
      });

      test('saves empty expression', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: '',
          result: '0',
        );

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('calculator_expression'), equals(''));
      });

      test('overwrites previous state', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': 'old',
          'calculator_result': '0',
        });
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: 'new',
          result: '10',
        );

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('calculator_expression'), equals('new'));
        expect(prefs.getString('calculator_result'), equals('10'));
      });
    });

    group('loadState', () {
      test('returns saved expression and result', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': '10 + 5',
          'calculator_result': '15',
        });
        repository = await CalculatorRepository.create();

        final state = repository.loadState();

        expect(state.expression, equals('10 + 5'));
        expect(state.result, equals('15'));
      });

      test('returns empty state when nothing saved', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        final state = repository.loadState();

        expect(state.expression, equals(''));
        expect(state.result, equals(''));
      });

      test('returns empty expression when only result saved', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_result': '42',
        });
        repository = await CalculatorRepository.create();

        final state = repository.loadState();

        expect(state.expression, equals(''));
        expect(state.result, equals('42'));
      });

      test('returns empty result when only expression saved', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': '1 + 1',
        });
        repository = await CalculatorRepository.create();

        final state = repository.loadState();

        expect(state.expression, equals('1 + 1'));
        expect(state.result, equals(''));
      });
    });

    group('clearState', () {
      test('removes saved expression and result', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': '2 + 2',
          'calculator_result': '4',
        });
        repository = await CalculatorRepository.create();

        await repository.clearState();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('calculator_expression'), isNull);
        expect(prefs.getString('calculator_result'), isNull);
      });

      test('works when nothing is saved', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        // Should not throw
        await repository.clearState();

        final state = repository.loadState();
        expect(state.expression, equals(''));
        expect(state.result, equals(''));
      });
    });

    group('hasState', () {
      test('returns true when expression is saved', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': '5 × 5',
        });
        repository = await CalculatorRepository.create();

        expect(repository.hasState, isTrue);
      });

      test('returns true when result is saved', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_result': '25',
        });
        repository = await CalculatorRepository.create();

        expect(repository.hasState, isTrue);
      });

      test('returns false when nothing saved', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        expect(repository.hasState, isFalse);
      });

      test('returns false after clearState', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': '1 + 1',
          'calculator_result': '2',
        });
        repository = await CalculatorRepository.create();

        await repository.clearState();

        expect(repository.hasState, isFalse);
      });
    });

    group('edge cases', () {
      test('handles special characters in expression', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: '(-5) × (3 + 2)',
          result: '-25',
        );

        final state = repository.loadState();
        expect(state.expression, equals('(-5) × (3 + 2)'));
        expect(state.result, equals('-25'));
      });

      test('handles scientific notation in result', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: '999999999999999',
          result: '1e+15',
        );

        final state = repository.loadState();
        expect(state.result, equals('1e+15'));
      });

      test('handles decimal numbers', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();

        await repository.saveState(
          expression: '3.14159',
          result: '3.14159',
        );

        final state = repository.loadState();
        expect(state.expression, equals('3.14159'));
        expect(state.result, equals('3.14159'));
      });
    });
  });
}
