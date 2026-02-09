import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/onboarding/data/onboarding_repository.dart';
import 'package:math_mate/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:math_mate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OnboardingRepository onboardingRepository;
  late OnboardingCubit onboardingCubit;
  late AccessibilityRepository accessibilityRepository;
  late AccessibilityCubit accessibilityCubit;

  Widget buildSubject({bool isReplay = false}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: onboardingCubit),
          BlocProvider.value(value: accessibilityCubit),
        ],
        child: OnboardingScreen(isReplay: isReplay),
      ),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    onboardingRepository = await OnboardingRepository.create();
    onboardingCubit = OnboardingCubit(repository: onboardingRepository);
    accessibilityRepository = await AccessibilityRepository.create();
    accessibilityCubit =
        AccessibilityCubit(repository: accessibilityRepository);
  });

  tearDown(() async {
    await onboardingCubit.close();
    await accessibilityCubit.close();
  });

  group('OnboardingScreen', () {
    group('rendering', () {
      testWidgets('shows first page content by default', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.text('Welcome to MathMate'), findsOneWidget);
      });

      testWidgets('shows Skip button on first page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsOneWidget);
      });

      testWidgets('shows Next button on first page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('shows 4 page indicator dots', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // Find the dot containers by their AnimatedContainer type
        final dots = find.byKey(const Key('onboarding_dots'));
        expect(dots, findsOneWidget);
      });
    });

    group('navigation', () {
      testWidgets('swiping left goes to next page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        expect(find.text('History & Clipboard'), findsOneWidget);
      });

      testWidgets('tapping Next goes to next page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();

        expect(find.text('History & Clipboard'), findsOneWidget);
      });

      testWidgets('tapping Skip goes to last page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        expect(find.text('Make It Yours'), findsOneWidget);
      });

      testWidgets('shows Get Started on last page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // Skip to last page
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        expect(find.text('Get Started'), findsOneWidget);
        expect(find.text('Next'), findsNothing);
      });

      testWidgets('Skip is hidden on last page', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsNothing);
      });
    });

    group('completion', () {
      testWidgets('Get Started marks onboarding complete', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // Skip to last page
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        // Tap Get Started
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();

        expect(onboardingCubit.state.hasCompleted, isTrue);
      });

      testWidgets('replay mode does not mark complete', (tester) async {
        await tester.pumpWidget(buildSubject(isReplay: true));
        await tester.pumpAndSettle();

        // Skip to last page
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        // Tap Get Started — in replay mode, should pop without marking complete
        await tester.tap(find.text('Get Started'));
        await tester.pumpAndSettle();

        expect(onboardingCubit.state.hasCompleted, isFalse);
      });
    });

    group('page content', () {
      testWidgets('page 2 shows History & Clipboard', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        expect(find.text('History & Clipboard'), findsOneWidget);
      });

      testWidgets('page 3 shows Currency Converter', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // Swipe twice
        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        expect(find.text('Currency Converter'), findsOneWidget);
      });
    });
  });
}
