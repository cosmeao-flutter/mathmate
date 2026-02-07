import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:math_mate/features/currency/domain/currency_constants.dart';

/// Exception thrown when a currency API call fails.
class CurrencyServiceException implements Exception {
  const CurrencyServiceException(this.message);

  /// Human-readable error description.
  final String message;

  @override
  String toString() => 'CurrencyServiceException: $message';
}

/// Exchange rate data returned by the Frankfurter API.
class ExchangeRates {
  const ExchangeRates({
    required this.base,
    required this.date,
    required this.rates,
  });

  /// The base currency code (e.g. "USD").
  final String base;

  /// The date these rates apply to (ISO 8601, e.g. "2026-02-06").
  final String date;

  /// Map of currency code to exchange rate relative to [base].
  final Map<String, double> rates;
}

/// HTTP client for the Frankfurter currency exchange API.
///
/// Fetches available currencies and latest exchange rates.
/// Accepts an injectable [http.Client] for testing.
class CurrencyService {
  CurrencyService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  /// Fetches available currencies from the API.
  ///
  /// Returns a map of currency codes to display names.
  /// Throws [CurrencyServiceException] on failure.
  Future<Map<String, String>> fetchCurrencies() async {
    try {
      final uri = Uri.parse(
        '${CurrencyConstants.apiBaseUrl}/currencies',
      );
      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw CurrencyServiceException(
          'Failed to fetch currencies: ${response.statusCode}',
        );
      }

      final decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      return decoded
          .map((key, value) => MapEntry(key, value as String));
    } on CurrencyServiceException {
      rethrow;
    } on SocketException catch (e) {
      throw CurrencyServiceException(
        'Network error: ${e.message}',
      );
    } catch (e) {
      throw CurrencyServiceException(
        'Failed to parse currencies: $e',
      );
    }
  }

  /// Fetches latest exchange rates for [base] currency.
  ///
  /// Returns [ExchangeRates] with rates for all other currencies.
  /// Throws [CurrencyServiceException] on failure.
  Future<ExchangeRates> fetchRates({required String base}) async {
    try {
      final uri = Uri.parse(
        '${CurrencyConstants.apiBaseUrl}/latest?base=$base',
      );
      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw CurrencyServiceException(
          'Failed to fetch rates: ${response.statusCode}',
        );
      }

      final decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      final ratesMap =
          decoded['rates'] as Map<String, dynamic>;

      return ExchangeRates(
        base: decoded['base'] as String,
        date: decoded['date'] as String,
        rates: ratesMap.map(
          (key, value) =>
              MapEntry(key, (value as num).toDouble()),
        ),
      );
    } on CurrencyServiceException {
      rethrow;
    } on SocketException catch (e) {
      throw CurrencyServiceException(
        'Network error: ${e.message}',
      );
    } catch (e) {
      throw CurrencyServiceException(
        'Failed to parse rates: $e',
      );
    }
  }
}
