import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_fonts.dart';

void main() {
  group('AppFonts', () {
    test('calculatorDisplay is JetBrainsMono', () {
      expect(AppFonts.calculatorDisplay, 'JetBrainsMono');
    });
  });
}
