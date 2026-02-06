import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_display.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_keypad.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/history/presentation/widgets/history_bottom_sheet.dart';
import 'package:math_mate/features/settings/presentation/screens/settings_screen.dart';

/// The main calculator screen combining display and keypad.
///
/// This screen:
/// - Provides [CalculatorBloc] to child widgets via [BlocProvider]
/// - Connects [CalculatorDisplay] to bloc state via [BlocBuilder]
/// - Wires [CalculatorKeypad] callbacks to bloc events
/// - Uses [CalculatorRepository] for state persistence
/// - Uses [HistoryRepository] to save successful calculations
///
/// Layout:
/// ```
/// ┌─────────────────────────────┐
/// │                             │
/// │        Display Area         │  ← Expands to fill available space
/// │   (expression + result)     │
/// │                             │
/// ├─────────────────────────────┤
/// │                             │
/// │         Keypad              │  ← Fixed height based on content
/// │       (6×4 grid)            │
/// │                             │
/// └─────────────────────────────┘
/// ```
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({
    required this.calculatorRepository,
    required this.historyRepository,
    super.key,
  });

  /// Repository for persisting calculator state across app restarts.
  final CalculatorRepository calculatorRepository;

  /// Repository for saving calculation history.
  final HistoryRepository historyRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalculatorBloc(
        repository: calculatorRepository,
        historyRepository: historyRepository,
      )..add(const CalculatorStarted()),
      child: const _CalculatorView(),
    );
  }
}

/// Internal view widget that consumes the [CalculatorBloc].
///
/// Separated from [CalculatorScreen] to keep BlocProvider creation
/// and widget building cleanly separated.
class _CalculatorView extends StatelessWidget {
  const _CalculatorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display area - expands to fill available space
            Expanded(
              child: _buildDisplay(context),
            ),

            // Keypad - fixed height based on content
            _buildKeypad(context),
          ],
        ),
      ),
    );
  }

  /// Builds the display area connected to bloc state.
  Widget _buildDisplay(BuildContext context) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        return Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 16),
          child: CalculatorDisplay(
            expression: _getExpression(state),
            result: _getResult(state),
            errorMessage: _getErrorMessage(state),
          ),
        );
      },
    );
  }

  /// Extracts the expression to display from the current state.
  String _getExpression(CalculatorState state) {
    return switch (state) {
      CalculatorInitial() => '',
      CalculatorInput() => state.expression,
      CalculatorResult() => state.expression,
      CalculatorError() => state.expression,
    };
  }

  /// Extracts the result to display from the current state.
  String _getResult(CalculatorState state) {
    return switch (state) {
      CalculatorInitial() => '0',
      CalculatorInput() => state.liveResult.isNotEmpty ? state.liveResult : '0',
      CalculatorResult() => state.result,
      CalculatorError() => '',
    };
  }

  /// Extracts the error message from the current state (if any).
  String? _getErrorMessage(CalculatorState state) {
    return switch (state) {
      CalculatorError() => state.errorMessage,
      _ => null,
    };
  }

  /// Builds the keypad with all callbacks wired to bloc events.
  Widget _buildKeypad(BuildContext context) {
    final bloc = context.read<CalculatorBloc>();

    return CalculatorKeypad(
      onDigitPressed: (digit) => bloc.add(DigitPressed(digit)),
      onOperatorPressed: (operator) => bloc.add(OperatorPressed(operator)),
      onEqualsPressed: () => bloc.add(const EqualsPressed()),
      onBackspacePressed: () => bloc.add(const BackspacePressed()),
      onAllClearPressed: () => bloc.add(const AllClearPressed()),
      onDecimalPressed: () => bloc.add(const DecimalPressed()),
      onPercentPressed: () => bloc.add(const PercentPressed()),
      onPlusMinusPressed: () => bloc.add(const PlusMinusPressed()),
      onParenthesisPressed: ({required bool isOpen}) =>
          bloc.add(ParenthesisPressed(isOpen: isOpen)),
      onHistoryPressed: () => showHistoryBottomSheet(
        context,
        onEntryTap: (expression) {
          bloc.add(HistoryEntryLoaded(expression));
        },
      ),
      onSettingsPressed: () {
        Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
      },
    );
  }
}
