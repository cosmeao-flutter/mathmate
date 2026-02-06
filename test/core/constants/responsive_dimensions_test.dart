import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';
import 'package:math_mate/core/constants/responsive_dimensions.dart';

void main() {
  group('ResponsiveDimensions', () {
    group('default constructor', () {
      test('uses AppDimensions values', () {
        const dimensions = ResponsiveDimensions();

        expect(dimensions.buttonHeight, AppDimensions.buttonHeight);
        expect(dimensions.buttonMinSize, AppDimensions.buttonMinSize);
        expect(dimensions.buttonSpacing, AppDimensions.buttonSpacing);
        expect(dimensions.buttonBorderRadius, AppDimensions.buttonBorderRadius);
        expect(dimensions.fontSizeResult, AppDimensions.fontSizeResult);
        expect(dimensions.fontSizeExpression, AppDimensions.fontSizeExpression);
        expect(dimensions.fontSizeButton, AppDimensions.fontSizeButton);
        expect(dimensions.fontSizeError, AppDimensions.fontSizeError);
        expect(dimensions.displayPadding, AppDimensions.displayPadding);
        expect(dimensions.keypadPadding, AppDimensions.spacingMd);
      });

      test('defaults to portrait orientation', () {
        const dimensions = ResponsiveDimensions();

        expect(dimensions.orientation, Orientation.portrait);
        expect(dimensions.isLandscape, isFalse);
      });
    });

    group('fromConstraints - portrait', () {
      test('returns scale 1.0 for reference width 390', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 390,
          height: 844,
          orientation: Orientation.portrait,
        );

        expect(dimensions.buttonHeight, AppDimensions.buttonHeight);
        expect(dimensions.fontSizeButton, AppDimensions.fontSizeButton);
        expect(dimensions.fontSizeResult, AppDimensions.fontSizeResult);
        expect(dimensions.buttonSpacing, AppDimensions.buttonSpacing);
        expect(dimensions.orientation, Orientation.portrait);
        expect(dimensions.isLandscape, isFalse);
      });

      test('scales down for iPhone SE width 375', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 375,
          height: 667,
          orientation: Orientation.portrait,
        );

        // Scale factor = 375 / 390 ≈ 0.962
        final expectedScale = 375 / 390;
        expect(
          dimensions.buttonHeight,
          moreOrLessEquals(AppDimensions.buttonHeight * expectedScale),
        );
        expect(
          dimensions.fontSizeButton,
          moreOrLessEquals(AppDimensions.fontSizeButton * expectedScale),
        );
        expect(
          dimensions.fontSizeResult,
          moreOrLessEquals(AppDimensions.fontSizeResult * expectedScale),
        );
      });

      test('scales up for iPhone Pro Max width 430', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 430,
          height: 932,
          orientation: Orientation.portrait,
        );

        // Scale factor = 430 / 390 ≈ 1.103
        final expectedScale = 430 / 390;
        expect(
          dimensions.buttonHeight,
          moreOrLessEquals(AppDimensions.buttonHeight * expectedScale),
        );
        expect(
          dimensions.fontSizeButton,
          moreOrLessEquals(AppDimensions.fontSizeButton * expectedScale),
        );
      });

      test('all dimensions scale proportionally', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 375,
          height: 667,
          orientation: Orientation.portrait,
        );

        final expectedScale = 375 / 390;
        expect(
          dimensions.fontSizeExpression,
          moreOrLessEquals(AppDimensions.fontSizeExpression * expectedScale),
        );
        expect(
          dimensions.fontSizeError,
          moreOrLessEquals(AppDimensions.fontSizeError * expectedScale),
        );
        expect(
          dimensions.displayPadding,
          moreOrLessEquals(AppDimensions.displayPadding * expectedScale),
        );
        expect(
          dimensions.keypadPadding,
          moreOrLessEquals(AppDimensions.spacingMd * expectedScale),
        );
        expect(
          dimensions.buttonBorderRadius,
          moreOrLessEquals(AppDimensions.buttonBorderRadius * expectedScale),
        );
      });
    });

    group('fromConstraints - clamping', () {
      test('clamps scale factor to minimum 0.75', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 200,
          height: 400,
          orientation: Orientation.portrait,
        );

        // 200 / 390 = 0.513 → clamped to 0.75
        expect(
          dimensions.buttonHeight,
          moreOrLessEquals(AppDimensions.buttonHeight * 0.75),
        );
        expect(
          dimensions.fontSizeButton,
          moreOrLessEquals(AppDimensions.fontSizeButton * 0.75),
        );
      });

      test('clamps scale factor to maximum 1.2', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 600,
          height: 1000,
          orientation: Orientation.portrait,
        );

        // 600 / 390 = 1.538 → clamped to 1.2
        expect(
          dimensions.buttonHeight,
          moreOrLessEquals(AppDimensions.buttonHeight * 1.2),
        );
        expect(
          dimensions.fontSizeButton,
          moreOrLessEquals(AppDimensions.fontSizeButton * 1.2),
        );
      });
    });

    group('fromConstraints - landscape', () {
      test('uses height-based scale factor in landscape', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 844,
          height: 390,
          orientation: Orientation.landscape,
        );

        // Landscape scale = height / 390 = 1.0
        // But landscape applies extra reductions
        expect(dimensions.orientation, Orientation.landscape);
        expect(dimensions.isLandscape, isTrue);
      });

      test('reduces button height by 0.7 in landscape', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 844,
          height: 390,
          orientation: Orientation.landscape,
        );

        // Scale = 390/390 = 1.0, then buttonHeight × 0.7
        expect(
          dimensions.buttonHeight,
          moreOrLessEquals(AppDimensions.buttonHeight * 0.7),
        );
      });

      test('reduces button spacing by 0.6 in landscape', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 844,
          height: 390,
          orientation: Orientation.landscape,
        );

        // Scale = 1.0, then buttonSpacing × 0.6
        expect(
          dimensions.buttonSpacing,
          moreOrLessEquals(AppDimensions.buttonSpacing * 0.6),
        );
      });

      test('reduces keypad padding by 0.6 in landscape', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 844,
          height: 390,
          orientation: Orientation.landscape,
        );

        expect(
          dimensions.keypadPadding,
          moreOrLessEquals(AppDimensions.spacingMd * 0.6),
        );
      });

      test('scales down for iPhone SE landscape', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 667,
          height: 375,
          orientation: Orientation.landscape,
        );

        // Scale = 375 / 390 ≈ 0.962
        // Button height = 64 × 0.962 × 0.7 ≈ 43.08 → floored to 44
        expect(dimensions.buttonHeight, 44);
      });

      test('font sizes scale but without extra landscape reduction', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 844,
          height: 390,
          orientation: Orientation.landscape,
        );

        // Font sizes only get the base scale (1.0), not the 0.7 button reduction
        expect(
          dimensions.fontSizeButton,
          moreOrLessEquals(AppDimensions.fontSizeButton),
        );
        expect(
          dimensions.fontSizeResult,
          moreOrLessEquals(AppDimensions.fontSizeResult),
        );
      });
    });

    group('accessibility floor', () {
      test('buttonHeight never goes below 44dp', () {
        // Extreme landscape: small phone, height 300
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 600,
          height: 300,
          orientation: Orientation.landscape,
        );

        // Scale = 300/390 = 0.769 → clamped to 0.769
        // buttonHeight = 64 × 0.769 × 0.7 = 34.5 → floored to 44
        expect(dimensions.buttonHeight, greaterThanOrEqualTo(44));
      });

      test('buttonMinSize never goes below 44dp', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 200,
          height: 200,
          orientation: Orientation.landscape,
        );

        expect(dimensions.buttonMinSize, greaterThanOrEqualTo(44));
      });
    });

    group('edge cases', () {
      test('very small constraints produce valid dimensions', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 100,
          height: 100,
          orientation: Orientation.portrait,
        );

        expect(dimensions.buttonHeight, greaterThan(0));
        expect(dimensions.fontSizeButton, greaterThan(0));
        expect(dimensions.fontSizeResult, greaterThan(0));
        expect(dimensions.buttonSpacing, greaterThan(0));
        expect(dimensions.displayPadding, greaterThan(0));
      });

      test('very large constraints produce valid dimensions', () {
        final dimensions = ResponsiveDimensions.fromConstraints(
          width: 1200,
          height: 2000,
          orientation: Orientation.portrait,
        );

        expect(dimensions.buttonHeight, greaterThan(0));
        expect(dimensions.fontSizeButton, greaterThan(0));
        // Should be clamped to 1.2x
        expect(
          dimensions.buttonHeight,
          moreOrLessEquals(AppDimensions.buttonHeight * 1.2),
        );
      });
    });
  });
}
