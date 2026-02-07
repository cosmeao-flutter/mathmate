import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/features/currency/data/currency_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late CurrencyRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await CurrencyRepository.create();
  });

  group('create', () {
    test('creates repository successfully', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = await CurrencyRepository.create();
      expect(repo, isA<CurrencyRepository>());
    });
  });

  group('saveFromCurrency / loadFromCurrency', () {
    test('defaults to USD when not set', () {
      expect(repository.loadFromCurrency(), 'USD');
    });

    test('saves and loads from currency', () async {
      await repository.saveFromCurrency('EUR');
      expect(repository.loadFromCurrency(), 'EUR');
    });

    test('overwrites previous value', () async {
      await repository.saveFromCurrency('EUR');
      await repository.saveFromCurrency('GBP');
      expect(repository.loadFromCurrency(), 'GBP');
    });
  });

  group('saveToCurrency / loadToCurrency', () {
    test('defaults to EUR when not set', () {
      expect(repository.loadToCurrency(), 'EUR');
    });

    test('saves and loads to currency', () async {
      await repository.saveToCurrency('MXN');
      expect(repository.loadToCurrency(), 'MXN');
    });

    test('overwrites previous value', () async {
      await repository.saveToCurrency('MXN');
      await repository.saveToCurrency('JPY');
      expect(repository.loadToCurrency(), 'JPY');
    });
  });

  group('saveCurrencies / loadCurrencies', () {
    test('returns null when not set', () {
      expect(repository.loadCurrencies(), isNull);
    });

    test('saves and loads currency map', () async {
      final currencies = {
        'USD': 'United States Dollar',
        'EUR': 'Euro',
      };
      await repository.saveCurrencies(currencies);

      final loaded = repository.loadCurrencies();
      expect(loaded, currencies);
    });

    test('overwrites previous currencies', () async {
      await repository.saveCurrencies({'USD': 'Dollar'});
      await repository.saveCurrencies({'EUR': 'Euro'});

      final loaded = repository.loadCurrencies();
      expect(loaded, {'EUR': 'Euro'});
    });
  });

  group('saveRates / loadRates', () {
    test('returns null when not set', () {
      expect(repository.loadRates('USD'), isNull);
    });

    test('saves and loads rates for a base currency', () async {
      final rates = {'EUR': 0.85, 'GBP': 0.73};
      await repository.saveRates('USD', rates);

      final loaded = repository.loadRates('USD');
      expect(loaded, rates);
    });

    test('stores rates per base currency', () async {
      await repository.saveRates(
        'USD',
        {'EUR': 0.85},
      );
      await repository.saveRates(
        'EUR',
        {'USD': 1.18},
      );

      expect(repository.loadRates('USD'), {'EUR': 0.85});
      expect(repository.loadRates('EUR'), {'USD': 1.18});
    });

    test('returns null for unsaved base currency', () {
      expect(repository.loadRates('GBP'), isNull);
    });
  });

  group('saveRateDate / loadRateDate', () {
    test('returns null when not set', () {
      expect(repository.loadRateDate('USD'), isNull);
    });

    test('saves and loads rate date', () async {
      await repository.saveRateDate('USD', '2026-02-06');
      expect(repository.loadRateDate('USD'), '2026-02-06');
    });
  });

  group('isCacheFresh', () {
    test('returns false when no timestamp saved', () {
      expect(repository.isCacheFresh('USD'), isFalse);
    });

    test('returns true when cache is within max age', () async {
      await repository.saveCacheTimestamp('USD');

      expect(repository.isCacheFresh('USD'), isTrue);
    });

    test('returns false when cache exceeds max age', () async {
      // Save a timestamp that is 2 hours old
      final oldTimestamp = DateTime.now()
          .subtract(const Duration(hours: 2))
          .millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        'currency_cache_timestamp_USD': oldTimestamp,
      });
      repository = await CurrencyRepository.create();

      expect(repository.isCacheFresh('USD'), isFalse);
    });
  });

  group('persistence roundtrip', () {
    test('full save and reload cycle', () async {
      await repository.saveFromCurrency('GBP');
      await repository.saveToCurrency('JPY');
      await repository.saveCurrencies({
        'GBP': 'British Pound',
        'JPY': 'Japanese Yen',
      });
      await repository.saveRates('GBP', {'JPY': 191.5});
      await repository.saveRateDate('GBP', '2026-02-06');
      await repository.saveCacheTimestamp('GBP');

      expect(repository.loadFromCurrency(), 'GBP');
      expect(repository.loadToCurrency(), 'JPY');
      expect(
        repository.loadCurrencies(),
        {'GBP': 'British Pound', 'JPY': 'Japanese Yen'},
      );
      expect(repository.loadRates('GBP'), {'JPY': 191.5});
      expect(repository.loadRateDate('GBP'), '2026-02-06');
      expect(repository.isCacheFresh('GBP'), isTrue);
    });
  });

  group('edge cases', () {
    test('loads from pre-populated SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'currency_from': 'MXN',
        'currency_to': 'CAD',
        'currency_currencies': jsonEncode({
          'MXN': 'Mexican Peso',
          'CAD': 'Canadian Dollar',
        }),
      });
      repository = await CurrencyRepository.create();

      expect(repository.loadFromCurrency(), 'MXN');
      expect(repository.loadToCurrency(), 'CAD');
      expect(
        repository.loadCurrencies(),
        {'MXN': 'Mexican Peso', 'CAD': 'Canadian Dollar'},
      );
    });

    test('handles empty rates map', () async {
      await repository.saveRates('USD', <String, double>{});
      expect(repository.loadRates('USD'), <String, double>{});
    });
  });
}
