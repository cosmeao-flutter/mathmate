/// Constants for the currency converter feature.
class CurrencyConstants {
  CurrencyConstants._();

  /// Base URL for the Frankfurter API.
  static const String apiBaseUrl = 'https://api.frankfurter.dev/v1';

  /// Default source currency code.
  static const String defaultFromCurrency = 'USD';

  /// Default target currency code.
  static const String defaultToCurrency = 'EUR';

  /// Maximum age for cached rates before refetching (1 hour).
  static const Duration cacheMaxAge = Duration(hours: 1);

  /// Default conversion amount.
  static const double defaultAmount = 1;
}
