import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AccessibilityRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await AccessibilityRepository.create();
  });

  group('AccessibilityCubit', () {
    group('initial state', () {
      test('defaults to reduceMotion: false, hapticFeedback: true, soundFeedback: false', () async {
        final cubit = AccessibilityCubit(repository: repository);

        expect(cubit.state.reduceMotion, isFalse);
        expect(cubit.state.hapticFeedback, isTrue);
        expect(cubit.state.soundFeedback, isFalse);

        await cubit.close();
      });

      test('loads saved preferences from repository', () async {
        SharedPreferences.setMockInitialValues({
          'reduce_motion': true,
          'haptic_feedback': false,
          'sound_feedback': true,
        });
        repository = await AccessibilityRepository.create();

        final cubit = AccessibilityCubit(repository: repository);

        expect(cubit.state.reduceMotion, isTrue);
        expect(cubit.state.hapticFeedback, isFalse);
        expect(cubit.state.soundFeedback, isTrue);

        await cubit.close();
      });
    });

    group('setReduceMotion', () {
      blocTest<AccessibilityCubit, AccessibilityState>(
        'emits state with reduceMotion: true when setReduceMotion(true) called',
        build: () => AccessibilityCubit(repository: repository),
        act: (cubit) => cubit.setReduceMotion(value: true),
        expect: () => [
          const AccessibilityState(
            reduceMotion: true,
            hapticFeedback: true,
            soundFeedback: false,
          ),
        ],
      );

      blocTest<AccessibilityCubit, AccessibilityState>(
        'does not emit when same value is set',
        build: () => AccessibilityCubit(repository: repository),
        act: (cubit) => cubit.setReduceMotion(value: false),
        expect: () => <AccessibilityState>[],
      );

      test('persists reduce motion to repository', () async {
        final cubit = AccessibilityCubit(repository: repository);
        await cubit.setReduceMotion(value: true);

        final loaded = repository.loadReduceMotion();
        expect(loaded, isTrue);

        await cubit.close();
      });
    });

    group('setHapticFeedback', () {
      blocTest<AccessibilityCubit, AccessibilityState>(
        'emits state with hapticFeedback: false when setHapticFeedback(false) called',
        build: () => AccessibilityCubit(repository: repository),
        act: (cubit) => cubit.setHapticFeedback(value: false),
        expect: () => [
          const AccessibilityState(
            reduceMotion: false,
            hapticFeedback: false,
            soundFeedback: false,
          ),
        ],
      );

      blocTest<AccessibilityCubit, AccessibilityState>(
        'does not emit when same value is set',
        build: () => AccessibilityCubit(repository: repository),
        act: (cubit) => cubit.setHapticFeedback(value: true),
        expect: () => <AccessibilityState>[],
      );

      test('persists haptic feedback to repository', () async {
        final cubit = AccessibilityCubit(repository: repository);
        await cubit.setHapticFeedback(value: false);

        final loaded = repository.loadHapticFeedback();
        expect(loaded, isFalse);

        await cubit.close();
      });
    });

    group('setSoundFeedback', () {
      blocTest<AccessibilityCubit, AccessibilityState>(
        'emits state with soundFeedback: true when setSoundFeedback(true) called',
        build: () => AccessibilityCubit(repository: repository),
        act: (cubit) => cubit.setSoundFeedback(value: true),
        expect: () => [
          const AccessibilityState(
            reduceMotion: false,
            hapticFeedback: true,
            soundFeedback: true,
          ),
        ],
      );

      blocTest<AccessibilityCubit, AccessibilityState>(
        'does not emit when same value is set',
        build: () => AccessibilityCubit(repository: repository),
        act: (cubit) => cubit.setSoundFeedback(value: false),
        expect: () => <AccessibilityState>[],
      );

      test('persists sound feedback to repository', () async {
        final cubit = AccessibilityCubit(repository: repository);
        await cubit.setSoundFeedback(value: true);

        final loaded = repository.loadSoundFeedback();
        expect(loaded, isTrue);

        await cubit.close();
      });
    });

    group('AccessibilityState', () {
      test('supports value equality', () {
        const state1 = AccessibilityState(
          reduceMotion: true,
          hapticFeedback: false,
          soundFeedback: true,
        );
        const state2 = AccessibilityState(
          reduceMotion: true,
          hapticFeedback: false,
          soundFeedback: true,
        );
        const state3 = AccessibilityState(
          reduceMotion: false,
          hapticFeedback: false,
          soundFeedback: true,
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('copyWith creates new instance with updated values', () {
        const state = AccessibilityState();

        final updated1 = state.copyWith(reduceMotion: true);
        expect(updated1.reduceMotion, isTrue);
        expect(updated1.hapticFeedback, isTrue);
        expect(updated1.soundFeedback, isFalse);

        final updated2 = state.copyWith(hapticFeedback: false);
        expect(updated2.reduceMotion, isFalse);
        expect(updated2.hapticFeedback, isFalse);
        expect(updated2.soundFeedback, isFalse);

        final updated3 = state.copyWith(soundFeedback: true);
        expect(updated3.reduceMotion, isFalse);
        expect(updated3.hapticFeedback, isTrue);
        expect(updated3.soundFeedback, isTrue);
      });

      test('copyWith preserves values when not specified', () {
        const state = AccessibilityState(
          reduceMotion: true,
          hapticFeedback: false,
          soundFeedback: true,
        );

        final copied = state.copyWith();
        expect(copied.reduceMotion, isTrue);
        expect(copied.hapticFeedback, isFalse);
        expect(copied.soundFeedback, isTrue);
      });
    });
  });
}
