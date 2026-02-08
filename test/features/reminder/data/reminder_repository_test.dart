import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/features/reminder/data/reminder_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late ReminderRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await ReminderRepository.create();
  });

  group('ReminderRepository', () {
    group('saveReminderEnabled', () {
      test('saves true value', () async {
        await repository.saveReminderEnabled(value: true);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('reminder_enabled'), isTrue);
      });

      test('saves false value', () async {
        await repository.saveReminderEnabled(value: false);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getBool('reminder_enabled'), isFalse);
      });
    });

    group('loadReminderEnabled', () {
      test('returns false when nothing saved (default)', () {
        final value = repository.loadReminderEnabled();
        expect(value, isFalse);
      });

      test('returns true when true saved', () async {
        SharedPreferences.setMockInitialValues({'reminder_enabled': true});
        repository = await ReminderRepository.create();

        final value = repository.loadReminderEnabled();
        expect(value, isTrue);
      });

      test('returns false when false saved', () async {
        SharedPreferences.setMockInitialValues({'reminder_enabled': false});
        repository = await ReminderRepository.create();

        final value = repository.loadReminderEnabled();
        expect(value, isFalse);
      });
    });

    group('saveReminderHour', () {
      test('saves hour value', () async {
        await repository.saveReminderHour(value: 16);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('reminder_hour'), 16);
      });

      test('saves midnight (0)', () async {
        await repository.saveReminderHour(value: 0);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('reminder_hour'), 0);
      });
    });

    group('loadReminderHour', () {
      test('returns 16 when nothing saved (default 4:00 PM)', () {
        final value = repository.loadReminderHour();
        expect(value, 16);
      });

      test('returns saved hour', () async {
        SharedPreferences.setMockInitialValues({'reminder_hour': 9});
        repository = await ReminderRepository.create();

        final value = repository.loadReminderHour();
        expect(value, 9);
      });

      test('returns 0 for midnight', () async {
        SharedPreferences.setMockInitialValues({'reminder_hour': 0});
        repository = await ReminderRepository.create();

        final value = repository.loadReminderHour();
        expect(value, 0);
      });
    });

    group('saveReminderMinute', () {
      test('saves minute value', () async {
        await repository.saveReminderMinute(value: 30);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('reminder_minute'), 30);
      });

      test('saves zero minutes', () async {
        await repository.saveReminderMinute(value: 0);

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getInt('reminder_minute'), 0);
      });
    });

    group('loadReminderMinute', () {
      test('returns 0 when nothing saved (default)', () {
        final value = repository.loadReminderMinute();
        expect(value, 0);
      });

      test('returns saved minute', () async {
        SharedPreferences.setMockInitialValues({'reminder_minute': 45});
        repository = await ReminderRepository.create();

        final value = repository.loadReminderMinute();
        expect(value, 45);
      });
    });

    group('persistence roundtrip', () {
      test('saves and loads enabled correctly', () async {
        await repository.saveReminderEnabled(value: true);
        final value = repository.loadReminderEnabled();
        expect(value, isTrue);
      });

      test('saves and loads hour correctly', () async {
        await repository.saveReminderHour(value: 8);
        final value = repository.loadReminderHour();
        expect(value, 8);
      });

      test('saves and loads minute correctly', () async {
        await repository.saveReminderMinute(value: 15);
        final value = repository.loadReminderMinute();
        expect(value, 15);
      });

      test('saves and loads all settings independently', () async {
        await repository.saveReminderEnabled(value: true);
        await repository.saveReminderHour(value: 9);
        await repository.saveReminderMinute(value: 30);

        final enabled = repository.loadReminderEnabled();
        final hour = repository.loadReminderHour();
        final minute = repository.loadReminderMinute();

        expect(enabled, isTrue);
        expect(hour, 9);
        expect(minute, 30);
      });
    });

    group('error handling', () {
      late MockSharedPreferences mockPrefs;
      late MockAppLogger mockLogger;

      setUp(() {
        mockPrefs = MockSharedPreferences();
        mockLogger = MockAppLogger();
      });

      test('saveReminderEnabled logs error when SharedPreferences throws',
          () async {
        when(() => mockPrefs.setBool(any(), any()))
            .thenThrow(Exception('disk full'));
        when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

        final repo = ReminderRepository.forTesting(
          mockPrefs,
          logger: mockLogger,
        );

        await repo.saveReminderEnabled(value: true);

        verify(() => mockLogger.error(any(), any(), any())).called(1);
      });

      test('saveReminderHour logs error when SharedPreferences throws',
          () async {
        when(() => mockPrefs.setInt(any(), any()))
            .thenThrow(Exception('disk full'));
        when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

        final repo = ReminderRepository.forTesting(
          mockPrefs,
          logger: mockLogger,
        );

        await repo.saveReminderHour(value: 10);

        verify(() => mockLogger.error(any(), any(), any())).called(1);
      });

      test('saveReminderMinute logs error when SharedPreferences throws',
          () async {
        when(() => mockPrefs.setInt(any(), any()))
            .thenThrow(Exception('disk full'));
        when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

        final repo = ReminderRepository.forTesting(
          mockPrefs,
          logger: mockLogger,
        );

        await repo.saveReminderMinute(value: 30);

        verify(() => mockLogger.error(any(), any(), any())).called(1);
      });
    });
  });
}
