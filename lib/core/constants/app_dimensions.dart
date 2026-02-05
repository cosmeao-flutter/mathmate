/// App dimensions and spacing constants for MathMate calculator.
///
/// This class contains all the size and spacing values used in the app.
/// Using constants instead of magic numbers:
/// - Makes the code more readable
/// - Ensures consistency across widgets
/// - Makes it easy to adjust the entire app's sizing
///
/// All values are in logical pixels (dp on Android, points on iOS).
abstract class AppDimensions {
  // ============================================================
  // SPACING
  // ============================================================

  /// Extra small spacing (4dp) - tight spacing between related elements.
  static const double spacingXs = 4;

  /// Small spacing (8dp) - default spacing between elements.
  static const double spacingSm = 8;

  /// Medium spacing (12dp) - spacing between button rows.
  static const double spacingMd = 12;

  /// Large spacing (16dp) - section padding.
  static const double spacingLg = 16;

  /// Extra large spacing (24dp) - major section breaks.
  static const double spacingXl = 24;

  /// Extra extra large spacing (32dp) - top/bottom margins.
  static const double spacingXxl = 32;

  // ============================================================
  // BUTTON DIMENSIONS
  // ============================================================

  /// Minimum button size for touch targets (48dp per accessibility guidelines).
  static const double buttonMinSize = 48;

  /// Default button height.
  static const double buttonHeight = 64;

  /// Button border radius for rounded rectangles.
  static const double buttonBorderRadius = 16;

  /// Spacing between buttons in the keypad grid.
  static const double buttonSpacing = 12;

  /// Button elevation (shadow depth).
  static const double buttonElevation = 2;

  // ============================================================
  // DISPLAY DIMENSIONS
  // ============================================================

  /// Display area padding.
  static const double displayPadding = 24;

  /// Display area minimum height.
  static const double displayMinHeight = 120;

  // ============================================================
  // TYPOGRAPHY SIZES
  // ============================================================

  /// Main result text size (large).
  static const double fontSizeResult = 56;

  /// Expression text size (smaller, above result).
  static const double fontSizeExpression = 24;

  /// Button text size.
  static const double fontSizeButton = 28;

  /// Error message text size.
  static const double fontSizeError = 14;

  // ============================================================
  // ANIMATION DURATIONS (in milliseconds)
  // ============================================================

  /// Fast animation (150ms) - button press feedback.
  static const int animationFast = 150;

  /// Normal animation (250ms) - standard transitions.
  static const int animationNormal = 250;

  /// Slow animation (350ms) - smooth, deliberate transitions.
  static const int animationSlow = 350;

  // ============================================================
  // BUTTON SCALE ANIMATION
  // ============================================================

  /// Scale factor when button is pressed (0.95 = 95% of original size).
  static const double buttonPressedScale = 0.95;

  // ============================================================
  // KEYPAD LAYOUT
  // ============================================================

  /// Number of columns in the keypad grid.
  static const int keypadColumns = 4;

  /// Aspect ratio for regular buttons (width:height).
  static const double buttonAspectRatio = 1;

  // ============================================================
  // SAFE AREA / SCREEN
  // ============================================================

  /// Horizontal screen padding.
  static const double screenPaddingHorizontal = 16;

  /// Vertical screen padding.
  static const double screenPaddingVertical = 8;

  // ============================================================
  // MAXIMUM VALUES
  // ============================================================

  /// Maximum digits to display before switching to scientific notation.
  static const int maxDisplayDigits = 15;

  /// Minimum font size for result (when shrinking for long numbers).
  static const double fontSizeResultMin = 32;
}
