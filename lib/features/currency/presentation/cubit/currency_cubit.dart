import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/currency/data/currency_repository.dart';
import 'package:math_mate/features/currency/data/currency_service.dart';
import 'package:math_mate/features/currency/domain/currency_constants.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_state.dart';

/// Cubit for managing currency converter state.
///
/// Uses a cache-first strategy: checks [CurrencyRepository]
/// for fresh cached rates before fetching from [CurrencyService].
/// Falls back to stale cache when the network is unavailable.
class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit({
    required this.service,
    required this.repository,
  }) : super(
          CurrencyInitial(
            fromCurrency: repository.loadFromCurrency(),
            toCurrency: repository.loadToCurrency(),
          ),
        );

  /// HTTP service for the Frankfurter API.
  final CurrencyService service;

  /// Local cache for rates and preferences.
  final CurrencyRepository repository;

  /// Loads exchange rates using cache-first strategy.
  ///
  /// 1. If cache is fresh, use cached rates
  /// 2. Otherwise, fetch from network and cache
  /// 3. On network error, fall back to stale cache
  /// 4. If no cache at all, emit error
  Future<void> loadRates() async {
    final from = _currentFrom;
    final to = _currentTo;

    emit(const CurrencyLoading());

    // Try cache first
    if (repository.isCacheFresh(from)) {
      final cachedRates = repository.loadRates(from);
      final cachedCurrencies = repository.loadCurrencies();
      final cachedDate = repository.loadRateDate(from);

      if (cachedRates != null && cachedCurrencies != null) {
        _emitLoaded(
          from: from,
          to: to,
          rates: cachedRates,
          currencies: cachedCurrencies,
          rateDate: cachedDate ?? '',
        );
        return;
      }
    }

    // Fetch from network
    await _fetchAndEmit(from: from, to: to);
  }

  /// Updates the conversion amount and recalculates.
  void updateAmount(double amount) {
    final current = state;
    if (current is! CurrencyLoaded) return;

    final rate = current.rates[current.toCurrency] ?? 0;
    emit(current.copyWith(
      amount: amount,
      result: amount * rate,
    ));
  }

  /// Changes the source currency, fetches new rates.
  Future<void> setFromCurrency(String code) async {
    final current = state;
    if (current is! CurrencyLoaded) return;

    await repository.saveFromCurrency(code);
    emit(const CurrencyLoading());

    await _fetchAndEmit(
      from: code,
      to: current.toCurrency,
      amount: current.amount,
    );
  }

  /// Changes the target currency and recalculates.
  Future<void> setToCurrency(String code) async {
    final current = state;
    if (current is! CurrencyLoaded) return;

    await repository.saveToCurrency(code);

    final rate = current.rates[code] ?? 0;
    emit(current.copyWith(
      toCurrency: code,
      result: current.amount * rate,
    ));
  }

  /// Swaps from and to currencies, fetches new rates.
  Future<void> swapCurrencies() async {
    final current = state;
    if (current is! CurrencyLoaded) return;

    final newFrom = current.toCurrency;
    final newTo = current.fromCurrency;

    await repository.saveFromCurrency(newFrom);
    await repository.saveToCurrency(newTo);

    emit(const CurrencyLoading());

    await _fetchAndEmit(
      from: newFrom,
      to: newTo,
      amount: current.amount,
    );
  }

  /// Force-refreshes rates from the network, ignoring cache.
  Future<void> refresh() async {
    final current = state;
    final from = current is CurrencyLoaded
        ? current.fromCurrency
        : _currentFrom;
    final to = current is CurrencyLoaded
        ? current.toCurrency
        : _currentTo;
    final amount = current is CurrencyLoaded
        ? current.amount
        : CurrencyConstants.defaultAmount;

    emit(const CurrencyLoading());

    await _fetchAndEmit(from: from, to: to, amount: amount);
  }

  // -- Private helpers --

  String get _currentFrom {
    final s = state;
    if (s is CurrencyInitial) return s.fromCurrency;
    if (s is CurrencyLoaded) return s.fromCurrency;
    return repository.loadFromCurrency();
  }

  String get _currentTo {
    final s = state;
    if (s is CurrencyInitial) return s.toCurrency;
    if (s is CurrencyLoaded) return s.toCurrency;
    return repository.loadToCurrency();
  }

  Future<void> _fetchAndEmit({
    required String from,
    required String to,
    double amount = CurrencyConstants.defaultAmount,
  }) async {
    try {
      final currencies = await service.fetchCurrencies();
      final exchangeRates =
          await service.fetchRates(base: from);

      // Cache results
      await repository.saveCurrencies(currencies);
      await repository.saveRates(from, exchangeRates.rates);
      await repository.saveRateDate(from, exchangeRates.date);
      await repository.saveCacheTimestamp(from);

      _emitLoaded(
        from: from,
        to: to,
        amount: amount,
        rates: exchangeRates.rates,
        currencies: currencies,
        rateDate: exchangeRates.date,
      );
    } on CurrencyServiceException catch (e) {
      // Try stale cache as fallback
      final cachedRates = repository.loadRates(from);
      final cachedCurrencies = repository.loadCurrencies();
      final cachedDate = repository.loadRateDate(from);

      if (cachedRates != null && cachedCurrencies != null) {
        _emitLoaded(
          from: from,
          to: to,
          amount: amount,
          rates: cachedRates,
          currencies: cachedCurrencies,
          rateDate: cachedDate ?? '',
          isOfflineCache: true,
        );
      } else {
        emit(CurrencyError(message: e.message));
      }
    }
  }

  void _emitLoaded({
    required String from,
    required String to,
    required Map<String, double> rates,
    required Map<String, String> currencies,
    required String rateDate,
    double amount = CurrencyConstants.defaultAmount,
    bool isOfflineCache = false,
  }) {
    final rate = rates[to] ?? 0;
    emit(CurrencyLoaded(
      amount: amount,
      result: amount * rate,
      fromCurrency: from,
      toCurrency: to,
      rates: rates,
      currencies: currencies,
      rateDate: rateDate,
      isOfflineCache: isOfflineCache,
    ));
  }
}
