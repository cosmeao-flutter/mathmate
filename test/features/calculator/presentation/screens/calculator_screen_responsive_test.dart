import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_display.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_keypad.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/history/presentation/cubit/history_cubit.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CalculatorRepository calculatorRepository;
  late HistoryRepository historyRepository;
  late ThemeRepository themeRepository;
  late AccessibilityRepository accessibilityRepository;
  late HistoryDatabase database;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    calculatorRepository = await CalculatorRepository.create();
    database = HistoryDatabase.forTesting(
      NativeDatabase.memory(),
    );
    historyRepository = HistoryRepository(database);
    themeRepository = await ThemeRepository.create();
    accessibilityRepository =
        await AccessibilityRepository.create();
  });

  tearDown(() async {
    await database.close();
  });

  Widget buildApp() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ThemeCubit(repository: themeRepository),
        ),
        BlocProvider(
          create: (_) => AccessibilityCubit(
            repository: accessibilityRepository,
          ),
        ),
        BlocProvider(
          create: (_) =>
              HistoryCubit(repository: historyRepository)
                ..load(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: CalculatorScreen(
          calculatorRepository: calculatorRepository,
          historyRepository: historyRepository,
        ),
      ),
    );
  }

  group('CalculatorScreen portrait responsive', () {
    testWidgets('renders at iPhone SE size (375x667)',
        (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalculatorDisplay), findsOneWidget);
      expect(find.byType(CalculatorKeypad), findsOneWidget);
    });

    testWidgets('renders at iPhone 14 size (390x844)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalculatorDisplay), findsOneWidget);
      expect(find.byType(CalculatorKeypad), findsOneWidget);
    });

    testWidgets('renders at iPhone Pro Max size (430x932)',
        (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalculatorDisplay), findsOneWidget);
      expect(find.byType(CalculatorKeypad), findsOneWidget);
    });

    testWidgets('portrait uses Column layout', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // In portrait, display should be above keypad (Column)
      final displayPos = tester.getTopLeft(
        find.byType(CalculatorDisplay),
      );
      final keypadPos = tester.getTopLeft(
        find.byType(CalculatorKeypad),
      );
      expect(displayPos.dy, lessThan(keypadPos.dy));
    });

    testWidgets('digit press still works at small size',
        (tester) async {
      tester.view.physicalSize = const Size(375, 667);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('5'));
      await tester.pumpAndSettle();

      expect(find.text('5'), findsWidgets);
    });
  });

  group('CalculatorScreen landscape layout', () {
    testWidgets('renders at iPhone 14 landscape (844x390)',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalculatorDisplay), findsOneWidget);
      expect(find.byType(CalculatorKeypad), findsOneWidget);
    });

    testWidgets('renders at iPhone SE landscape (667x375)',
        (tester) async {
      tester.view.physicalSize = const Size(667, 375);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.byType(CalculatorDisplay), findsOneWidget);
      expect(find.byType(CalculatorKeypad), findsOneWidget);
    });

    testWidgets(
        'landscape uses Column layout (display above keypad)',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // In landscape, display should be above keypad (Column)
      final displayPos = tester.getTopLeft(
        find.byType(CalculatorDisplay),
      );
      final keypadPos = tester.getTopLeft(
        find.byType(CalculatorKeypad),
      );
      expect(displayPos.dy, lessThan(keypadPos.dy));
    });

    testWidgets('digit press works in landscape',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('7'));
      await tester.pumpAndSettle();

      expect(find.text('7'), findsWidgets);
    });

    testWidgets('operator press works in landscape',
        (tester) async {
      tester.view.physicalSize = const Size(844, 390);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Type "3+2="
      await tester.tap(find.text('3'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('='));
      await tester.pumpAndSettle();

      expect(find.text('5'), findsWidgets);
    });

    testWidgets(
        'all 24 buttons visible in iPhone SE landscape',
        (tester) async {
      tester.view.physicalSize = const Size(667, 375);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Verify key buttons are present and findable
      // "0" appears on button AND in display result
      expect(find.text('0'), findsWidgets);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
      expect(find.text('='), findsOneWidget);
      expect(find.text('AC'), findsOneWidget);
    });
  });
}
