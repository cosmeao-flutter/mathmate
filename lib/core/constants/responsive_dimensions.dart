import 'package:flutter/widgets.dart';
import 'package:math_mate/core/constants/app_dimensions.dart';

/// Computed responsive dimensions scaled from [AppDimensions] reference values.
///
/// This class takes screen constraints and orientation, then computes
/// proportionally scaled dimensions for all UI elements.
///
/// **Scaling logic:**
/// - Reference device: iPhone 14 (390dp width)
/// - Portrait: scale = screenWidth / 390, clamped to [0.75, 1.2]
/// - Landscape: scale = screenHeight / 390, clamped to [0.75, 1.2]
///   - Button height further reduced by 0.7 (vertical space is limited)
///   - Spacing further reduced by 0.6
/// - Button height enforces a 44dp accessibility floor
///
/// Example usage:
/// ```dart
/// // In a LayoutBuilder
/// final dimensions = ResponsiveDimensions.fromConstraints(
///   width: constraints.maxWidth,
///   height: constraints.maxHeight,
///   orientation: MediaQuery.orientationOf(context),
/// );
///
/// // Pass to widgets
/// CalculatorButton(dimensions: dimensions, ...)
/// ```
class ResponsiveDimensions {
  /// Creates dimensions with [AppDimensions] defaults (no scaling).
  ///
  /// Used when no responsive context is available (e.g., in tests).
  const ResponsiveDimensions({
    this.buttonHeight = AppDimensions.buttonHeight,
    this.buttonMinSize = AppDimensions.buttonMinSize,
    this.buttonSpacing = AppDimensions.buttonSpacing,
    this.buttonBorderRadius = AppDimensions.buttonBorderRadius,
    this.fontSizeResult = AppDimensions.fontSizeResult,
    this.fontSizeExpression = AppDimensions.fontSizeExpression,
    this.fontSizeButton = AppDimensions.fontSizeButton,
    this.fontSizeError = AppDimensions.fontSizeError,
    this.displayPadding = AppDimensions.displayPadding,
    this.keypadPadding = AppDimensions.spacingMd,
    this.orientation = Orientation.portrait,
  });

  /// Computes responsive dimensions from screen constraints.
  ///
  /// [width] and [height] come from a [LayoutBuilder]'s constraints.
  /// [orientation] comes from [MediaQuery.orientationOf].
  factory ResponsiveDimensions.fromConstraints({
    required double width,
    required double height,
    required Orientation orientation,
  }) {
    const referenceWidth = 390.0;
    const minScale = 0.75;
    const maxScale = 1.2;
    const landscapeButtonFactor = 0.7;
    const landscapeSpacingFactor = 0.6;
    const minButtonHeight = 44.0;

    // Compute base scale from width (portrait) or height (landscape)
    final rawScale = orientation == Orientation.portrait
        ? width / referenceWidth
        : height / referenceWidth;
    final scale = rawScale.clamp(minScale, maxScale);

    // In landscape, buttons and spacing need extra reduction
    final isLandscape = orientation == Orientation.landscape;
    final buttonScale = isLandscape ? scale * landscapeButtonFactor : scale;
    final spacingScale = isLandscape ? scale * landscapeSpacingFactor : scale;

    // Compute button height with accessibility floor
    final computedButtonHeight =
        (AppDimensions.buttonHeight * buttonScale).clamp(minButtonHeight, 200);
    final computedButtonMinSize =
        (AppDimensions.buttonMinSize * buttonScale).clamp(minButtonHeight, 200);

    return ResponsiveDimensions(
      buttonHeight: computedButtonHeight.toDouble(),
      buttonMinSize: computedButtonMinSize.toDouble(),
      buttonSpacing: AppDimensions.buttonSpacing * spacingScale,
      buttonBorderRadius: AppDimensions.buttonBorderRadius * scale,
      fontSizeResult: AppDimensions.fontSizeResult * scale,
      fontSizeExpression: AppDimensions.fontSizeExpression * scale,
      fontSizeButton: AppDimensions.fontSizeButton * scale,
      fontSizeError: AppDimensions.fontSizeError * scale,
      displayPadding: AppDimensions.displayPadding * spacingScale,
      keypadPadding: AppDimensions.spacingMd * spacingScale,
      orientation: orientation,
    );
  }

  /// Minimum button height (scaled).
  final double buttonHeight;

  /// Minimum button touch target size (scaled).
  final double buttonMinSize;

  /// Spacing between buttons in the keypad (scaled).
  final double buttonSpacing;

  /// Button corner radius (scaled).
  final double buttonBorderRadius;

  /// Result text size (scaled).
  final double fontSizeResult;

  /// Expression text size (scaled).
  final double fontSizeExpression;

  /// Button label text size (scaled).
  final double fontSizeButton;

  /// Error message text size (scaled).
  final double fontSizeError;

  /// Display area padding (scaled).
  final double displayPadding;

  /// Keypad outer padding (scaled).
  final double keypadPadding;

  /// Current device orientation.
  final Orientation orientation;

  /// Whether the device is in landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;
}
