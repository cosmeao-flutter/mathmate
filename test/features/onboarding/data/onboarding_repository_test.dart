import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/features/onboarding/data/onboarding_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late OnboardingRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await OnboardingRepository.create();
  });

  group('create', () {
    test('creates a repository instance', () {
      expect(repository, isNotNull);
    });
  });

  group('saveCompleted', () {
    test('saves true', () async {
      await repository.saveCompleted(value: true);
      expect(repository.loadCompleted(), isTrue);
    });

    test('saves false', () async {
      await repository.saveCompleted(value: true);
      await repository.saveCompleted(value: false);
      expect(repository.loadCompleted(), isFalse);
    });
  });

  group('loadCompleted', () {
    test('returns false when nothing is saved (default)', () {
      expect(repository.loadCompleted(), isFalse);
    });

    test('returns true after saving true', () async {
      await repository.saveCompleted(value: true);
      expect(repository.loadCompleted(), isTrue);
    });

    test('returns false after saving false', () async {
      await repository.saveCompleted(value: true);
      await repository.saveCompleted(value: false);
      expect(repository.loadCompleted(), isFalse);
    });
  });

  group('persistence', () {
    test('persists completed status across repository instances', () async {
      await repository.saveCompleted(value: true);

      final newRepository = await OnboardingRepository.create();
      expect(newRepository.loadCompleted(), isTrue);
    });
  });

  group('error handling', () {
    late MockSharedPreferences mockPrefs;
    late MockAppLogger mockLogger;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockLogger = MockAppLogger();
    });

    test('saveCompleted logs error when setBool throws', () async {
      when(() => mockPrefs.setBool(any(), any()))
          .thenThrow(Exception('disk full'));
      when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

      final repo = OnboardingRepository.forTesting(
        mockPrefs,
        logger: mockLogger,
      );

      await repo.saveCompleted(value: true);

      verify(() => mockLogger.error(any(), any(), any())).called(1);
    });
  });
}
