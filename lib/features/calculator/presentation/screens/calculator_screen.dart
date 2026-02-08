import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/core/utils/calculator_engine.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_event.dart';
import 'package:math_mate/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_display.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_keypad.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/history/presentation/widgets/history_bottom_sheet.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:math_mate/features/settings/presentation/screens/settings_screen.dart';

/// The main calculator screen combining display and keypad.
///
/// This screen:
/// - Provides [CalculatorBloc] to child widgets via [BlocProvider]
/// - Connects [CalculatorDisplay] to bloc state via [BlocBuilder]
/// - Wires [CalculatorKeypad] callbacks to bloc events
/// - Uses [CalculatorRepository] for state persistence
/// - Uses [HistoryRepository] to save successful calculations
/// - Adapts layout based on orientation (portrait/landscape)
///
/// Portrait layout:
/// ```
/// ┌─────────────────────────────┐
/// │        Display Area         │  ← Expanded
/// ├─────────────────────────────┤
/// │         Keypad (6×4)        │  ← responsive height
/// └─────────────────────────────┘
/// ```
///
/// Landscape layout:
/// ```
/// ┌─────────────────────────────┐
/// │    Expression + Result      │  ← compact
/// ├─────────────────────────────┤
/// │  AC  ⌫  7  8  9  ÷         │
/// │  (   )  4  5  6  ×         │  ← 4×6 grid
/// │  %   ±  1  2  3  −         │
/// │  🕐  ⚙  0  .  =  +         │
/// └─────────────────────────────┘
/// ```
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({
    required this.calculatorRepository,
    required this.historyRepository,
    super.key,
  });

  /// Repository for persisting calculator state.
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
/// Uses [LayoutBuilder] to get available constraints and
/// [MediaQuery.orientationOf] to detect orientation, then
/// computes [ResponsiveDimensions] for adaptive sizing.
class _CalculatorView extends StatelessWidget {
  const _CalculatorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final orientation =
                MediaQuery.orientationOf(context);
            final dimensions =
                ResponsiveDimensions.fromConstraints(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              orientation: orientation,
            );

            if (dimensions.isLandscape) {
              return _buildLandscape(
                context,
                dimensions,
              );
            }
            return _buildPortrait(context, dimensions);
          },
        ),
      ),
    );
  }

  /// Portrait layout: Column with display on top, keypad below.
  Widget _buildPortrait(
    BuildContext context,
    ResponsiveDimensions dimensions,
  ) {
    return Column(
      children: [
        Expanded(
          child: _buildDisplay(context, dimensions),
        ),
        _buildKeypad(context, dimensions),
      ],
    );
  }

  /// Landscape layout: Column with compact display on top,
  /// keypad below filling remaining space.
  Widget _buildLandscape(
    BuildContext context,
    ResponsiveDimensions dimensions,
  ) {
    return Column(
      children: [
        _buildDisplay(context, dimensions),
        Expanded(
          child: _buildKeypad(context, dimensions),
        ),
      ],
    );
  }

  /// Builds the display area connected to bloc state.
  Widget _buildDisplay(
    BuildContext context,
    ResponsiveDimensions dimensions,
  ) {
    return BlocBuilder<CalculatorBloc, CalculatorState>(
      builder: (context, state) {
        final expression = _getExpression(state);
        final result = _getResult(state);

        return Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(
            bottom: dimensions.isLandscape ? 4 : 16,
          ),
          child: CalculatorDisplay(
            expression: expression,
            result: result,
            errorMessage: _getErrorMessage(context, state),
            dimensions: dimensions,
            onExpressionLongPress: expression.isNotEmpty
                ? () => _copyToClipboard(context, expression)
                : null,
            onResultLongPress:
                state is! CalculatorError && result.isNotEmpty
                    ? () => _copyToClipboard(context, result)
                    : null,
          ),
        );
      },
    );
  }

  /// Copies [text] to clipboard with haptic feedback and snackbar.
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final a11yState = context.read<AccessibilityCubit>().state;
    if (a11yState.hapticFeedback) {
      HapticFeedback.mediumImpact();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.copiedToClipboard),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Extracts the expression from the current state.
  String _getExpression(CalculatorState state) {
    return switch (state) {
      CalculatorInitial() => '',
      CalculatorInput() => state.expression,
      CalculatorResult() => state.expression,
      CalculatorError() => state.expression,
    };
  }

  /// Extracts the result from the current state.
  String _getResult(CalculatorState state) {
    return switch (state) {
      CalculatorInitial() => '0',
      CalculatorInput() =>
        state.liveResult.isNotEmpty
            ? state.liveResult
            : '0',
      CalculatorResult() => state.result,
      CalculatorError() => '',
    };
  }

  /// Extracts the error message from the current state.
  ///
  /// Resolves [CalculationErrorType] to a localized string via context.l10n.
  String? _getErrorMessage(BuildContext context, CalculatorState state) {
    return switch (state) {
      CalculatorError() => switch (state.errorType) {
          CalculationErrorType.divisionByZero =>
            context.l10n.errorDivisionByZero,
          CalculationErrorType.invalidExpression =>
            context.l10n.errorInvalidExpression,
          CalculationErrorType.overflow => context.l10n.errorOverflow,
          CalculationErrorType.undefined => context.l10n.errorUndefined,
          CalculationErrorType.generic => context.l10n.error,
        },
      _ => null,
    };
  }

  /// Builds the keypad with all callbacks wired to bloc events.
  Widget _buildKeypad(
    BuildContext context,
    ResponsiveDimensions dimensions,
  ) {
    final bloc = context.read<CalculatorBloc>();

    return CalculatorKeypad(
      onDigitPressed: (digit) =>
          bloc.add(DigitPressed(digit)),
      onOperatorPressed: (operator) =>
          bloc.add(OperatorPressed(operator)),
      onEqualsPressed: () =>
          bloc.add(const EqualsPressed()),
      onBackspacePressed: () =>
          bloc.add(const BackspacePressed()),
      onAllClearPressed: () =>
          bloc.add(const AllClearPressed()),
      onDecimalPressed: () =>
          bloc.add(const DecimalPressed()),
      onPercentPressed: () =>
          bloc.add(const PercentPressed()),
      onPlusMinusPressed: () =>
          bloc.add(const PlusMinusPressed()),
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
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
      },
      dimensions: dimensions,
    );
  }
}
