import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocaleRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await LocaleRepository.create();
  });

  group('Initial State', () {
    test('has null languageCode (system default) when no locale saved', () {
      final cubit = LocaleCubit(repository: repository);
      expect(cubit.state.languageCode, isNull);
      expect(cubit.state.locale, isNull);
      cubit.close();
    });

    test('loads saved locale from repository', () async {
      await repository.saveLocale('es');
      final cubit = LocaleCubit(repository: repository);
      expect(cubit.state.languageCode, 'es');
      expect(cubit.state.locale, const Locale('es'));
      cubit.close();
    });
  });

  group('setLocale', () {
    blocTest<LocaleCubit, LocaleState>(
      'emits state with language code when set to Spanish',
      build: () => LocaleCubit(repository: repository),
      act: (cubit) => cubit.setLocale('es'),
      expect: () => [
        const LocaleState(languageCode: 'es'),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'emits state with null when set to system default',
      setUp: () async => repository.saveLocale('es'),
      build: () => LocaleCubit(repository: repository),
      act: (cubit) => cubit.setLocale(null),
      expect: () => [
        const LocaleState(),
      ],
    );

    blocTest<LocaleCubit, LocaleState>(
      'persists locale to repository',
      build: () => LocaleCubit(repository: repository),
      act: (cubit) => cubit.setLocale('en'),
      verify: (_) {
        expect(repository.loadLocale(), 'en');
      },
    );

    blocTest<LocaleCubit, LocaleState>(
      'does not emit when setting same locale',
      setUp: () async => repository.saveLocale('es'),
      build: () => LocaleCubit(repository: repository),
      act: (cubit) => cubit.setLocale('es'),
      expect: () => <LocaleState>[],
    );
  });

  group('LocaleState', () {
    test('locale returns null when languageCode is null', () {
      const state = LocaleState();
      expect(state.locale, isNull);
    });

    test('locale returns Locale when languageCode is set', () {
      const state = LocaleState(languageCode: 'es');
      expect(state.locale, const Locale('es'));
    });

    test('supports value equality', () {
      const state1 = LocaleState(languageCode: 'es');
      const state2 = LocaleState(languageCode: 'es');
      const state3 = LocaleState(languageCode: 'en');
      expect(state1, state2);
      expect(state1, isNot(state3));
    });

    test('copyWith creates new state with updated values', () {
      const state = LocaleState(languageCode: 'es');
      final updated = state.copyWith(languageCode: 'en');
      expect(updated.languageCode, 'en');
    });

    test('copyWith preserves values when not specified', () {
      const state = LocaleState(languageCode: 'es');
      // copyWith with no args keeps current value
      final updated = state.copyWith();
      expect(updated.languageCode, 'es');
    });
  });
}
