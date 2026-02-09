import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/onboarding/data/onboarding_repository.dart';
import 'package:math_mate/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OnboardingRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await OnboardingRepository.create();
  });

  group('initial state', () {
    test('has hasCompleted false and currentPage 0 by default', () {
      final cubit = OnboardingCubit(repository: repository);
      expect(cubit.state.hasCompleted, isFalse);
      expect(cubit.state.currentPage, 0);
      cubit.close();
    });

    test('loads hasCompleted true from repository', () async {
      await repository.saveCompleted(value: true);
      final cubit = OnboardingCubit(repository: repository);
      expect(cubit.state.hasCompleted, isTrue);
      cubit.close();
    });
  });

  group('completeOnboarding', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'emits hasCompleted true and persists',
      build: () => OnboardingCubit(repository: repository),
      act: (cubit) => cubit.completeOnboarding(),
      expect: () => [
        const OnboardingState(hasCompleted: true, currentPage: 0),
      ],
      verify: (_) {
        expect(repository.loadCompleted(), isTrue);
      },
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'does not emit if already completed',
      build: () => OnboardingCubit(repository: repository),
      seed: () => const OnboardingState(hasCompleted: true, currentPage: 0),
      act: (cubit) => cubit.completeOnboarding(),
      expect: () => <OnboardingState>[],
    );
  });

  group('setPage', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'emits updated currentPage',
      build: () => OnboardingCubit(repository: repository),
      act: (cubit) => cubit.setPage(2),
      expect: () => [
        const OnboardingState(hasCompleted: false, currentPage: 2),
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'does not emit if page is same',
      build: () => OnboardingCubit(repository: repository),
      act: (cubit) => cubit.setPage(0),
      expect: () => <OnboardingState>[],
    );
  });

  group('resetPage', () {
    blocTest<OnboardingCubit, OnboardingState>(
      'resets currentPage to 0',
      build: () => OnboardingCubit(repository: repository),
      seed: () => const OnboardingState(hasCompleted: true, currentPage: 3),
      act: (cubit) => cubit.resetPage(),
      expect: () => [
        const OnboardingState(hasCompleted: true, currentPage: 0),
      ],
    );

    blocTest<OnboardingCubit, OnboardingState>(
      'does not emit if already on page 0',
      build: () => OnboardingCubit(repository: repository),
      act: (cubit) => cubit.resetPage(),
      expect: () => <OnboardingState>[],
    );
  });

  group('OnboardingState', () {
    test('supports equality', () {
      const state1 = OnboardingState(hasCompleted: false, currentPage: 0);
      const state2 = OnboardingState(hasCompleted: false, currentPage: 0);
      expect(state1, equals(state2));
    });

    test('different hasCompleted are not equal', () {
      const state1 = OnboardingState(hasCompleted: false, currentPage: 0);
      const state2 = OnboardingState(hasCompleted: true, currentPage: 0);
      expect(state1, isNot(equals(state2)));
    });

    test('copyWith creates new instance with updated values', () {
      const state = OnboardingState(hasCompleted: false, currentPage: 0);
      final updated = state.copyWith(hasCompleted: true, currentPage: 2);
      expect(updated.hasCompleted, isTrue);
      expect(updated.currentPage, 2);
    });
  });
}
