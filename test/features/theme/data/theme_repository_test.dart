import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late ThemeRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ThemeRepository.create();
  });

  group('ThemeRepository', () {
    group('saveThemeMode', () {
      test('saves light mode', () async {
        await repository.saveThemeMode(ThemeMode.light);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), equals('light'));
      });

      test('saves dark mode', () async {
        await repository.saveThemeMode(ThemeMode.dark);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), equals('dark'));
      });

      test('saves system mode', () async {
        await repository.saveThemeMode(ThemeMode.system);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('theme_mode'), equals('system'));
      });
    });

    group('loadThemeMode', () {
      test('returns system when nothing saved', () {
        final mode = repository.loadThemeMode();
        expect(mode, equals(ThemeMode.system));
      });

      test('returns light when light saved', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'light'});
        repository = await ThemeRepository.create();

        final mode = repository.loadThemeMode();
        expect(mode, equals(ThemeMode.light));
      });

      test('returns dark when dark saved', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
        repository = await ThemeRepository.create();

        final mode = repository.loadThemeMode();
        expect(mode, equals(ThemeMode.dark));
      });

      test('returns system when system saved', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'system'});
        repository = await ThemeRepository.create();

        final mode = repository.loadThemeMode();
        expect(mode, equals(ThemeMode.system));
      });

      test('returns system for invalid value', () async {
        SharedPreferences.setMockInitialValues({'theme_mode': 'invalid'});
        repository = await ThemeRepository.create();

        final mode = repository.loadThemeMode();
        expect(mode, equals(ThemeMode.system));
      });
    });

    group('saveAccentColor', () {
      test('saves blue accent', () async {
        await repository.saveAccentColor(AccentColor.blue);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('accent_color'), equals('blue'));
      });

      test('saves green accent', () async {
        await repository.saveAccentColor(AccentColor.green);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('accent_color'), equals('green'));
      });

      test('saves purple accent', () async {
        await repository.saveAccentColor(AccentColor.purple);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('accent_color'), equals('purple'));
      });

      test('saves orange accent', () async {
        await repository.saveAccentColor(AccentColor.orange);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('accent_color'), equals('orange'));
      });

      test('saves teal accent', () async {
        await repository.saveAccentColor(AccentColor.teal);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('accent_color'), equals('teal'));
      });
    });

    group('loadAccentColor', () {
      test('returns blue when nothing saved', () {
        final color = repository.loadAccentColor();
        expect(color, equals(AccentColor.blue));
      });

      test('returns correct color when saved', () async {
        for (final accent in AccentColor.values) {
          SharedPreferences.setMockInitialValues(
            {'accent_color': accent.name},
          );
          repository = await ThemeRepository.create();

          final color = repository.loadAccentColor();
          expect(color, equals(accent));
        }
      });

      test('returns blue for invalid value', () async {
        SharedPreferences.setMockInitialValues({'accent_color': 'invalid'});
        repository = await ThemeRepository.create();

        final color = repository.loadAccentColor();
        expect(color, equals(AccentColor.blue));
      });
    });

    group('persistence roundtrip', () {
      test('saves and loads theme mode correctly', () async {
        await repository.saveThemeMode(ThemeMode.dark);
        final mode = repository.loadThemeMode();
        expect(mode, equals(ThemeMode.dark));
      });

      test('saves and loads accent color correctly', () async {
        await repository.saveAccentColor(AccentColor.purple);
        final color = repository.loadAccentColor();
        expect(color, equals(AccentColor.purple));
      });

      test('saves and loads both settings independently', () async {
        await repository.saveThemeMode(ThemeMode.light);
        await repository.saveAccentColor(AccentColor.teal);

        final mode = repository.loadThemeMode();
        final color = repository.loadAccentColor();

        expect(mode, equals(ThemeMode.light));
        expect(color, equals(AccentColor.teal));
      });
    });

    group('error handling', () {
      late MockSharedPreferences mockPrefs;
      late MockAppLogger mockLogger;

      setUp(() {
        mockPrefs = MockSharedPreferences();
        mockLogger = MockAppLogger();
      });

      test('saveThemeMode logs error when SharedPreferences throws', () async {
        when(() => mockPrefs.setString(any(), any()))
            .thenThrow(Exception('disk full'));
        when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

        final repo = ThemeRepository.forTesting(
          mockPrefs,
          logger: mockLogger,
        );

        await repo.saveThemeMode(ThemeMode.dark);

        verify(() => mockLogger.error(any(), any(), any())).called(1);
      });

      test('saveAccentColor logs error when SharedPreferences throws',
          () async {
        when(() => mockPrefs.setString(any(), any()))
            .thenThrow(Exception('disk full'));
        when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

        final repo = ThemeRepository.forTesting(
          mockPrefs,
          logger: mockLogger,
        );

        await repo.saveAccentColor(AccentColor.purple);

        verify(() => mockLogger.error(any(), any(), any())).called(1);
      });
    });
  });
}
