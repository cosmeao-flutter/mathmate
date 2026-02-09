/// Font family constants for MathMate.
///
/// Custom fonts are declared in `pubspec.yaml` under the `fonts:` section
/// and bundled with the app at build time. Flutter loads them from the
/// `assets/fonts/` directory.
///
/// Usage:
/// ```dart
/// TextStyle(fontFamily: AppFonts.calculatorDisplay)
/// ```
abstract class AppFonts {
  /// JetBrains Mono — monospace font for the calculator display.
  ///
  /// Provides tabular (fixed-width) digits so numbers stay aligned.
  /// Two weights are bundled:
  /// - Light (300) for the expression line
  /// - Regular (400) for the result line
  static const String calculatorDisplay = 'JetBrainsMono';
}
