import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

// Import the generator to test its drawAppIcon function.
// ignore: avoid_relative_lib_imports
import '../../tool/generate_icon.dart';

void main() {
  group('App icon generator', () {
    test('generates a 1024x1024 image', () {
      final icon = drawAppIcon(1024);
      expect(icon.width, 1024);
      expect(icon.height, 1024);
    });

    test('generated image has blue background', () {
      final icon = drawAppIcon(1024);
      // Check a background area (top-center, inside rounded rect) is blue
      final pixel = icon.getPixel(512, 50);
      expect(pixel.r.toInt(), 0x21);
      expect(pixel.g.toInt(), 0x96);
      expect(pixel.b.toInt(), 0xF3);
    });

    test('generated icon file exists at expected path', () {
      final file = File('assets/icon/mathmate_icon.png');
      expect(file.existsSync(), isTrue);

      // Verify it's a valid PNG by decoding
      final bytes = file.readAsBytesSync();
      final decoded = img.decodePng(bytes);
      expect(decoded, isNotNull);
      expect(decoded!.width, 1024);
      expect(decoded.height, 1024);
    });
  });
}
