import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_cubit.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_state.dart';
import 'package:math_mate/features/currency/presentation/widgets/currency_picker.dart';

/// Currency converter screen.
///
/// Displays an amount input, from/to currency pickers, a swap
/// button, and the converted result. Handles loading, error,
/// and offline cache states.
class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.currencyTitle),
      ),
      body: BlocConsumer<CurrencyCubit, CurrencyState>(
        listener: (context, state) {
          if (state is CurrencyLoaded) {
            // Sync controller if amount changed externally
            final currentText =
                double.tryParse(_amountController.text) ?? 0;
            if (currentText != state.amount) {
              _amountController.text =
                  _formatAmount(state.amount);
            }
          }
        },
        builder: (context, state) {
          return switch (state) {
            CurrencyInitial() => _buildLoading(context),
            CurrencyLoading() => _buildLoading(context),
            CurrencyLoaded() =>
              _buildLoaded(context, state),
            CurrencyError() =>
              _buildError(context, state),
          };
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(context.l10n.currencyLoading),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, CurrencyError state) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text(context.l10n.currencyError),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              unawaited(
                context.read<CurrencyCubit>().loadRates(),
              );
            },
            child: Text(context.l10n.currencyRetry),
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    CurrencyLoaded state,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Offline banner
        if (state.isOfflineCache) ...[
          MaterialBanner(
            content: Text(context.l10n.currencyOffline),
            leading: const Icon(Icons.cloud_off),
            actions: [
              TextButton(
                onPressed: () {
                  unawaited(
                    context.read<CurrencyCubit>().refresh(),
                  );
                },
                child: Text(context.l10n.currencyRetry),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Amount input
        TextField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: context.l10n.currencyAmount,
            hintText: context.l10n.currencyAmountHint,
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          onChanged: (value) {
            final amount = double.tryParse(value);
            if (amount != null) {
              context.read<CurrencyCubit>().updateAmount(
                    amount,
                  );
            }
          },
        ),

        const SizedBox(height: 16),

        // From currency
        CurrencyPicker(
          selectedCode: state.fromCurrency,
          currencies: state.currencies,
          label: context.l10n.currencyFrom,
          onChanged: (code) {
            unawaited(
              context
                  .read<CurrencyCubit>()
                  .setFromCurrency(code),
            );
          },
        ),

        const SizedBox(height: 8),

        // Swap button
        Center(
          child: IconButton(
            onPressed: () {
              unawaited(
                context
                    .read<CurrencyCubit>()
                    .swapCurrencies(),
              );
            },
            icon: const Icon(Icons.swap_vert),
            tooltip: context.l10n.currencySwap,
          ),
        ),

        const SizedBox(height: 8),

        // To currency
        CurrencyPicker(
          selectedCode: state.toCurrency,
          currencies: state.currencies,
          label: context.l10n.currencyTo,
          onChanged: (code) {
            unawaited(
              context
                  .read<CurrencyCubit>()
                  .setToCurrency(code),
            );
          },
        ),

        const SizedBox(height: 24),

        // Result display
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  context.l10n.currencyResult,
                  style:
                      Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _formatResult(state.result, state.toCurrency),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Rate date
        Center(
          child: Text(
            context.l10n.currencyRatesFrom(state.rateDate),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toString();
  }

  String _formatResult(double result, String currencyCode) {
    return '${result.toStringAsFixed(2)} $currencyCode';
  }
}
