import 'package:flutter/material.dart';

/// A dropdown button for selecting a currency.
///
/// Displays currencies as "CODE - Name" (e.g. "USD - United States Dollar").
class CurrencyPicker extends StatelessWidget {
  const CurrencyPicker({
    required this.selectedCode,
    required this.currencies,
    required this.onChanged,
    required this.label,
    super.key,
  });

  /// Currently selected currency code.
  final String selectedCode;

  /// Available currencies (code → display name).
  final Map<String, String> currencies;

  /// Called when the user selects a different currency.
  final ValueChanged<String> onChanged;

  /// Label displayed above the dropdown.
  final String label;

  @override
  Widget build(BuildContext context) {
    final sortedCodes = currencies.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        DropdownButton<String>(
          value: currencies.containsKey(selectedCode)
              ? selectedCode
              : sortedCodes.firstOrNull,
          isExpanded: true,
          items: sortedCodes.map((code) {
            final name = currencies[code] ?? code;
            return DropdownMenuItem<String>(
              value: code,
              child: Text(
                '$code - $name',
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
      ],
    );
  }
}
