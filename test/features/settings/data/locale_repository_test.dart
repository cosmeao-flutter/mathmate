import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late LocaleRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await LocaleRepository.create();
  });

  group('create', () {
    test('creates a repository instance', () {
      expect(repository, isNotNull);
    });
  });

  group('saveLocale', () {
    test('saves a language code', () async {
      await repository.saveLocale('es');
      expect(repository.loadLocale(), 'es');
    });

    test('saves null to clear saved locale (system default)', () async {
      await repository.saveLocale('es');
      await repository.saveLocale(null);
      expect(repository.loadLocale(), isNull);
    });

    test('overwrites previously saved locale', () async {
      await repository.saveLocale('es');
      await repository.saveLocale('en');
      expect(repository.loadLocale(), 'en');
    });
  });

  group('loadLocale', () {
    test('returns null when no locale is saved (system default)', () {
      expect(repository.loadLocale(), isNull);
    });

    test('returns saved language code', () async {
      await repository.saveLocale('es');
      expect(repository.loadLocale(), 'es');
    });

    test('returns null after clearing', () async {
      await repository.saveLocale('en');
      await repository.saveLocale(null);
      expect(repository.loadLocale(), isNull);
    });
  });

  group('persistence', () {
    test('persists locale across repository instances', () async {
      await repository.saveLocale('es');

      // Create a new repository instance (simulates app restart)
      final newRepository = await LocaleRepository.create();
      expect(newRepository.loadLocale(), 'es');
    });

    test('persists null (system default) across instances', () async {
      await repository.saveLocale('es');
      await repository.saveLocale(null);

      final newRepository = await LocaleRepository.create();
      expect(newRepository.loadLocale(), isNull);
    });
  });

  group('error handling', () {
    late MockSharedPreferences mockPrefs;
    late MockAppLogger mockLogger;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      mockLogger = MockAppLogger();
    });

    test('saveLocale logs error when setString throws', () async {
      when(() => mockPrefs.setString(any(), any()))
          .thenThrow(Exception('disk full'));
      when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

      final repo = LocaleRepository.forTesting(
        mockPrefs,
        logger: mockLogger,
      );

      await repo.saveLocale('es');

      verify(() => mockLogger.error(any(), any(), any())).called(1);
    });

    test('saveLocale logs error when remove throws (null case)', () async {
      when(() => mockPrefs.remove(any()))
          .thenThrow(Exception('disk full'));
      when(() => mockLogger.error(any(), any(), any())).thenReturn(null);

      final repo = LocaleRepository.forTesting(
        mockPrefs,
        logger: mockLogger,
      );

      await repo.saveLocale(null);

      verify(() => mockLogger.error(any(), any(), any())).called(1);
    });
  });
}
