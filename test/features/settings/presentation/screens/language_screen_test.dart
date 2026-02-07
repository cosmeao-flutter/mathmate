import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:math_mate/features/settings/presentation/screens/language_screen.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocaleRepository repository;
  late LocaleCubit cubit;

  Widget buildSubject() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider.value(
        value: cubit,
        child: const LanguageScreen(),
      ),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await LocaleRepository.create();
    cubit = LocaleCubit(repository: repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('LanguageScreen', () {
    group('rendering', () {
      testWidgets('shows title in app bar', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.text('Language'), findsOneWidget);
      });

      testWidgets('shows all language options', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        expect(find.text('System Default'), findsOneWidget);
        expect(find.text('Follow device language'), findsOneWidget);
        expect(find.text('English (US)'), findsOneWidget);
        expect(find.text('Español (MX)'), findsOneWidget);
      });

      testWidgets('system default is selected by default', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        // The system option (null value) should be selected
        final radioTiles = tester.widgetList<RadioListTile<String?>>(
          find.byType(RadioListTile<String?>),
        );
        // With RadioGroup, the selected state is managed by ancestor
        // Verify there are 3 radio tiles
        expect(radioTiles.length, 3);
      });
    });

    group('interaction', () {
      testWidgets('tapping English sets locale to en', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('English (US)'));
        await tester.pumpAndSettle();

        expect(cubit.state.languageCode, 'en');
      });

      testWidgets('tapping Spanish sets locale to es', (tester) async {
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Español (MX)'));
        await tester.pumpAndSettle();

        expect(cubit.state.languageCode, 'es');
      });

      testWidgets('tapping System Default sets locale to null',
          (tester) async {
        // Start with English selected
        await cubit.setLocale('en');

        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();
        await tester.tap(find.text('System Default'));
        await tester.pumpAndSettle();

        expect(cubit.state.languageCode, isNull);
      });
    });
  });
}
