import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:math_mate/features/currency/data/currency_service.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late CurrencyService service;

  setUp(() {
    mockClient = MockHttpClient();
    service = CurrencyService(client: mockClient);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('fetchCurrencies', () {
    const currenciesJson = '{"AUD":"Australian Dollar",'
        ' "EUR":"Euro",'
        ' "USD":"United States Dollar"}';

    test('returns map of currency codes to names on success', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(currenciesJson, 200));

      final result = await service.fetchCurrencies();

      expect(result, {
        'AUD': 'Australian Dollar',
        'EUR': 'Euro',
        'USD': 'United States Dollar',
      });
    });

    test('calls correct API endpoint', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(currenciesJson, 200));

      await service.fetchCurrencies();

      verify(
        () => mockClient.get(
          Uri.parse('https://api.frankfurter.dev/v1/currencies'),
        ),
      ).called(1);
    });

    test('throws CurrencyServiceException on non-200 status', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(
        () => service.fetchCurrencies(),
        throwsA(isA<CurrencyServiceException>()),
      );
    });

    test('throws CurrencyServiceException on network error', () async {
      when(() => mockClient.get(any()))
          .thenThrow(const SocketException('No internet'));

      expect(
        () => service.fetchCurrencies(),
        throwsA(isA<CurrencyServiceException>()),
      );
    });

    test('throws CurrencyServiceException on invalid JSON', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('not json', 200));

      expect(
        () => service.fetchCurrencies(),
        throwsA(isA<CurrencyServiceException>()),
      );
    });
  });

  group('fetchRates', () {
    final ratesResponse = jsonEncode({
      'amount': 1.0,
      'base': 'USD',
      'date': '2026-02-06',
      'rates': {
        'AUD': 1.5234,
        'EUR': 0.8479,
      },
    });

    test('returns ExchangeRates on success', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(ratesResponse, 200));

      final result = await service.fetchRates(base: 'USD');

      expect(result.base, 'USD');
      expect(result.date, '2026-02-06');
      expect(result.rates['AUD'], 1.5234);
      expect(result.rates['EUR'], 0.8479);
    });

    test('calls correct API endpoint with base parameter', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(ratesResponse, 200));

      await service.fetchRates(base: 'EUR');

      verify(
        () => mockClient.get(
          Uri.parse('https://api.frankfurter.dev/v1/latest?base=EUR'),
        ),
      ).called(1);
    });

    test('throws CurrencyServiceException on non-200 status', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Server Error', 500));

      expect(
        () => service.fetchRates(base: 'USD'),
        throwsA(isA<CurrencyServiceException>()),
      );
    });

    test('throws CurrencyServiceException on network error', () async {
      when(() => mockClient.get(any()))
          .thenThrow(const SocketException('No internet'));

      expect(
        () => service.fetchRates(base: 'USD'),
        throwsA(isA<CurrencyServiceException>()),
      );
    });

    test('throws CurrencyServiceException on invalid JSON', () async {
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('bad data', 200));

      expect(
        () => service.fetchRates(base: 'USD'),
        throwsA(isA<CurrencyServiceException>()),
      );
    });

    test('parses rates as doubles correctly', () async {
      final intRatesResponse = jsonEncode({
        'amount': 1,
        'base': 'USD',
        'date': '2026-02-06',
        'rates': {
          'JPY': 157,
          'EUR': 0.85,
        },
      });

      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(intRatesResponse, 200));

      final result = await service.fetchRates(base: 'USD');

      expect(result.rates['JPY'], 157.0);
      expect(result.rates['JPY'], isA<double>());
    });
  });

  group('ExchangeRates', () {
    test('stores base, date, and rates', () {
      const rates = ExchangeRates(
        base: 'EUR',
        date: '2026-02-06',
        rates: {'USD': 1.18, 'GBP': 0.86},
      );

      expect(rates.base, 'EUR');
      expect(rates.date, '2026-02-06');
      expect(rates.rates.length, 2);
    });
  });

  group('CurrencyServiceException', () {
    test('stores message', () {
      const exception = CurrencyServiceException('test error');
      expect(exception.message, 'test error');
    });

    test('toString includes message', () {
      const exception = CurrencyServiceException('test error');
      expect(exception.toString(), contains('test error'));
    });
  });
}
