import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_cubit.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_state.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/home/presentation/screens/home_screen.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockCalculatorRepository extends Mock
    implements CalculatorRepository {}

class MockHistoryRepository extends Mock
    implements HistoryRepository {}

class MockCurrencyCubit extends MockCubit<CurrencyState>
    implements CurrencyCubit {}

class MockThemeCubit extends MockCubit<ThemeState>
    implements ThemeCubit {}

class MockAccessibilityCubit extends MockCubit<AccessibilityState>
    implements AccessibilityCubit {}

void main() {
  late MockCalculatorRepository mockCalcRepo;
  late MockHistoryRepository mockHistoryRepo;
  late MockCurrencyCubit mockCurrencyCubit;
  late MockThemeCubit mockThemeCubit;
  late MockAccessibilityCubit mockAccessibilityCubit;

  setUp(() {
    mockCalcRepo = MockCalculatorRepository();
    mockHistoryRepo = MockHistoryRepository();
    mockCurrencyCubit = MockCurrencyCubit();
    mockThemeCubit = MockThemeCubit();
    mockAccessibilityCubit = MockAccessibilityCubit();

    // Stubs for CalculatorBloc initialization
    when(() => mockCalcRepo.hasState).thenReturn(false);
    when(() => mockCalcRepo.loadState()).thenReturn(
      const SavedCalculatorState(expression: '', result: ''),
    );
    when(() => mockCalcRepo.saveState(
          expression: any(named: 'expression'),
          result: any(named: 'result'),
        )).thenAnswer((_) async {});
    when(() => mockCalcRepo.clearState())
        .thenAnswer((_) async {});
    when(() => mockCurrencyCubit.state).thenReturn(
      const CurrencyInitial(
        fromCurrency: 'USD',
        toCurrency: 'EUR',
      ),
    );
    when(() => mockThemeCubit.state).thenReturn(
      const ThemeState(
        themeMode: ThemeMode.system,
        accentColor: AccentColor.blue,
      ),
    );
    when(() => mockAccessibilityCubit.state).thenReturn(
      const AccessibilityState(),
    );
  });

  Widget buildApp() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
        BlocProvider<AccessibilityCubit>.value(
          value: mockAccessibilityCubit,
        ),
        BlocProvider<CurrencyCubit>.value(
          value: mockCurrencyCubit,
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates:
            AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(
          calculatorRepository: mockCalcRepo,
          historyRepository: mockHistoryRepo,
        ),
      ),
    );
  }

  group('rendering', () {
    testWidgets('shows NavigationBar with 2 destinations',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(
        find.byIcon(Icons.calculate),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.currency_exchange),
        findsOneWidget,
      );
    });

    testWidgets('shows Calculator and Currency labels',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Calculator'), findsOneWidget);
      expect(find.text('Currency'), findsOneWidget);
    });

    testWidgets('defaults to Calculator tab', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navBar.selectedIndex, 0);
    });
  });

  group('tab switching', () {
    testWidgets('switches to Currency tab on tap',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Currency'));
      await tester.pump();

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('switches back to Calculator tab',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Currency'));
      await tester.pump();

      await tester.tap(find.text('Calculator'));
      await tester.pump();

      final navBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );
      expect(navBar.selectedIndex, 0);
    });
  });

  group('IndexedStack', () {
    testWidgets('uses IndexedStack for state preservation',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(IndexedStack), findsOneWidget);
    });

    testWidgets('IndexedStack contains both screens',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      final indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.children.length, 2);
    });

    testWidgets('IndexedStack index matches selected tab',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Default: index 0
      var indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 0);

      // Switch to Currency: index 1
      await tester.tap(find.text('Currency'));
      await tester.pump();

      indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 1);
    });
  });

  group('landscape navigation', () {
    testWidgets('shows NavigationRail in landscape',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('NavigationRail has correct destinations',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(
        find.byIcon(Icons.calculate),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.currency_exchange),
        findsOneWidget,
      );
    });

    testWidgets('tab switching works via NavigationRail',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      // Default: index 0
      var indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 0);

      // Tap Currency icon in NavigationRail
      await tester.tap(
        find.byIcon(Icons.currency_exchange),
      );
      await tester.pump();

      indexedStack = tester.widget<IndexedStack>(
        find.byType(IndexedStack),
      );
      expect(indexedStack.index, 1);
    });

    testWidgets('portrait still shows NavigationBar',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });
  });
}
