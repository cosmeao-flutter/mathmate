import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_cubit.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_state.dart';
import 'package:math_mate/features/currency/presentation/screens/currency_screen.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyCubit extends MockCubit<CurrencyState>
    implements CurrencyCubit {}

const _testCurrencies = {
  'EUR': 'Euro',
  'GBP': 'British Pound',
  'USD': 'United States Dollar',
};

const _loadedState = CurrencyLoaded(
  amount: 1,
  result: 0.85,
  fromCurrency: 'USD',
  toCurrency: 'EUR',
  rates: {'EUR': 0.85, 'GBP': 0.73},
  currencies: _testCurrencies,
  rateDate: '2026-02-06',
);

Widget buildApp({
  required CurrencyCubit cubit,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<CurrencyCubit>.value(
      value: cubit,
      child: const CurrencyScreen(),
    ),
  );
}

void main() {
  late MockCurrencyCubit mockCubit;

  setUp(() {
    mockCubit = MockCurrencyCubit();
  });

  group('loading state', () {
    testWidgets('shows loading indicator', (tester) async {
      when(() => mockCubit.state)
          .thenReturn(const CurrencyLoading());

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
      expect(
        find.text('Loading exchange rates...'),
        findsOneWidget,
      );
    });
  });

  group('error state', () {
    testWidgets('shows error message and retry button',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const CurrencyError(message: 'No internet'),
      );

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(
        find.text('Could not load exchange rates'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('retry button calls loadRates', (tester) async {
      when(() => mockCubit.state).thenReturn(
        const CurrencyError(message: 'No internet'),
      );
      when(() => mockCubit.loadRates())
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pump();

      verify(() => mockCubit.loadRates()).called(1);
    });
  });

  group('loaded state', () {
    setUp(() {
      when(() => mockCubit.state).thenReturn(_loadedState);
    });

    testWidgets('shows amount input', (tester) async {
      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.text('Amount'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows from and to currency pickers',
        (tester) async {
      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.text('From'), findsOneWidget);
      expect(find.text('To'), findsOneWidget);
      expect(
        find.byType(DropdownButton<String>),
        findsNWidgets(2),
      );
    });

    testWidgets('shows swap button', (tester) async {
      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.swap_vert), findsOneWidget);
    });

    testWidgets('shows converted result', (tester) async {
      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(find.text('Converted Result'), findsOneWidget);
      expect(find.text('0.85 EUR'), findsOneWidget);
    });

    testWidgets('shows rate date', (tester) async {
      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(
        find.text('Rates from 2026-02-06'),
        findsOneWidget,
      );
    });

    testWidgets('swap button calls swapCurrencies',
        (tester) async {
      when(() => mockCubit.swapCurrencies())
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.swap_vert));
      await tester.pump();

      verify(() => mockCubit.swapCurrencies()).called(1);
    });

    testWidgets('amount input calls updateAmount',
        (tester) async {
      when(() => mockCubit.updateAmount(any()))
          .thenReturn(null);

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '100',
      );
      await tester.pump();

      verify(() => mockCubit.updateAmount(100)).called(1);
    });
  });

  group('offline state', () {
    testWidgets('shows offline banner when using cached rates',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        _loadedState.copyWith(isOfflineCache: true),
      );

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(
        find.text('Showing cached rates (offline)'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });

    testWidgets('no offline banner when rates are fresh',
        (tester) async {
      when(() => mockCubit.state).thenReturn(_loadedState);

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pumpAndSettle();

      expect(
        find.text('Showing cached rates (offline)'),
        findsNothing,
      );
    });
  });

  group('initial state', () {
    testWidgets('shows loading for initial state',
        (tester) async {
      when(() => mockCubit.state).thenReturn(
        const CurrencyInitial(
          fromCurrency: 'USD',
          toCurrency: 'EUR',
        ),
      );

      await tester.pumpWidget(buildApp(cubit: mockCubit));
      await tester.pump();

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });
  });
}
