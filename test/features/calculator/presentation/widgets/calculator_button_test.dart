// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/core/theme/calculator_colors.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_button.dart';

/// Tests for CalculatorButton widget.
///
/// These tests verify:
/// - Button renders with correct text
/// - Button triggers onPressed callback when tapped
/// - Button has correct colors for each type
/// - Button has correct shape (rounded rectangle)
/// - Button has press animation (scale to 0.95)
void main() {
  /// Helper to wrap widget in MaterialApp for testing.
  /// Uses AppTheme.light which includes the CalculatorColors extension.
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(
        body: Center(child: child),
      ),
    );
  }

  group('CalculatorButton', () {
    group('rendering', () {
      testWidgets('displays the provided label text', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '7',
              onPressed: () {},
            ),
          ),
        );

        expect(find.text('7'), findsOneWidget);
      });

      testWidgets('uses correct font size from AppDimensions', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '5',
              onPressed: () {},
            ),
          ),
        );

        final textWidget = tester.widget<Text>(find.text('5'));
        expect(
          textWidget.style?.fontSize,
          AppDimensions.fontSizeButton,
        );
      });

      testWidgets('has rounded rectangle shape', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '1',
              onPressed: () {},
            ),
          ),
        );

        // Find the Material widget that provides the shape
        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Material),
          ),
        );

        expect(material.borderRadius, isNotNull);
      });
    });

    group('interaction', () {
      testWidgets('calls onPressed when tapped', (tester) async {
        var pressed = false;

        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '9',
              onPressed: () => pressed = true,
            ),
          ),
        );

        await tester.tap(find.byType(CalculatorButton));
        await tester.pump();

        expect(pressed, isTrue);
      });

      testWidgets('does not call onPressed when onPressed is null',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '3',
              onPressed: null,
            ),
          ),
        );

        // Should not throw when tapped with null callback
        await tester.tap(find.byType(CalculatorButton));
        await tester.pump();
      });
    });

    group('button types', () {
      testWidgets('number button has white background and dark text',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '4',
              onPressed: () {},
              type: CalculatorButtonType.number,
            ),
          ),
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Material),
          ),
        );

        expect(material.color, CalculatorColors.light.numberButton);

        final textWidget = tester.widget<Text>(find.text('4'));
        expect(textWidget.style?.color, CalculatorColors.light.textOnNumber);
      });

      testWidgets('operator button has primary background and white text',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '+',
              onPressed: () {},
              type: CalculatorButtonType.operator,
            ),
          ),
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Material),
          ),
        );

        expect(material.color, CalculatorColors.light.operatorButton);

        final textWidget = tester.widget<Text>(find.text('+'));
        expect(textWidget.style?.color, CalculatorColors.light.textOnOperator);
      });

      testWidgets('function button has gray background and dark text',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: 'C',
              onPressed: () {},
              type: CalculatorButtonType.function,
            ),
          ),
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Material),
          ),
        );

        expect(material.color, CalculatorColors.light.functionButton);

        final textWidget = tester.widget<Text>(find.text('C'));
        expect(textWidget.style?.color, CalculatorColors.light.textOnFunction);
      });

      testWidgets('equals button has primary background and white text',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '=',
              onPressed: () {},
              type: CalculatorButtonType.equals,
            ),
          ),
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Material),
          ),
        );

        expect(material.color, CalculatorColors.light.equalsButton);

        final textWidget = tester.widget<Text>(find.text('='));
        expect(textWidget.style?.color, CalculatorColors.light.textOnEquals);
      });

      testWidgets('defaults to number type when not specified',
          (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '8',
              onPressed: () {},
            ),
          ),
        );

        final material = tester.widget<Material>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Material),
          ),
        );

        expect(material.color, CalculatorColors.light.numberButton);
      });
    });

    group('press animation', () {
      testWidgets('scales down when pressed', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '2',
              onPressed: () {},
            ),
          ),
        );

        // Start pressing the button
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(CalculatorButton)),
        );
        await tester.pump();
        await tester.pump(Duration(milliseconds: AppDimensions.animationFast));

        // Find the Transform widget and check scale
        final transform = tester.widget<Transform>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Transform),
          ),
        );

        // The transform matrix should indicate scale of 0.95
        final matrix = transform.transform;
        // Matrix4 scale is in the diagonal: [0,0], [1,1], [2,2]
        expect(matrix.storage[0], AppDimensions.buttonPressedScale);

        // Release the button
        await gesture.up();
        await tester.pumpAndSettle();
      });

      testWidgets('scales back to 1.0 when released', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '6',
              onPressed: () {},
            ),
          ),
        );

        // Press and release
        await tester.tap(find.byType(CalculatorButton));
        await tester.pumpAndSettle();

        // After release and animation completes, scale should be 1.0
        final transform = tester.widget<Transform>(
          find.descendant(
            of: find.byType(CalculatorButton),
            matching: find.byType(Transform),
          ),
        );

        final matrix = transform.transform;
        expect(matrix.storage[0], 1.0);
      });
    });

    group('accessibility', () {
      testWidgets('has semantic label for screen readers', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '5',
              onPressed: () {},
              semanticLabel: 'Five',
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(CalculatorButton));
        expect(semantics.label, contains('Five'));
      });

      testWidgets('is tappable for accessibility', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            CalculatorButton(
              label: '0',
              onPressed: () {},
            ),
          ),
        );

        // Verify button is findable and tappable (accessibility requirement)
        expect(find.byType(CalculatorButton), findsOneWidget);
        await tester.tap(find.byType(CalculatorButton));
        await tester.pump();
      });
    });
  });
}
