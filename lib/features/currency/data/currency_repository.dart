import 'dart:convert';

import 'package:math_mate/features/currency/domain/currency_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StorageKeys {
  static const String fromCurrency = 'currency_from';
  static const String toCurrency = 'currency_to';
  static const String currencies = 'currency_currencies';

  static String rates(String base) => 'currency_rates_$base';
  static String rateDate(String base) =>
      'currency_rate_date_$base';
  static String cacheTimestamp(String base) =>
      'currency_cache_timestamp_$base';
}

/// Repository for caching currency data using SharedPreferences.
///
/// Stores exchange rates, available currencies, and user
/// preferences (from/to currency). Uses timestamp-based TTL
/// to determine cache freshness.
class CurrencyRepository {
  CurrencyRepository._(this._prefs);

  final SharedPreferences _prefs;

  /// Creates a [CurrencyRepository] backed by SharedPreferences.
  static Future<CurrencyRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return CurrencyRepository._(prefs);
  }

  // -- From/To currency preferences --

  /// Saves the user's preferred source currency.
  Future<void> saveFromCurrency(String code) async {
    await _prefs.setString(_StorageKeys.fromCurrency, code);
  }

  /// Loads the user's preferred source currency.
  /// Defaults to [CurrencyConstants.defaultFromCurrency].
  String loadFromCurrency() {
    return _prefs.getString(_StorageKeys.fromCurrency) ??
        CurrencyConstants.defaultFromCurrency;
  }

  /// Saves the user's preferred target currency.
  Future<void> saveToCurrency(String code) async {
    await _prefs.setString(_StorageKeys.toCurrency, code);
  }

  /// Loads the user's preferred target currency.
  /// Defaults to [CurrencyConstants.defaultToCurrency].
  String loadToCurrency() {
    return _prefs.getString(_StorageKeys.toCurrency) ??
        CurrencyConstants.defaultToCurrency;
  }

  // -- Currency list cache --

  /// Saves the available currencies map as JSON.
  Future<void> saveCurrencies(
    Map<String, String> currencies,
  ) async {
    await _prefs.setString(
      _StorageKeys.currencies,
      jsonEncode(currencies),
    );
  }

  /// Loads the cached currencies map from JSON.
  /// Returns null if not cached.
  Map<String, String>? loadCurrencies() {
    final json = _prefs.getString(_StorageKeys.currencies);
    if (json == null) return null;
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded
        .map((key, value) => MapEntry(key, value as String));
  }

  // -- Exchange rates cache --

  /// Saves exchange rates for [base] currency as JSON.
  Future<void> saveRates(
    String base,
    Map<String, double> rates,
  ) async {
    await _prefs.setString(
      _StorageKeys.rates(base),
      jsonEncode(rates),
    );
  }

  /// Loads cached exchange rates for [base] currency.
  /// Returns null if not cached.
  Map<String, double>? loadRates(String base) {
    final json = _prefs.getString(_StorageKeys.rates(base));
    if (json == null) return null;
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
  }

  /// Saves the date string for cached rates.
  Future<void> saveRateDate(String base, String date) async {
    await _prefs.setString(
      _StorageKeys.rateDate(base),
      date,
    );
  }

  /// Loads the date string for cached rates.
  /// Returns null if not cached.
  String? loadRateDate(String base) {
    return _prefs.getString(_StorageKeys.rateDate(base));
  }

  // -- Cache freshness --

  /// Saves the current timestamp for cache TTL tracking.
  Future<void> saveCacheTimestamp(String base) async {
    await _prefs.setInt(
      _StorageKeys.cacheTimestamp(base),
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Returns true if the cached rates for [base] are within
  /// [CurrencyConstants.cacheMaxAge].
  bool isCacheFresh(String base) {
    final timestamp = _prefs.getInt(
      _StorageKeys.cacheTimestamp(base),
    );
    if (timestamp == null) return false;

    final cachedAt =
        DateTime.fromMillisecondsSinceEpoch(timestamp);
    final age = DateTime.now().difference(cachedAt);
    return age < CurrencyConstants.cacheMaxAge;
  }
}
