import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/currency/data/currency_repository.dart';
import 'package:math_mate/features/currency/data/currency_service.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_cubit.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCurrencyService extends Mock implements CurrencyService {}

const _testCurrencies = {
  'USD': 'United States Dollar',
  'EUR': 'Euro',
  'GBP': 'British Pound',
};

const _testRates = ExchangeRates(
  base: 'USD',
  date: '2026-02-06',
  rates: {'EUR': 0.85, 'GBP': 0.73},
);

void main() {
  late CurrencyRepository repository;
  late MockCurrencyService mockService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await CurrencyRepository.create();
    mockService = MockCurrencyService();
  });

  CurrencyCubit buildCubit() => CurrencyCubit(
        service: mockService,
        repository: repository,
      );

  group('initial state', () {
    test('emits CurrencyInitial with default currencies', () {
      final cubit = buildCubit();

      expect(
        cubit.state,
        isA<CurrencyInitial>()
            .having(
              (s) => s.fromCurrency,
              'fromCurrency',
              'USD',
            )
            .having(
              (s) => s.toCurrency,
              'toCurrency',
              'EUR',
            ),
      );

      cubit.close();
    });

    test('loads saved currency preferences', () async {
      await repository.saveFromCurrency('GBP');
      await repository.saveToCurrency('JPY');

      final cubit = buildCubit();

      expect(
        cubit.state,
        isA<CurrencyInitial>()
            .having(
              (s) => s.fromCurrency,
              'fromCurrency',
              'GBP',
            )
            .having(
              (s) => s.toCurrency,
              'toCurrency',
              'JPY',
            ),
      );

      cubit.close();
    });
  });

  group('loadRates', () {
    blocTest<CurrencyCubit, CurrencyState>(
      'emits Loading then Loaded on network success',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: 'USD'))
            .thenAnswer((_) async => _testRates);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having((s) => s.fromCurrency, 'from', 'USD')
            .having((s) => s.toCurrency, 'to', 'EUR')
            .having((s) => s.amount, 'amount', 1.0)
            .having((s) => s.rateDate, 'date', '2026-02-06')
            .having(
              (s) => s.isOfflineCache,
              'offline',
              isFalse,
            ),
      ],
    );

    blocTest<CurrencyCubit, CurrencyState>(
      'uses cached rates when cache is fresh',
      setUp: () async {
        await repository.saveRates(
          'USD',
          {'EUR': 0.85, 'GBP': 0.73},
        );
        await repository.saveRateDate('USD', '2026-02-06');
        await repository.saveCacheTimestamp('USD');
        await repository.saveCurrencies(_testCurrencies);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having(
              (s) => s.isOfflineCache,
              'offline',
              isFalse,
            ),
      ],
      verify: (_) {
        verifyNever(() => mockService.fetchRates(base: 'USD'));
      },
    );

    blocTest<CurrencyCubit, CurrencyState>(
      'falls back to stale cache on network error',
      setUp: () async {
        await repository.saveRates(
          'USD',
          {'EUR': 0.80},
        );
        await repository.saveRateDate('USD', '2026-02-05');
        await repository.saveCurrencies(_testCurrencies);
        // No fresh timestamp → cache is stale

        when(() => mockService.fetchCurrencies())
            .thenThrow(
          const CurrencyServiceException('No internet'),
        );
        when(() => mockService.fetchRates(base: 'USD'))
            .thenThrow(
          const CurrencyServiceException('No internet'),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having(
              (s) => s.isOfflineCache,
              'offline',
              isTrue,
            )
            .having(
              (s) => s.rates['EUR'],
              'cached rate',
              0.80,
            ),
      ],
    );

    blocTest<CurrencyCubit, CurrencyState>(
      'emits error when network fails and no cache',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenThrow(
          const CurrencyServiceException('No internet'),
        );
        when(() => mockService.fetchRates(base: 'USD'))
            .thenThrow(
          const CurrencyServiceException('No internet'),
        );
      },
      build: buildCubit,
      act: (cubit) => cubit.loadRates(),
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyError>(),
      ],
    );

    blocTest<CurrencyCubit, CurrencyState>(
      'caches rates after successful fetch',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: 'USD'))
            .thenAnswer((_) async => _testRates);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadRates(),
      verify: (_) {
        expect(repository.loadRates('USD'), isNotNull);
        expect(repository.loadCurrencies(), isNotNull);
        expect(repository.isCacheFresh('USD'), isTrue);
      },
    );
  });

  group('updateAmount', () {
    blocTest<CurrencyCubit, CurrencyState>(
      'recalculates result with new amount',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: 'USD'))
            .thenAnswer((_) async => _testRates);
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadRates();
        cubit.updateAmount(100);
      },
      skip: 2, // skip Loading + initial Loaded
      expect: () => [
        isA<CurrencyLoaded>()
            .having((s) => s.amount, 'amount', 100)
            .having((s) => s.result, 'result', 85.0),
      ],
    );

    blocTest<CurrencyCubit, CurrencyState>(
      'does nothing when state is not Loaded',
      build: buildCubit,
      act: (cubit) => cubit.updateAmount(100),
      expect: () => <CurrencyState>[],
    );
  });

  group('setFromCurrency', () {
    blocTest<CurrencyCubit, CurrencyState>(
      'fetches new rates and recalculates',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: any(named: 'base')))
            .thenAnswer((_) async => _testRates);
        when(() => mockService.fetchRates(base: 'EUR'))
            .thenAnswer(
          (_) async => const ExchangeRates(
            base: 'EUR',
            date: '2026-02-06',
            rates: {'USD': 1.18, 'GBP': 0.86},
          ),
        );
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadRates();
        await cubit.setFromCurrency('EUR');
      },
      skip: 2, // skip Loading + initial Loaded
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having((s) => s.fromCurrency, 'from', 'EUR'),
      ],
      verify: (_) {
        expect(repository.loadFromCurrency(), 'EUR');
      },
    );
  });

  group('setToCurrency', () {
    blocTest<CurrencyCubit, CurrencyState>(
      'recalculates with new target currency',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: 'USD'))
            .thenAnswer((_) async => _testRates);
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadRates();
        await cubit.setToCurrency('GBP');
      },
      skip: 2,
      expect: () => [
        isA<CurrencyLoaded>()
            .having((s) => s.toCurrency, 'to', 'GBP')
            .having((s) => s.result, 'result', 0.73),
      ],
      verify: (_) {
        expect(repository.loadToCurrency(), 'GBP');
      },
    );
  });

  group('swapCurrencies', () {
    blocTest<CurrencyCubit, CurrencyState>(
      'swaps from and to currencies and fetches new rates',
      setUp: () {
        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: 'USD'))
            .thenAnswer((_) async => _testRates);
        when(() => mockService.fetchRates(base: 'EUR'))
            .thenAnswer(
          (_) async => const ExchangeRates(
            base: 'EUR',
            date: '2026-02-06',
            rates: {'USD': 1.18, 'GBP': 0.86},
          ),
        );
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadRates();
        await cubit.swapCurrencies();
      },
      skip: 2,
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having((s) => s.fromCurrency, 'from', 'EUR')
            .having((s) => s.toCurrency, 'to', 'USD'),
      ],
      verify: (_) {
        expect(repository.loadFromCurrency(), 'EUR');
        expect(repository.loadToCurrency(), 'USD');
      },
    );

    blocTest<CurrencyCubit, CurrencyState>(
      'does nothing when state is not Loaded',
      build: buildCubit,
      act: (cubit) => cubit.swapCurrencies(),
      expect: () => <CurrencyState>[],
    );
  });

  group('refresh', () {
    blocTest<CurrencyCubit, CurrencyState>(
      'force-fetches from network ignoring cache',
      setUp: () async {
        // Set up fresh cache
        await repository.saveRates(
          'USD',
          {'EUR': 0.80},
        );
        await repository.saveCacheTimestamp('USD');
        await repository.saveCurrencies(_testCurrencies);

        when(() => mockService.fetchCurrencies())
            .thenAnswer((_) async => _testCurrencies);
        when(() => mockService.fetchRates(base: 'USD'))
            .thenAnswer((_) async => _testRates);
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.loadRates(); // uses cache
        await cubit.refresh(); // forces network
      },
      skip: 2,
      expect: () => [
        isA<CurrencyLoading>(),
        isA<CurrencyLoaded>()
            .having(
              (s) => s.rates['EUR'],
              'fresh rate',
              0.85,
            ),
      ],
      verify: (_) {
        verify(
          () => mockService.fetchRates(base: 'USD'),
        ).called(1);
      },
    );
  });

  group('CurrencyState equality', () {
    test('CurrencyInitial with same values are equal', () {
      const a = CurrencyInitial(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
      );
      const b = CurrencyInitial(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
      );
      expect(a, b);
    });

    test('CurrencyLoaded copyWith updates fields', () {
      const state = CurrencyLoaded(
        amount: 1,
        result: 0.85,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        rates: {'EUR': 0.85},
        currencies: {'USD': 'Dollar', 'EUR': 'Euro'},
        rateDate: '2026-02-06',
      );

      final updated = state.copyWith(amount: 100, result: 85);

      expect(updated.amount, 100);
      expect(updated.result, 85);
      expect(updated.fromCurrency, 'USD'); // unchanged
    });

    test('CurrencyError with same message are equal', () {
      const a = CurrencyError(message: 'error');
      const b = CurrencyError(message: 'error');
      expect(a, b);
    });
  });
}
