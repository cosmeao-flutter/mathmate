import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_colors.dart';

/// Tests that splash screen color values stay in sync with app theme.
///
/// The splash screen colors are configured in `flutter_native_splash.yaml`
/// and must match the app's theme colors so there is no visible "flash"
/// when transitioning from the native splash to the Flutter-rendered app.
void main() {
  group('Splash screen colors', () {
    test('primary color matches splash config (#2196F3)', () {
      // flutter_native_splash.yaml: color: "#2196F3"
      expect(AppColors.primary.r, 0x21 / 255.0);
      expect(AppColors.primary.g, 0x96 / 255.0);
      expect(AppColors.primary.b, 0xF3 / 255.0);
    });

    test('dark background matches splash dark config (#121212)', () {
      // flutter_native_splash.yaml: color_dark: "#121212"
      expect(AppColors.backgroundDark.r, 0x12 / 255.0);
      expect(AppColors.backgroundDark.g, 0x12 / 255.0);
      expect(AppColors.backgroundDark.b, 0x12 / 255.0);
    });
  });
}
