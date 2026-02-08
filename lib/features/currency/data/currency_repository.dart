import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:math_mate/core/services/app_logger.dart';
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
  CurrencyRepository._(this._prefs, this._logger);

  /// Creates a [CurrencyRepository] for testing with injected
  /// dependencies.
  @visibleForTesting
  CurrencyRepository.forTesting(
    this._prefs, {
    AppLogger? logger,
  }) : _logger = logger ?? AppLogger();

  final SharedPreferences _prefs;
  final AppLogger _logger;

  /// Creates a [CurrencyRepository] backed by SharedPreferences.
  static Future<CurrencyRepository> create({
    AppLogger? logger,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return CurrencyRepository._(prefs, logger ?? AppLogger());
  }

  // -- From/To currency preferences --

  /// Saves the user's preferred source currency.
  Future<void> saveFromCurrency(String code) async {
    try {
      await _prefs.setString(
        _StorageKeys.fromCurrency,
        code,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save from currency',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the user's preferred source currency.
  /// Defaults to [CurrencyConstants.defaultFromCurrency].
  String loadFromCurrency() {
    return _prefs.getString(_StorageKeys.fromCurrency) ??
        CurrencyConstants.defaultFromCurrency;
  }

  /// Saves the user's preferred target currency.
  Future<void> saveToCurrency(String code) async {
    try {
      await _prefs.setString(
        _StorageKeys.toCurrency,
        code,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save to currency',
        e,
        stackTrace,
      );
    }
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
    try {
      await _prefs.setString(
        _StorageKeys.currencies,
        jsonEncode(currencies),
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save currencies',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the cached currencies map from JSON.
  /// Returns null if not cached.
  Map<String, String>? loadCurrencies() {
    final json = _prefs.getString(_StorageKeys.currencies);
    if (json == null) return null;
    final decoded =
        jsonDecode(json) as Map<String, dynamic>;
    return decoded.map(
      (key, value) => MapEntry(key, value as String),
    );
  }

  // -- Exchange rates cache --

  /// Saves exchange rates for [base] currency as JSON.
  Future<void> saveRates(
    String base,
    Map<String, double> rates,
  ) async {
    try {
      await _prefs.setString(
        _StorageKeys.rates(base),
        jsonEncode(rates),
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save rates',
        e,
        stackTrace,
      );
    }
  }

  /// Loads cached exchange rates for [base] currency.
  /// Returns null if not cached.
  Map<String, double>? loadRates(String base) {
    final json =
        _prefs.getString(_StorageKeys.rates(base));
    if (json == null) return null;
    final decoded =
        jsonDecode(json) as Map<String, dynamic>;
    return decoded.map(
      (key, value) =>
          MapEntry(key, (value as num).toDouble()),
    );
  }

  /// Saves the date string for cached rates.
  Future<void> saveRateDate(
    String base,
    String date,
  ) async {
    try {
      await _prefs.setString(
        _StorageKeys.rateDate(base),
        date,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save rate date',
        e,
        stackTrace,
      );
    }
  }

  /// Loads the date string for cached rates.
  /// Returns null if not cached.
  String? loadRateDate(String base) {
    return _prefs.getString(
      _StorageKeys.rateDate(base),
    );
  }

  // -- Cache freshness --

  /// Saves the current timestamp for cache TTL tracking.
  Future<void> saveCacheTimestamp(String base) async {
    try {
      await _prefs.setInt(
        _StorageKeys.cacheTimestamp(base),
        DateTime.now().millisecondsSinceEpoch,
      );
    } on Exception catch (e, stackTrace) {
      _logger.error(
        'Failed to save cache timestamp',
        e,
        stackTrace,
      );
    }
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
