// ignore_for_file: avoid_print

/// Generates the MathMate app icon programmatically using the `image` package.
///
/// This script draws a 1024x1024 PNG icon with:
/// - A blue (#2196F3) rounded rectangle background
/// - A white "M+" symbol in the center
///
/// Run with:
///   dart run tool/generate_icon.dart
///
/// Output:
///   assets/icon/mathmate_icon.png (1024x1024)
///
/// After generating, deploy to all platforms with:
///   dart run flutter_launcher_icons
library;

import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;

/// MathMate brand blue (#2196F3).
const int _blueR = 0x21;
const int _blueG = 0x96;
const int _blueB = 0xF3;

/// Draws the MathMate app icon at the given [size].
img.Image drawAppIcon(int size) {
  final image = img.Image(width: size, height: size);

  // Fill with blue background
  img.fill(image, color: img.ColorRgba8(_blueR, _blueG, _blueB, 255));

  // Draw rounded corners by cutting them with transparency
  _roundCorners(image, size, (size * 0.18).toInt());

  // Draw "M+" text
  _drawM(image, size);
  _drawPlus(image, size);

  return image;
}

/// Rounds the corners of the image by making corner pixels transparent.
void _roundCorners(img.Image image, int size, int radius) {
  final corners = [
    (0, 0), // top-left
    (size - radius, 0), // top-right
    (0, size - radius), // bottom-left
    (size - radius, size - radius), // bottom-right
  ];

  final transparent = img.ColorRgba8(_blueR, _blueG, _blueB, 255);

  for (final corner in corners) {
    final cx = corner.$1 + (corner.$1 == 0 ? radius : 0);
    final cy = corner.$2 + (corner.$2 == 0 ? radius : 0);

    for (var x = corner.$1; x < corner.$1 + radius; x++) {
      for (var y = corner.$2; y < corner.$2 + radius; y++) {
        final dx = (x - cx).abs();
        final dy = (y - cy).abs();
        if (sqrt(dx * dx + dy * dy) > radius) {
          image.setPixelRgba(x, y, transparent.r.toInt(), transparent.g.toInt(),
              transparent.b.toInt(), 0);
        }
      }
    }
  }
}

/// Draws a bold "M" letter on the left-center area.
void _drawM(img.Image image, int size) {
  final white = img.ColorRgba8(255, 255, 255, 255);
  final strokeWidth = (size * 0.06).toInt();

  // M dimensions — shifted left to make room for "+"
  final mLeft = (size * 0.15).toInt();
  final mRight = (size * 0.58).toInt();
  final mTop = (size * 0.25).toInt();
  final mBottom = (size * 0.75).toInt();
  final mMid = (mLeft + mRight) ~/ 2;
  final mMidY = (size * 0.50).toInt();

  // Left vertical stroke
  _drawThickLine(image, mLeft, mTop, mLeft, mBottom, strokeWidth, white);

  // Left diagonal (top-left to center-mid)
  _drawThickLine(image, mLeft, mTop, mMid, mMidY, strokeWidth, white);

  // Right diagonal (center-mid to top-right)
  _drawThickLine(image, mMid, mMidY, mRight, mTop, strokeWidth, white);

  // Right vertical stroke
  _drawThickLine(image, mRight, mTop, mRight, mBottom, strokeWidth, white);
}

/// Draws a "+" symbol on the right side.
void _drawPlus(img.Image image, int size) {
  final white = img.ColorRgba8(255, 255, 255, 255);
  final strokeWidth = (size * 0.05).toInt();

  final centerX = (size * 0.77).toInt();
  final centerY = (size * 0.50).toInt();
  final armLength = (size * 0.12).toInt();

  // Horizontal line
  _drawThickLine(
    image,
    centerX - armLength,
    centerY,
    centerX + armLength,
    centerY,
    strokeWidth,
    white,
  );

  // Vertical line
  _drawThickLine(
    image,
    centerX,
    centerY - armLength,
    centerX,
    centerY + armLength,
    strokeWidth,
    white,
  );
}

/// Draws a line with thickness using multiple offset lines.
void _drawThickLine(
  img.Image image,
  int x1,
  int y1,
  int x2,
  int y2,
  int thickness,
  img.Color color,
) {
  final half = thickness ~/ 2;
  for (var dx = -half; dx <= half; dx++) {
    for (var dy = -half; dy <= half; dy++) {
      img.drawLine(
        image,
        x1: x1 + dx,
        y1: y1 + dy,
        x2: x2 + dx,
        y2: y2 + dy,
        color: color,
      );
    }
  }
}

void main() {
  const size = 1024;
  const outputPath = 'assets/icon/mathmate_icon.png';

  print('Generating MathMate app icon ($size x $size)...');
  final icon = drawAppIcon(size);

  final file = File(outputPath);
  file.createSync(recursive: true);
  file.writeAsBytesSync(img.encodePng(icon));

  print('Saved to: $outputPath');
  print('File size: ${file.lengthSync()} bytes');
  print('');
  print('Next step: dart run flutter_launcher_icons');
}
