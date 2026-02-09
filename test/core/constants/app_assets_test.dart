import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/constants/app_assets.dart';

void main() {
  group('AppAssets', () {
    test('emptyHistory has correct path', () {
      expect(
        AppAssets.emptyHistory,
        'assets/images/empty_history.png',
      );
    });
  });
}
