import 'package:flutter/material.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:math_mate/features/currency/presentation/screens/currency_screen.dart';
import 'package:math_mate/features/history/data/history_repository.dart';

/// Home screen with adaptive navigation.
///
/// Uses orientation-aware navigation:
/// - **Portrait:** [NavigationBar] (Material 3 bottom bar)
/// - **Landscape:** [NavigationRail] (Material 3 side rail)
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

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        CalculatorScreen(
          calculatorRepository: widget.calculatorRepository,
          historyRepository: widget.historyRepository,
        ),
        const CurrencyScreen(),
      ],
    );
  }

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    if (isLandscape) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.calculate),
                  label: Text(context.l10n.navCalculator),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.currency_exchange),
                  label: Text(context.l10n.navCurrency),
                ),
              ],
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      );
    }

    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
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
