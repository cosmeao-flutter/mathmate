import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/core/utils/calculator_engine.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockHistoryRepository extends Mock
    implements HistoryRepository {}

class MockCalculatorRepository extends Mock
    implements CalculatorRepository {}

void main() {
  group('CalculatorBloc', () {
    late CalculatorBloc bloc;

    setUp(() {
      bloc = CalculatorBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is CalculatorInitial', () {
      expect(bloc.state, isA<CalculatorInitial>());
      expect(bloc.state.expression, '');
      expect(bloc.state.display, '0');
    });

    group('DigitPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'replaces initial 0 with digit',
        build: CalculatorBloc.new,
        act: (bloc) => bloc.add(const DigitPressed('5')),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '5')
              .having((s) => s.display, 'display', '5'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'appends digit to existing expression',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('2'))
          ..add(const DigitPressed('3')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '1'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '12'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '123'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'appends 0 after other digits',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('0')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '1'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '10'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'starts new expression after result with digit',
        build: CalculatorBloc.new,
        seed: () => const CalculatorResult(
          expression: '2 + 3',
          display: '5',
          result: '5',
        ),
        act: (bloc) => bloc.add(const DigitPressed('7')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '7'),
        ],
      );
    });

    group('OperatorPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'appends operator after digit',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('+')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '5 + '),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'replaces operator with new operator',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('+'))
          ..add(const OperatorPressed('−')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '5 + '),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '5 − '),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'continues from result with operator',
        build: CalculatorBloc.new,
        seed: () => const CalculatorResult(
          expression: '2 + 3',
          display: '5',
          result: '5',
        ),
        act: (bloc) => bloc.add(const OperatorPressed('×')),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '5 × '),
        ],
      );
    });

    group('DecimalPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'adds decimal to number',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('3'))
          ..add(const DecimalPressed())
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('4')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '3'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '3.'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '3.1'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '3.14'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'does not add duplicate decimal in same number',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('3'))
          ..add(const DecimalPressed())
          ..add(const DigitPressed('1'))
          ..add(const DecimalPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '3'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '3.'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '3.1'),
          // No fourth state - duplicate decimal ignored
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'adds leading zero for decimal at start',
        build: CalculatorBloc.new,
        act: (bloc) => bloc.add(const DecimalPressed()),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '0.'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'allows decimal in new number after operator',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('1'))
          ..add(const DecimalPressed())
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('+'))
          ..add(const DecimalPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '1'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '1.'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '1.5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '1.5 + '),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '1.5 + 0.'),
        ],
      );
    });

    group('EqualsPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'evaluates simple addition',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '2'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '2 + '),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '2 + 3'),
          isA<CalculatorResult>()
              .having((s) => s.expression, 'expression', '2 + 3')
              .having((s) => s.result, 'result', '5'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'evaluates expression with PEMDAS',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const OperatorPressed('×'))
          ..add(const DigitPressed('4'))
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorResult>()
              .having((s) => s.result, 'result', '14'), // PEMDAS: 2 + (3*4)
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'shows error for division by zero',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('÷'))
          ..add(const DigitPressed('0'))
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorError>().having(
            (s) => s.errorType,
            'errorType',
            CalculationErrorType.divisionByZero,
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'does nothing when expression is empty',
        build: CalculatorBloc.new,
        act: (bloc) => bloc.add(const EqualsPressed()),
        expect: () => <CalculatorState>[],
      );
    });

    group('ClearPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'deletes last character',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('2'))
          ..add(const DigitPressed('3'))
          ..add(const ClearPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '1'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '12'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '123'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '12'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'deletes operator with surrounding spaces',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('+'))
          ..add(const ClearPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '5 + '),
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'returns to initial when expression becomes empty',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const ClearPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInitial>(),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'clears all from result state',
        build: CalculatorBloc.new,
        seed: () => const CalculatorResult(
          expression: '2 + 3',
          display: '5',
          result: '5',
        ),
        act: (bloc) => bloc.add(const ClearPressed()),
        expect: () => [isA<CalculatorInitial>()],
      );
    });

    group('AllClearPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'resets to initial state',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('2'))
          ..add(const DigitPressed('3'))
          ..add(const AllClearPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInitial>(),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'resets from error state',
        build: CalculatorBloc.new,
        seed: () => const CalculatorError(
          expression: '5 ÷ 0',
          errorType: CalculationErrorType.divisionByZero,
        ),
        act: (bloc) => bloc.add(const AllClearPressed()),
        expect: () => [isA<CalculatorInitial>()],
      );
    });

    group('ParenthesisPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'adds opening parenthesis',
        build: CalculatorBloc.new,
        act: (bloc) => bloc.add(const ParenthesisPressed(isOpen: true)),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '('),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'adds closing parenthesis after expression',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const ParenthesisPressed(isOpen: true))
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const ParenthesisPressed(isOpen: false)),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '('),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '(2'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '(2 + '),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '(2 + 3'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '(2 + 3)'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'evaluates expression with parentheses',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const ParenthesisPressed(isOpen: true))
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const ParenthesisPressed(isOpen: false))
          ..add(const OperatorPressed('×'))
          ..add(const DigitPressed('4'))
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorResult>()
              .having((s) => s.result, 'result', '20'), // (2+3)*4 = 20
        ],
      );
    });

    group('PlusMinusPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'negates positive number',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const PlusMinusPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '(-5'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'removes negation from negative number',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const PlusMinusPressed())
          ..add(const PlusMinusPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '(-5'),
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
        ],
      );
    });

    group('PercentPressed', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'appends percent symbol',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const DigitPressed('0'))
          ..add(const PercentPressed()),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '5'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '50'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '50%'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'evaluates percentage correctly',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('1'))
          ..add(const DigitPressed('0'))
          ..add(const DigitPressed('0'))
          ..add(const OperatorPressed('×'))
          ..add(const DigitPressed('5'))
          ..add(const DigitPressed('0'))
          ..add(const PercentPressed())
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorResult>()
              .having((s) => s.result, 'result', '50'), // 100 × 50% = 50
        ],
      );
    });

    group('Live Result Preview', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'shows live result as user types',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3')),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '2')
              .having((s) => s.liveResult, 'liveResult', '2'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '2 + ')
              .having((s) => s.liveResult, 'liveResult', '2'),
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '2 + 3')
              .having((s) => s.liveResult, 'liveResult', '5'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'updates live result with PEMDAS',
        build: CalculatorBloc.new,
        act: (bloc) => bloc
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const OperatorPressed('×'))
          ..add(const DigitPressed('4')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.liveResult, 'liveResult', '2'),
          isA<CalculatorInput>().having((s) => s.liveResult, 'liveResult', '2'),
          isA<CalculatorInput>().having((s) => s.liveResult, 'liveResult', '5'),
          isA<CalculatorInput>().having((s) => s.liveResult, 'liveResult', '5'),
          isA<CalculatorInput>()
              .having((s) => s.liveResult, 'liveResult', '14'),
        ],
      );
    });

    group('CalculatorStarted', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'does not change initial state',
        build: CalculatorBloc.new,
        act: (bloc) => bloc.add(const CalculatorStarted()),
        expect: () => <CalculatorState>[],
      );
    });

    group('Error Recovery', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'digit after error starts new expression',
        build: CalculatorBloc.new,
        seed: () => const CalculatorError(
          expression: '5 ÷ 0',
          errorType: CalculationErrorType.divisionByZero,
        ),
        act: (bloc) => bloc.add(const DigitPressed('7')),
        expect: () => [
          isA<CalculatorInput>().having((s) => s.expression, 'expression', '7'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'operator after error is ignored',
        build: CalculatorBloc.new,
        seed: () => const CalculatorError(
          expression: '5 ÷ 0',
          errorType: CalculationErrorType.divisionByZero,
        ),
        act: (bloc) => bloc.add(const OperatorPressed('+')),
        expect: () => <CalculatorState>[],
      );
    });

    group('Persistence', () {
      late CalculatorRepository repository;

      setUp(() async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();
      });

      blocTest<CalculatorBloc, CalculatorState>(
        'loads saved expression on CalculatorStarted',
        setUp: () async {
          SharedPreferences.setMockInitialValues({
            'calculator_expression': '2 + 3',
            'calculator_result': '5',
          });
          repository = await CalculatorRepository.create();
        },
        build: () => CalculatorBloc(repository: repository),
        act: (bloc) => bloc.add(const CalculatorStarted()),
        expect: () => [
          isA<CalculatorInput>()
              .having((s) => s.expression, 'expression', '2 + 3')
              .having((s) => s.liveResult, 'liveResult', '5'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'loads saved result when only result is saved',
        setUp: () async {
          SharedPreferences.setMockInitialValues({
            'calculator_expression': '',
            'calculator_result': '42',
          });
          repository = await CalculatorRepository.create();
        },
        build: () => CalculatorBloc(repository: repository),
        act: (bloc) => bloc.add(const CalculatorStarted()),
        expect: () => [
          isA<CalculatorResult>()
              .having((s) => s.result, 'result', '42'),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'does nothing when no saved state',
        setUp: () async {
          SharedPreferences.setMockInitialValues({});
          repository = await CalculatorRepository.create();
        },
        build: () => CalculatorBloc(repository: repository),
        act: (bloc) => bloc.add(const CalculatorStarted()),
        expect: () => <CalculatorState>[],
      );

      test('saves state on digit pressed', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();
        final bloc = CalculatorBloc(repository: repository);

        bloc.add(const DigitPressed('5'));
        await Future<void>.delayed(Duration.zero);

        final savedState = repository.loadState();
        expect(savedState.expression, equals('5'));
      });

      test('saves state on equals pressed', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();
        final bloc = CalculatorBloc(repository: repository);

        bloc
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const EqualsPressed());
        await Future<void>.delayed(Duration.zero);

        final savedState = repository.loadState();
        expect(savedState.expression, equals('2 + 3'));
        expect(savedState.result, equals('5'));
      });

      test('clears saved state on AllClearPressed', () async {
        SharedPreferences.setMockInitialValues({
          'calculator_expression': '2 + 3',
          'calculator_result': '5',
        });
        repository = await CalculatorRepository.create();
        final bloc = CalculatorBloc(repository: repository);

        bloc.add(const AllClearPressed());
        await Future<void>.delayed(Duration.zero);

        expect(repository.hasState, isFalse);
      });

      test('does not save error states', () async {
        SharedPreferences.setMockInitialValues({});
        repository = await CalculatorRepository.create();
        final bloc = CalculatorBloc(repository: repository);

        bloc
          ..add(const DigitPressed('5'))
          ..add(const OperatorPressed('÷'))
          ..add(const DigitPressed('0'))
          ..add(const EqualsPressed());
        await Future<void>.delayed(Duration.zero);

        // The last saved state should be the input before the error
        final savedState = repository.loadState();
        expect(savedState.expression, equals('5 ÷ 0'));
        // Result is the live result before equals, not the error
      });
    });

    group('error handling', () {
      blocTest<CalculatorBloc, CalculatorState>(
        'still emits result when history save fails',
        build: () {
          final mockLogger = MockAppLogger();
          final mockHistoryRepo = MockHistoryRepository();
          when(
            () => mockLogger.error(
              any(),
              any(),
              any(),
            ),
          ).thenReturn(null);
          when(
            () => mockHistoryRepo.addEntry(
              expression: any(named: 'expression'),
              result: any(named: 'result'),
            ),
          ).thenThrow(Exception('db error'));

          return CalculatorBloc(
            historyRepository: mockHistoryRepo,
            logger: mockLogger,
          );
        },
        act: (bloc) => bloc
          ..add(const DigitPressed('2'))
          ..add(const OperatorPressed('+'))
          ..add(const DigitPressed('3'))
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorInput>(),
          isA<CalculatorResult>().having(
            (s) => s.result,
            'result',
            '5',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'still emits input when state save fails',
        build: () {
          final mockLogger = MockAppLogger();
          final mockCalcRepo = MockCalculatorRepository();
          when(
            () => mockLogger.error(
              any(),
              any(),
              any(),
            ),
          ).thenReturn(null);
          when(
            () => mockCalcRepo.saveState(
              expression: any(named: 'expression'),
              result: any(named: 'result'),
            ),
          ).thenThrow(Exception('prefs error'));
          when(() => mockCalcRepo.hasState)
              .thenReturn(false);

          return CalculatorBloc(
            repository: mockCalcRepo,
            logger: mockLogger,
          );
        },
        act: (bloc) =>
            bloc.add(const DigitPressed('5')),
        expect: () => [
          isA<CalculatorInput>().having(
            (s) => s.expression,
            'expression',
            '5',
          ),
        ],
      );

      blocTest<CalculatorBloc, CalculatorState>(
        'still emits result when state save fails '
        'on equals',
        build: () {
          final mockLogger = MockAppLogger();
          final mockCalcRepo = MockCalculatorRepository();
          when(
            () => mockLogger.error(
              any(),
              any(),
              any(),
            ),
          ).thenReturn(null);
          when(
            () => mockCalcRepo.saveState(
              expression: any(named: 'expression'),
              result: any(named: 'result'),
            ),
          ).thenThrow(Exception('prefs error'));
          when(() => mockCalcRepo.hasState)
              .thenReturn(false);
          when(mockCalcRepo.clearState)
              .thenAnswer((_) async {});

          return CalculatorBloc(
            repository: mockCalcRepo,
            logger: mockLogger,
          );
        },
        act: (bloc) => bloc
          ..add(const DigitPressed('5'))
          ..add(const EqualsPressed()),
        expect: () => [
          isA<CalculatorInput>(),
          isA<CalculatorResult>(),
        ],
      );
    });
  });
}
