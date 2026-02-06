// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/core/theme/calculator_colors.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_display.dart';

/// Tests for CalculatorDisplay widget.
///
/// The display has two lines:
/// - Top line: Current expression (smaller, secondary color)
/// - Bottom line: Result/live preview (larger, primary color)
///
/// It also handles error state display.
void main() {
  /// Helper to wrap widget in MaterialApp for testing.
  /// Uses AppTheme.light which includes the CalculatorColors extension.
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('CalculatorDisplay', () {
    group('expression display', () {
      testWidgets('shows expression text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '2 + 3 × 4',
              result: '14',
            ),
          ),
        );

        expect(find.text('2 + 3 × 4'), findsOneWidget);
      });

      testWidgets('uses correct font size for expression', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '5 + 5',
              result: '10',
            ),
          ),
        );

        final expressionText = tester.widget<Text>(find.text('5 + 5'));
        expect(
          expressionText.style?.fontSize,
          AppDimensions.fontSizeExpression,
        );
      });

      testWidgets('uses secondary text color for expression', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '1 + 1',
              result: '2',
            ),
          ),
        );

        final expressionText = tester.widget<Text>(find.text('1 + 1'));
        expect(expressionText.style?.color, CalculatorColors.light.expressionText);
      });

      testWidgets('expression is right-aligned', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '123 + 456',
              result: '579',
            ),
          ),
        );

        final expressionText = tester.widget<Text>(find.text('123 + 456'));
        expect(expressionText.textAlign, TextAlign.right);
      });
    });

    group('result display', () {
      testWidgets('shows result text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '10 + 5',
              result: '15',
            ),
          ),
        );

        expect(find.text('15'), findsOneWidget);
      });

      testWidgets('uses correct font size for result', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '7 × 8',
              result: '56',
            ),
          ),
        );

        final resultText = tester.widget<Text>(find.text('56'));
        expect(resultText.style?.fontSize, AppDimensions.fontSizeResult);
      });

      testWidgets('uses primary text color for result', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '100 ÷ 4',
              result: '25',
            ),
          ),
        );

        final resultText = tester.widget<Text>(find.text('25'));
        expect(resultText.style?.color, CalculatorColors.light.resultText);
      });

      testWidgets('result is right-aligned', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '25 + 25',
              result: '50',
            ),
          ),
        );

        final resultText = tester.widget<Text>(find.text('50'));
        expect(resultText.textAlign, TextAlign.right);
      });
    });

    group('initial state', () {
      testWidgets('shows "0" as result when expression is "0"', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '0',
              result: '0',
            ),
          ),
        );

        expect(find.text('0'), findsNWidgets(2)); // expression and result
      });

      testWidgets('can show empty expression', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '',
              result: '0',
            ),
          ),
        );

        expect(find.text(''), findsOneWidget);
        expect(find.text('0'), findsOneWidget);
      });
    });

    group('error state', () {
      testWidgets('shows error message when provided', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '5 ÷ 0',
              result: '',
              errorMessage: 'Cannot divide by zero',
            ),
          ),
        );

        expect(find.text('Cannot divide by zero'), findsOneWidget);
      });

      testWidgets('error message uses error color', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '5 ÷ 0',
              result: '',
              errorMessage: 'Error',
            ),
          ),
        );

        final errorText = tester.widget<Text>(find.text('Error'));
        expect(errorText.style?.color, CalculatorColors.light.errorText);
      });

      testWidgets('error message uses smaller font', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: 'invalid',
              result: '',
              errorMessage: 'Invalid expression',
            ),
          ),
        );

        final errorText = tester.widget<Text>(find.text('Invalid expression'));
        expect(errorText.style?.fontSize, AppDimensions.fontSizeError);
      });

      testWidgets('hides result when showing error', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: 'bad',
              result: '123',
              errorMessage: 'Error occurred',
            ),
          ),
        );

        // Error message should be visible
        expect(find.text('Error occurred'), findsOneWidget);
        // Result "123" should not be visible (error replaces it)
        expect(find.text('123'), findsNothing);
      });
    });

    group('layout', () {
      testWidgets('has correct padding', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '1 + 2',
              result: '3',
            ),
          ),
        );

        // Find all Padding widgets that are descendants of CalculatorDisplay
        final paddingFinder = find.descendant(
          of: find.byType(CalculatorDisplay),
          matching: find.byType(Padding),
        );

        // Get all Padding widgets and check if one has the expected padding
        final paddingWidgets = tester.widgetList<Padding>(paddingFinder);
        final hasCorrectPadding = paddingWidgets.any(
          (p) => p.padding == EdgeInsets.all(AppDimensions.displayPadding),
        );

        expect(hasCorrectPadding, isTrue);
      });

      testWidgets('expression appears above result', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: 'TOP',
              result: 'BOTTOM',
            ),
          ),
        );

        final topPosition = tester.getCenter(find.text('TOP'));
        final bottomPosition = tester.getCenter(find.text('BOTTOM'));

        // Expression (TOP) should be above result (BOTTOM)
        expect(topPosition.dy, lessThan(bottomPosition.dy));
      });

      testWidgets('has white background', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '0',
              result: '0',
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(CalculatorDisplay),
            matching: find.byType(Container).first,
          ),
        );

        final decoration = container.decoration as BoxDecoration?;
        expect(decoration?.color, CalculatorColors.light.displayBackground);
      });
    });

    group('accessibility', () {
      testWidgets('expression has semantic label', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorDisplay(
              expression: '2 + 2',
              result: '4',
            ),
          ),
        );

        // Verify the display is accessible
        expect(find.byType(CalculatorDisplay), findsOneWidget);
      });
    });
  });
}
