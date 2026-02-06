// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/calculator/presentation/widgets/calculator_button.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AccessibilityRepository accessibilityRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    accessibilityRepository = await AccessibilityRepository.create();
  });

  Widget buildTestWidget(Widget child) {
    return BlocProvider(
      create: (_) =>
          AccessibilityCubit(repository: accessibilityRepository),
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(child: child),
        ),
      ),
    );
  }

  group('CalculatorButton responsive', () {
    test('accepts null dimensions (backward compatible)', () {
      // Should compile and construct without dimensions
      const button = CalculatorButton(
        label: '5',
        onPressed: null,
      );
      expect(button.dimensions, isNull);
    });

    testWidgets('uses custom font size from dimensions', (tester) async {
      final dimensions = ResponsiveDimensions(
        fontSizeButton: 20,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorButton(
            label: '5',
            onPressed: () {},
            dimensions: dimensions,
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('5'));
      expect(textWidget.style?.fontSize, 20);
    });

    testWidgets('uses custom button height from dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        buttonHeight: 44,
        buttonMinSize: 44,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorButton(
            label: '3',
            onPressed: () {},
            dimensions: dimensions,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CalculatorButton),
          matching: find.byType(Container),
        ),
      );

      final constraints = container.constraints;
      expect(constraints?.minHeight, 44);
    });

    testWidgets('uses custom border radius from dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions(
        buttonBorderRadius: 8,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorButton(
            label: '1',
            onPressed: () {},
            dimensions: dimensions,
          ),
        ),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(CalculatorButton),
          matching: find.byType(Material),
        ),
      );

      expect(
        material.borderRadius,
        BorderRadius.circular(8),
      );
    });

    testWidgets('falls back to AppDimensions when dimensions is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          CalculatorButton(
            label: '7',
            onPressed: () {},
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('7'));
      expect(
        textWidget.style?.fontSize,
        AppDimensions.fontSizeButton,
      );
    });

    testWidgets('renders correctly with landscape-like small dimensions',
        (tester) async {
      final dimensions = ResponsiveDimensions.fromConstraints(
        width: 667,
        height: 375,
        orientation: Orientation.landscape,
      );

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorButton(
            label: '9',
            onPressed: () {},
            dimensions: dimensions,
          ),
        ),
      );

      // Button should render without overflow
      expect(find.text('9'), findsOneWidget);

      final textWidget = tester.widget<Text>(find.text('9'));
      expect(
        textWidget.style?.fontSize,
        lessThan(AppDimensions.fontSizeButton),
      );
    });

    testWidgets('callback still works with responsive dimensions',
        (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        buildTestWidget(
          CalculatorButton(
            label: '2',
            onPressed: () => pressed = true,
            dimensions: ResponsiveDimensions(
              fontSizeButton: 20,
              buttonHeight: 44,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CalculatorButton));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
