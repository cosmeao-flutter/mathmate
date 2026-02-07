import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/reminder/data/notification_service.dart';
import 'package:math_mate/features/reminder/data/reminder_repository.dart';
import 'package:math_mate/features/reminder/presentation/cubit/reminder_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late ReminderRepository repository;
  late MockNotificationService mockService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ReminderRepository.create();
    mockService = MockNotificationService();

    // Default stubs
    when(() => mockService.requestPermission())
        .thenAnswer((_) async => true);
    when(
      () => mockService.scheduleDailyReminder(
        hour: any(named: 'hour'),
        minute: any(named: 'minute'),
      ),
    ).thenAnswer((_) async {});
    when(() => mockService.cancelReminder()).thenAnswer((_) async {});
  });

  group('ReminderCubit', () {
    group('initial state', () {
      test('defaults to disabled at 16:00', () async {
        final cubit = ReminderCubit(
          repository: repository,
          notificationService: mockService,
        );

        expect(cubit.state.isEnabled, isFalse);
        expect(cubit.state.hour, 16);
        expect(cubit.state.minute, 0);

        await cubit.close();
      });

      test('loads saved preferences from repository', () async {
        SharedPreferences.setMockInitialValues({
          'reminder_enabled': true,
          'reminder_hour': 9,
          'reminder_minute': 30,
        });
        repository = await ReminderRepository.create();

        final cubit = ReminderCubit(
          repository: repository,
          notificationService: mockService,
        );

        expect(cubit.state.isEnabled, isTrue);
        expect(cubit.state.hour, 9);
        expect(cubit.state.minute, 30);

        await cubit.close();
      });
    });

    group('setReminderEnabled', () {
      blocTest<ReminderCubit, ReminderState>(
        'emits enabled state and schedules notification when permission granted',
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) => cubit.setReminderEnabled(value: true),
        expect: () => [
          const ReminderState(isEnabled: true, hour: 16, minute: 0),
        ],
        verify: (_) {
          verify(() => mockService.requestPermission()).called(1);
          verify(
            () => mockService.scheduleDailyReminder(hour: 16, minute: 0),
          ).called(1);
        },
      );

      blocTest<ReminderCubit, ReminderState>(
        'does not enable when permission denied',
        build: () {
          when(() => mockService.requestPermission())
              .thenAnswer((_) async => false);
          return ReminderCubit(
            repository: repository,
            notificationService: mockService,
          );
        },
        act: (cubit) => cubit.setReminderEnabled(value: true),
        expect: () => <ReminderState>[],
        verify: (_) {
          verify(() => mockService.requestPermission()).called(1);
          verifyNever(
            () => mockService.scheduleDailyReminder(
              hour: any(named: 'hour'),
              minute: any(named: 'minute'),
            ),
          );
        },
      );

      blocTest<ReminderCubit, ReminderState>(
        'emits disabled state and cancels notification when disabling',
        seed: () => const ReminderState(isEnabled: true, hour: 16, minute: 0),
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) => cubit.setReminderEnabled(value: false),
        expect: () => [
          const ReminderState(isEnabled: false, hour: 16, minute: 0),
        ],
        verify: (_) {
          verify(() => mockService.cancelReminder()).called(1);
          verifyNever(() => mockService.requestPermission());
        },
      );

      blocTest<ReminderCubit, ReminderState>(
        'does not emit when same value is set',
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) => cubit.setReminderEnabled(value: false),
        expect: () => <ReminderState>[],
      );

      test('persists enabled to repository', () async {
        final cubit = ReminderCubit(
          repository: repository,
          notificationService: mockService,
        );
        await cubit.setReminderEnabled(value: true);

        final loaded = repository.loadReminderEnabled();
        expect(loaded, isTrue);

        await cubit.close();
      });
    });

    group('setReminderTime', () {
      blocTest<ReminderCubit, ReminderState>(
        'emits state with new time',
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) =>
            cubit.setReminderTime(const TimeOfDay(hour: 9, minute: 30)),
        expect: () => [
          const ReminderState(isEnabled: false, hour: 9, minute: 30),
        ],
      );

      blocTest<ReminderCubit, ReminderState>(
        'reschedules notification when enabled',
        seed: () => const ReminderState(isEnabled: true, hour: 16, minute: 0),
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) =>
            cubit.setReminderTime(const TimeOfDay(hour: 8, minute: 15)),
        expect: () => [
          const ReminderState(isEnabled: true, hour: 8, minute: 15),
        ],
        verify: (_) {
          verify(
            () => mockService.scheduleDailyReminder(hour: 8, minute: 15),
          ).called(1);
        },
      );

      blocTest<ReminderCubit, ReminderState>(
        'does not schedule when disabled',
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) =>
            cubit.setReminderTime(const TimeOfDay(hour: 10, minute: 0)),
        expect: () => [
          const ReminderState(isEnabled: false, hour: 10, minute: 0),
        ],
        verify: (_) {
          verifyNever(
            () => mockService.scheduleDailyReminder(
              hour: any(named: 'hour'),
              minute: any(named: 'minute'),
            ),
          );
        },
      );

      blocTest<ReminderCubit, ReminderState>(
        'does not emit when same time is set',
        build: () => ReminderCubit(
          repository: repository,
          notificationService: mockService,
        ),
        act: (cubit) =>
            cubit.setReminderTime(const TimeOfDay(hour: 16, minute: 0)),
        expect: () => <ReminderState>[],
      );

      test('persists time to repository', () async {
        final cubit = ReminderCubit(
          repository: repository,
          notificationService: mockService,
        );
        await cubit.setReminderTime(const TimeOfDay(hour: 7, minute: 45));

        expect(repository.loadReminderHour(), 7);
        expect(repository.loadReminderMinute(), 45);

        await cubit.close();
      });
    });

    group('ReminderState', () {
      test('supports value equality', () {
        const state1 = ReminderState(isEnabled: true, hour: 9, minute: 30);
        const state2 = ReminderState(isEnabled: true, hour: 9, minute: 30);
        const state3 = ReminderState(isEnabled: false, hour: 9, minute: 30);

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('timeOfDay returns correct TimeOfDay', () {
        const state = ReminderState(isEnabled: false, hour: 14, minute: 30);

        expect(state.timeOfDay, const TimeOfDay(hour: 14, minute: 30));
      });

      test('copyWith creates new instance with updated values', () {
        const state = ReminderState(isEnabled: false, hour: 16, minute: 0);

        final updated = state.copyWith(isEnabled: true);
        expect(updated.isEnabled, isTrue);
        expect(updated.hour, 16);
        expect(updated.minute, 0);

        final updated2 = state.copyWith(hour: 8, minute: 30);
        expect(updated2.isEnabled, isFalse);
        expect(updated2.hour, 8);
        expect(updated2.minute, 30);
      });

      test('copyWith preserves values when not specified', () {
        const state = ReminderState(isEnabled: true, hour: 9, minute: 45);

        final copied = state.copyWith();
        expect(copied.isEnabled, isTrue);
        expect(copied.hour, 9);
        expect(copied.minute, 45);
      });
    });
  });
}
