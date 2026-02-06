import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ThemeRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ThemeRepository.create();
  });

  group('ThemeCubit', () {
    group('initial state', () {
      test('defaults to system mode and blue accent', () async {
        final cubit = ThemeCubit(repository: repository);

        expect(cubit.state.themeMode, equals(ThemeMode.system));
        expect(cubit.state.accentColor, equals(AccentColor.blue));

        await cubit.close();
      });

      test('loads saved preferences from repository', () async {
        SharedPreferences.setMockInitialValues({
          'theme_mode': 'dark',
          'accent_color': 'purple',
        });
        repository = await ThemeRepository.create();

        final cubit = ThemeCubit(repository: repository);

        expect(cubit.state.themeMode, equals(ThemeMode.dark));
        expect(cubit.state.accentColor, equals(AccentColor.purple));

        await cubit.close();
      });
    });

    group('setThemeMode', () {
      blocTest<ThemeCubit, ThemeState>(
        'emits state with light mode when setThemeMode(light) called',
        build: () => ThemeCubit(repository: repository),
        act: (cubit) => cubit.setThemeMode(ThemeMode.light),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.light,
            accentColor: AccentColor.blue,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'emits state with dark mode when setThemeMode(dark) called',
        build: () => ThemeCubit(repository: repository),
        act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.dark,
            accentColor: AccentColor.blue,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'emits state with system mode when setThemeMode(system) called',
        build: () => ThemeCubit(repository: repository),
        seed: () => const ThemeState(
          themeMode: ThemeMode.dark,
          accentColor: AccentColor.blue,
        ),
        act: (cubit) => cubit.setThemeMode(ThemeMode.system),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.system,
            accentColor: AccentColor.blue,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'does not emit when same mode is set',
        build: () => ThemeCubit(repository: repository),
        act: (cubit) => cubit.setThemeMode(ThemeMode.system),
        expect: () => <ThemeState>[],
      );

      test('persists theme mode to repository', () async {
        final cubit = ThemeCubit(repository: repository);
        await cubit.setThemeMode(ThemeMode.dark);

        final loadedMode = repository.loadThemeMode();
        expect(loadedMode, equals(ThemeMode.dark));

        await cubit.close();
      });
    });

    group('setAccentColor', () {
      blocTest<ThemeCubit, ThemeState>(
        'emits state with green accent when setAccentColor(green) called',
        build: () => ThemeCubit(repository: repository),
        act: (cubit) => cubit.setAccentColor(AccentColor.green),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.system,
            accentColor: AccentColor.green,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'emits state with purple accent when setAccentColor(purple) called',
        build: () => ThemeCubit(repository: repository),
        act: (cubit) => cubit.setAccentColor(AccentColor.purple),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.system,
            accentColor: AccentColor.purple,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'preserves theme mode when changing accent color',
        build: () => ThemeCubit(repository: repository),
        seed: () => const ThemeState(
          themeMode: ThemeMode.dark,
          accentColor: AccentColor.blue,
        ),
        act: (cubit) => cubit.setAccentColor(AccentColor.teal),
        expect: () => [
          const ThemeState(
            themeMode: ThemeMode.dark,
            accentColor: AccentColor.teal,
          ),
        ],
      );

      blocTest<ThemeCubit, ThemeState>(
        'does not emit when same color is set',
        build: () => ThemeCubit(repository: repository),
        act: (cubit) => cubit.setAccentColor(AccentColor.blue),
        expect: () => <ThemeState>[],
      );

      test('persists accent color to repository', () async {
        final cubit = ThemeCubit(repository: repository);
        await cubit.setAccentColor(AccentColor.orange);

        final loadedColor = repository.loadAccentColor();
        expect(loadedColor, equals(AccentColor.orange));

        await cubit.close();
      });
    });

    group('ThemeState', () {
      test('supports value equality', () {
        const state1 = ThemeState(
          themeMode: ThemeMode.dark,
          accentColor: AccentColor.purple,
        );
        const state2 = ThemeState(
          themeMode: ThemeMode.dark,
          accentColor: AccentColor.purple,
        );
        const state3 = ThemeState(
          themeMode: ThemeMode.light,
          accentColor: AccentColor.purple,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('copyWith creates new instance with updated values', () {
        const state = ThemeState(
          themeMode: ThemeMode.system,
          accentColor: AccentColor.blue,
        );

        final updated = state.copyWith(themeMode: ThemeMode.dark);
        expect(updated.themeMode, equals(ThemeMode.dark));
        expect(updated.accentColor, equals(AccentColor.blue));

        final updated2 = state.copyWith(accentColor: AccentColor.green);
        expect(updated2.themeMode, equals(ThemeMode.system));
        expect(updated2.accentColor, equals(AccentColor.green));
      });

      test('copyWith preserves values when not specified', () {
        const state = ThemeState(
          themeMode: ThemeMode.dark,
          accentColor: AccentColor.purple,
        );

        final copied = state.copyWith();
        expect(copied.themeMode, equals(ThemeMode.dark));
        expect(copied.accentColor, equals(AccentColor.purple));
      });
    });
  });
}
