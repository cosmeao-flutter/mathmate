import 'package:equatable/equatable.dart';

/// Base state for the currency converter.
sealed class CurrencyState extends Equatable {
  const CurrencyState();
}

/// Initial state before rates are loaded.
class CurrencyInitial extends CurrencyState {
  const CurrencyInitial({
    required this.fromCurrency,
    required this.toCurrency,
  });

  /// User's preferred source currency code.
  final String fromCurrency;

  /// User's preferred target currency code.
  final String toCurrency;

  @override
  List<Object> get props => [fromCurrency, toCurrency];
}

/// Loading state while fetching rates from the API.
class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();

  @override
  List<Object> get props => [];
}

/// Loaded state with rates available for conversion.
class CurrencyLoaded extends CurrencyState {
  const CurrencyLoaded({
    required this.amount,
    required this.result,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rates,
    required this.currencies,
    required this.rateDate,
    this.isOfflineCache = false,
  });

  /// Amount to convert.
  final double amount;

  /// Converted result.
  final double result;

  /// Source currency code.
  final String fromCurrency;

  /// Target currency code.
  final String toCurrency;

  /// Exchange rates relative to [fromCurrency].
  final Map<String, double> rates;

  /// Available currencies (code → display name).
  final Map<String, String> currencies;

  /// Date the rates apply to (ISO 8601).
  final String rateDate;

  /// Whether these rates are from stale cache (offline).
  final bool isOfflineCache;

  /// Creates a copy with updated fields.
  CurrencyLoaded copyWith({
    double? amount,
    double? result,
    String? fromCurrency,
    String? toCurrency,
    Map<String, double>? rates,
    Map<String, String>? currencies,
    String? rateDate,
    bool? isOfflineCache,
  }) {
    return CurrencyLoaded(
      amount: amount ?? this.amount,
      result: result ?? this.result,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rates: rates ?? this.rates,
      currencies: currencies ?? this.currencies,
      rateDate: rateDate ?? this.rateDate,
      isOfflineCache: isOfflineCache ?? this.isOfflineCache,
    );
  }

  @override
  List<Object> get props => [
        amount,
        result,
        fromCurrency,
        toCurrency,
        rates,
        currencies,
        rateDate,
        isOfflineCache,
      ];
}

/// Error state when rates could not be loaded.
class CurrencyError extends CurrencyState {
  const CurrencyError({required this.message});

  /// Human-readable error description.
  final String message;

  @override
  List<Object> get props => [message];
}
