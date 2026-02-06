// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_keypad.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AccessibilityRepository accessibilityRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    accessibilityRepository =
        await AccessibilityRepository.create();
  });

  Widget buildTestWidget(Widget child) {
    return BlocProvider(
      create: (_) => AccessibilityCubit(
        repository: accessibilityRepository,
      ),
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  CalculatorKeypad buildKeypad({
    ResponsiveDimensions? dimensions,
  }) {
    return CalculatorKeypad(
      onDigitPressed: (_) {},
      onOperatorPressed: (_) {},
      onEqualsPressed: () {},
      onBackspacePressed: () {},
      onAllClearPressed: () {},
      onDecimalPressed: () {},
      onPercentPressed: () {},
      onPlusMinusPressed: () {},
      onParenthesisPressed: ({required bool isOpen}) {},
      dimensions: dimensions,
    );
  }

  group('CalculatorKeypad responsive', () {
    testWidgets('accepts null dimensions (backward compatible)',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(buildKeypad()),
      );

      // All 24 buttons should render
      expect(
        find.byType(CalculatorButton),
        findsNWidgets(24),
      );
    });

    testWidgets('forwards dimensions to CalculatorButton children',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        fontSizeButton: 20,
        buttonHeight: 44,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      // Check that buttons received the custom dimensions
      final buttons = tester.widgetList<CalculatorButton>(
        find.byType(CalculatorButton),
      );

      for (final button in buttons) {
        expect(button.dimensions, dimensions);
      }
    });

    testWidgets('uses custom button spacing between rows',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        buttonSpacing: 6,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      // Find SizedBox widgets used as row spacers within keypad
      final sizedBoxes = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(CalculatorKeypad),
          matching: find.byType(SizedBox),
        ),
      );

      // The row spacers should use the custom spacing
      final rowSpacers = sizedBoxes.where(
        (sb) => sb.height == 6,
      );
      // 5 spacers between 6 rows
      expect(rowSpacers.length, 5);
    });

    testWidgets('uses custom keypad padding', (tester) async {
      final dimensions = ResponsiveDimensions(
        keypadPadding: 6,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(CalculatorKeypad),
          matching: find.byType(Padding).first,
        ),
      );
      expect(
        padding.padding,
        const EdgeInsets.all(6),
      );
    });

    testWidgets('all 24 buttons render with custom dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 667,
        height: 375,
        orientation: Orientation.landscape,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      expect(
        find.byType(CalculatorButton),
        findsNWidgets(24),
      );
    });

    testWidgets(
        'digit callbacks work with responsive dimensions',
        (tester) async {
      String? pressedDigit;

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorKeypad(
            onDigitPressed: (d) => pressedDigit = d,
            onOperatorPressed: (_) {},
            onEqualsPressed: () {},
            onBackspacePressed: () {},
            onAllClearPressed: () {},
            onDecimalPressed: () {},
            onPercentPressed: () {},
            onPlusMinusPressed: () {},
            onParenthesisPressed: ({required bool isOpen}) {},
            dimensions: ResponsiveDimensions(
              fontSizeButton: 20,
              buttonHeight: 44,
            ),
          ),
        ),
      );

      await tester.tap(find.text('5'));
      await tester.pump();

      expect(pressedDigit, '5');
    });

    testWidgets(
        'falls back to AppDimensions spacing when no dimensions',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(buildKeypad()),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(CalculatorKeypad),
          matching: find.byType(SizedBox),
        ),
      );

      final rowSpacers = sizedBoxes.where(
        (sb) => sb.height == AppDimensions.buttonSpacing,
      );
      // 5 spacers between 6 rows (portrait default)
      expect(rowSpacers.length, 5);
    });

    testWidgets('landscape renders 4 rows (3 spacers)',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 844,
        height: 390,
        orientation: Orientation.landscape,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(CalculatorKeypad),
          matching: find.byType(SizedBox),
        ),
      );

      // 3 spacers between 4 rows in landscape
      final rowSpacers = sizedBoxes.where(
        (sb) =>
            sb.height != null &&
            sb.height == dimensions.buttonSpacing,
      );
      expect(rowSpacers.length, 3);
    });

    testWidgets('portrait still renders 6 rows (5 spacers)',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 390,
        height: 844,
        orientation: Orientation.portrait,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(CalculatorKeypad),
          matching: find.byType(SizedBox),
        ),
      );

      final rowSpacers = sizedBoxes.where(
        (sb) =>
            sb.height != null &&
            sb.height == dimensions.buttonSpacing,
      );
      // 5 spacers between 6 rows in portrait
      expect(rowSpacers.length, 5);
    });

    testWidgets('landscape first row has AC, backspace, 7, 8, 9, ÷',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 844,
        height: 390,
        orientation: Orientation.landscape,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      // Get all buttons in order
      final buttons = tester.widgetList<CalculatorButton>(
        find.byType(CalculatorButton),
      ).toList();

      // First 6 buttons should be the landscape first row
      expect(buttons[0].label, 'AC');
      expect(buttons[1].label, '⌫');
      expect(buttons[2].label, '7');
      expect(buttons[3].label, '8');
      expect(buttons[4].label, '9');
      expect(buttons[5].label, '÷');
    });

    testWidgets('landscape last row has 🕐, ⚙, 0, ., =, +',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 844,
        height: 390,
        orientation: Orientation.landscape,
      );

      await tester.pumpWidget(
        buildTestWidget(buildKeypad(dimensions: dimensions)),
      );

      final buttons = tester.widgetList<CalculatorButton>(
        find.byType(CalculatorButton),
      ).toList();

      // Last 6 buttons (indices 18-23) should be landscape last row
      // Row 4: history, settings, 0, ., =, +
      expect(buttons[18].label, '');  // history placeholder
      expect(buttons[19].label, '');  // settings placeholder
      expect(buttons[20].label, '0');
      expect(buttons[21].label, '.');
      expect(buttons[22].label, '=');
      expect(buttons[23].label, '+');
    });
  });
}
