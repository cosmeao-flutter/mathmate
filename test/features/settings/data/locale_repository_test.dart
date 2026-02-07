import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
