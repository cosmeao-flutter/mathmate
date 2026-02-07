// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/l10n/app_localizations.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_display.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );
  }

  group('CalculatorDisplay responsive', () {
    testWidgets('accepts null dimensions (backward compatible)',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          CalculatorDisplay(expression: '2 + 3', result: '5'),
        ),
      );

      final resultText = tester.widget<Text>(find.text('5'));
      expect(
        resultText.style?.fontSize,
        AppDimensions.fontSizeResult,
      );
    });

    testWidgets('uses custom result font size from dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        fontSizeResult: 40,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorDisplay(
            expression: '2 + 3',
            result: '5',
            dimensions: dimensions,
          ),
        ),
      );

      final resultText = tester.widget<Text>(find.text('5'));
      expect(resultText.style?.fontSize, 40);
    });

    testWidgets('uses custom expression font size from dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        fontSizeExpression: 18,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorDisplay(
            expression: '2 + 3',
            result: '5',
            dimensions: dimensions,
          ),
        ),
      );

      final expressionText = tester.widget<Text>(
        find.text('2 + 3'),
      );
      expect(expressionText.style?.fontSize, 18);
    });

    testWidgets('uses custom error font size from dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        fontSizeError: 10,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorDisplay(
            expression: '5 / 0',
            result: '',
            errorMessage: 'Cannot divide by zero',
            dimensions: dimensions,
          ),
        ),
      );

      final errorText = tester.widget<Text>(
        find.text('Cannot divide by zero'),
      );
      expect(errorText.style?.fontSize, 10);
    });

    testWidgets('uses custom display padding from dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        displayPadding: 12,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorDisplay(
            expression: '1 + 1',
            result: '2',
            dimensions: dimensions,
          ),
        ),
      );

      // Find all Padding widgets inside the display
      final paddings = tester.widgetList<Padding>(
        find.descendant(
          of: find.byType(CalculatorDisplay),
          matching: find.byType(Padding),
        ),
      );

      // The display's own Padding should have our custom value
      final displayPadding = paddings.firstWhere(
        (p) => p.padding == const EdgeInsets.all(12),
      );
      expect(displayPadding.padding, const EdgeInsets.all(12));
    });

    testWidgets('FittedBox scales down long result text',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 150,
            child: CalculatorDisplay(
              expression: '',
              result: '123456789012345',
            ),
          ),
        ),
      );

      // FittedBox should prevent overflow
      expect(find.text('123456789012345'), findsOneWidget);
      expect(find.byType(FittedBox), findsWidgets);
    });

    testWidgets('renders in narrow landscape-like container',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 667,
        height: 375,
        orientation: Orientation.landscape,
      );

      await tester.pumpWidget(
        buildTestWidget(
          SizedBox(
            width: 200,
            height: 300,
            child: CalculatorDisplay(
              expression: '123 + 456 × 789',
              result: '359,907',
              dimensions: dimensions,
            ),
          ),
        ),
      );

      // Should render without overflow in narrow container
      expect(find.text('359,907'), findsOneWidget);
    });
  });
}
