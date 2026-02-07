import 'package:flutter/material.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:math_mate/features/currency/presentation/screens/currency_screen.dart';
import 'package:math_mate/features/history/data/history_repository.dart';

/// Home screen with bottom navigation bar.
///
/// Uses [NavigationBar] (Material 3) with two destinations:
/// - Calculator ([Icons.calculate])
/// - Currency ([Icons.currency_exchange])
///
/// Uses [IndexedStack] to preserve the state of both screens
/// when switching between tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.calculatorRepository,
    required this.historyRepository,
    super.key,
  });

  /// Repository for persisting calculator state.
  final CalculatorRepository calculatorRepository;

  /// Repository for saving calculation history.
  final HistoryRepository historyRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CalculatorScreen(
            calculatorRepository: widget.calculatorRepository,
            historyRepository: widget.historyRepository,
          ),
          const CurrencyScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate),
            label: context.l10n.navCalculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.currency_exchange),
            label: context.l10n.navCurrency,
          ),
        ],
      ),
    );
  }
}
