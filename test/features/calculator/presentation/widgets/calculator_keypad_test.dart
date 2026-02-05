// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_keypad.dart';

/// Tests for CalculatorKeypad widget.
///
/// The keypad is a 6×4 grid of calculator buttons following this layout:
/// ```
/// ┌─────┬─────┬─────┬─────┐
/// │ AC  │  ⌫  │     │     │  ← Control row (2 slots for future)
/// ├─────┼─────┼─────┼─────┤
/// │  (  │  )  │  %  │  ÷  │  ← Functions & division
/// ├─────┼─────┼─────┼─────┤
/// │  7  │  8  │  9  │  ×  │
/// ├─────┼─────┼─────┼─────┤
/// │  4  │  5  │  6  │  −  │
/// ├─────┼─────┼─────┼─────┤
/// │  1  │  2  │  3  │  +  │
/// ├─────┼─────┼─────┼─────┤
/// │  ±  │  0  │  .  │  =  │  ← Plus/minus, zero, decimal, equals
/// └─────┴─────┴─────┴─────┘
/// ```
void main() {
  /// Helper to wrap widget in MaterialApp for testing.
  Widget buildTestWidget({
    void Function(String)? onDigitPressed,
    void Function(String)? onOperatorPressed,
    VoidCallback? onEqualsPressed,
    VoidCallback? onBackspacePressed,
    VoidCallback? onAllClearPressed,
    VoidCallback? onDecimalPressed,
    VoidCallback? onPercentPressed,
    VoidCallback? onPlusMinusPressed,
    void Function({required bool isOpen})? onParenthesisPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: CalculatorKeypad(
          onDigitPressed: onDigitPressed ?? (_) {},
          onOperatorPressed: onOperatorPressed ?? (_) {},
          onEqualsPressed: onEqualsPressed ?? () {},
          onBackspacePressed: onBackspacePressed ?? () {},
          onAllClearPressed: onAllClearPressed ?? () {},
          onDecimalPressed: onDecimalPressed ?? () {},
          onPercentPressed: onPercentPressed ?? () {},
          onPlusMinusPressed: onPlusMinusPressed ?? () {},
          onParenthesisPressed:
              onParenthesisPressed ?? ({required bool isOpen}) {},
        ),
      ),
    );
  }

  group('CalculatorKeypad', () {
    group('layout', () {
      testWidgets('displays all digit buttons (0-9)', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Check all digits are present
        for (var i = 0; i <= 9; i++) {
          expect(find.text('$i'), findsOneWidget);
        }
      });

      testWidgets('displays all operator buttons', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text(AppStrings.plus), findsOneWidget);
        expect(find.text(AppStrings.minus), findsOneWidget);
        expect(find.text(AppStrings.multiply), findsOneWidget);
        expect(find.text(AppStrings.divide), findsOneWidget);
      });

      testWidgets('displays function buttons', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text(AppStrings.allClear), findsOneWidget);
        expect(find.text(AppStrings.backspace), findsOneWidget);
        expect(find.text(AppStrings.plusMinus), findsOneWidget);
        expect(find.text(AppStrings.percent), findsOneWidget);
      });

      testWidgets('displays decimal button', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text(AppStrings.decimal), findsOneWidget);
      });

      testWidgets('displays parenthesis buttons', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text(AppStrings.openParen), findsOneWidget);
        expect(find.text(AppStrings.closeParen), findsOneWidget);
      });

      testWidgets('displays equals button', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text(AppStrings.equals), findsOneWidget);
      });

      testWidgets('contains 24 calculator buttons', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // 6 rows × 4 columns = 24 buttons
        // 10 digits + 4 operators + 1 equals + 1 decimal +
        // 6 functions (AC, ⌫, ±, %, (, )) + 2 placeholders = 24
        expect(find.byType(CalculatorButton), findsNWidgets(24));
      });
    });

    group('digit callbacks', () {
      testWidgets('calls onDigitPressed with "0" when 0 tapped',
          (tester) async {
        String? pressedDigit;
        await tester.pumpWidget(
          buildTestWidget(onDigitPressed: (d) => pressedDigit = d),
        );

        await tester.tap(find.text('0'));
        await tester.pump();

        expect(pressedDigit, '0');
      });

      testWidgets('calls onDigitPressed with "5" when 5 tapped',
          (tester) async {
        String? pressedDigit;
        await tester.pumpWidget(
          buildTestWidget(onDigitPressed: (d) => pressedDigit = d),
        );

        await tester.tap(find.text('5'));
        await tester.pump();

        expect(pressedDigit, '5');
      });

      testWidgets('calls onDigitPressed with "9" when 9 tapped',
          (tester) async {
        String? pressedDigit;
        await tester.pumpWidget(
          buildTestWidget(onDigitPressed: (d) => pressedDigit = d),
        );

        await tester.tap(find.text('9'));
        await tester.pump();

        expect(pressedDigit, '9');
      });
    });

    group('operator callbacks', () {
      testWidgets('calls onOperatorPressed with + when plus tapped',
          (tester) async {
        String? pressedOp;
        await tester.pumpWidget(
          buildTestWidget(onOperatorPressed: (op) => pressedOp = op),
        );

        await tester.tap(find.text(AppStrings.plus));
        await tester.pump();

        expect(pressedOp, AppStrings.plus);
      });

      testWidgets('calls onOperatorPressed with − when minus tapped',
          (tester) async {
        String? pressedOp;
        await tester.pumpWidget(
          buildTestWidget(onOperatorPressed: (op) => pressedOp = op),
        );

        await tester.tap(find.text(AppStrings.minus));
        await tester.pump();

        expect(pressedOp, AppStrings.minus);
      });

      testWidgets('calls onOperatorPressed with × when multiply tapped',
          (tester) async {
        String? pressedOp;
        await tester.pumpWidget(
          buildTestWidget(onOperatorPressed: (op) => pressedOp = op),
        );

        await tester.tap(find.text(AppStrings.multiply));
        await tester.pump();

        expect(pressedOp, AppStrings.multiply);
      });

      testWidgets('calls onOperatorPressed with ÷ when divide tapped',
          (tester) async {
        String? pressedOp;
        await tester.pumpWidget(
          buildTestWidget(onOperatorPressed: (op) => pressedOp = op),
        );

        await tester.tap(find.text(AppStrings.divide));
        await tester.pump();

        expect(pressedOp, AppStrings.divide);
      });
    });

    group('function callbacks', () {
      testWidgets('calls onAllClearPressed when AC tapped', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(onAllClearPressed: () => pressed = true),
        );

        await tester.tap(find.text(AppStrings.allClear));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('calls onBackspacePressed when ⌫ tapped', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(onBackspacePressed: () => pressed = true),
        );

        await tester.tap(find.text(AppStrings.backspace));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('calls onPlusMinusPressed when ± tapped', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(onPlusMinusPressed: () => pressed = true),
        );

        await tester.tap(find.text(AppStrings.plusMinus));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('calls onPercentPressed when % tapped', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(onPercentPressed: () => pressed = true),
        );

        await tester.tap(find.text(AppStrings.percent));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('calls onDecimalPressed when . tapped', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(onDecimalPressed: () => pressed = true),
        );

        await tester.tap(find.text(AppStrings.decimal));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('calls onEqualsPressed when = tapped', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          buildTestWidget(onEqualsPressed: () => pressed = true),
        );

        await tester.tap(find.text(AppStrings.equals));
        await tester.pump();

        expect(pressed, isTrue);
      });
    });

    group('parenthesis callbacks', () {
      testWidgets('calls onParenthesisPressed(true) when ( tapped',
          (tester) async {
        bool? pressedIsOpen;
        await tester.pumpWidget(
          buildTestWidget(
            onParenthesisPressed: ({required bool isOpen}) =>
                pressedIsOpen = isOpen,
          ),
        );

        await tester.tap(find.text(AppStrings.openParen));
        await tester.pump();

        expect(pressedIsOpen, isTrue);
      });

      testWidgets('calls onParenthesisPressed(false) when ) tapped',
          (tester) async {
        bool? pressedIsOpen;
        await tester.pumpWidget(
          buildTestWidget(
            onParenthesisPressed: ({required bool isOpen}) =>
                pressedIsOpen = isOpen,
          ),
        );

        await tester.tap(find.text(AppStrings.closeParen));
        await tester.pump();

        expect(pressedIsOpen, isFalse);
      });
    });

    group('button types', () {
      testWidgets('digit buttons have number type', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Find the button with text "5" and check its type
        final button = tester.widget<CalculatorButton>(
          find.ancestor(
            of: find.text('5'),
            matching: find.byType(CalculatorButton),
          ),
        );

        expect(button.type, CalculatorButtonType.number);
      });

      testWidgets('operator buttons have operator type', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final button = tester.widget<CalculatorButton>(
          find.ancestor(
            of: find.text(AppStrings.plus),
            matching: find.byType(CalculatorButton),
          ),
        );

        expect(button.type, CalculatorButtonType.operator);
      });

      testWidgets('function buttons have function type', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final button = tester.widget<CalculatorButton>(
          find.ancestor(
            of: find.text(AppStrings.allClear),
            matching: find.byType(CalculatorButton),
          ),
        );

        expect(button.type, CalculatorButtonType.function);
      });

      testWidgets('backspace button has function type', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final button = tester.widget<CalculatorButton>(
          find.ancestor(
            of: find.text(AppStrings.backspace),
            matching: find.byType(CalculatorButton),
          ),
        );

        expect(button.type, CalculatorButtonType.function);
      });

      testWidgets('equals button has equals type', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        final button = tester.widget<CalculatorButton>(
          find.ancestor(
            of: find.text(AppStrings.equals),
            matching: find.byType(CalculatorButton),
          ),
        );

        expect(button.type, CalculatorButtonType.equals);
      });
    });
  });
}
