// ignore_for_file: avoid_print

/// Generates placeholder PNG images for MathMate asset management.
///
/// This script uses the `image` package (pure Dart) to programmatically
/// draw simple placeholder illustrations. No design tools needed.
///
/// Run with:
///   dart run tool/generate_placeholder_images.dart
///
/// Generates:
///   assets/images/empty_history.png       (200x200 — 1x)
///   assets/images/2.0x/empty_history.png  (400x400 — 2x)
///   assets/images/3.0x/empty_history.png  (600x600 — 3x)
library;

import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;

/// Draws a clock-like "no history" illustration at the given [size].
///
/// The image has a transparent background with a grey clock outline,
/// hour/minute hands, and a small "x" overlay to convey "no history."
img.Image drawEmptyHistory(int size) {
  final image = img.Image(width: size, height: size, numChannels: 4);

  // Transparent background
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));

  final cx = size ~/ 2;
  final cy = size ~/ 2;
  final radius = (size * 0.38).toInt();
  final grey = img.ColorRgba8(158, 158, 158, 180); // onSurfaceVariant-like
  final lightGrey = img.ColorRgba8(158, 158, 158, 100);
  final thickness = max(2, size ~/ 50);

  // Draw clock circle outline
  _drawCircleOutline(image, cx, cy, radius, grey, thickness);

  // Draw hour marks (12 ticks around the circle)
  for (var i = 0; i < 12; i++) {
    final angle = (i * 30 - 90) * pi / 180;
    final innerR = radius * 0.85;
    final outerR = radius * 0.95;
    final x1 = cx + (innerR * cos(angle)).toInt();
    final y1 = cy + (innerR * sin(angle)).toInt();
    final x2 = cx + (outerR * cos(angle)).toInt();
    final y2 = cy + (outerR * sin(angle)).toInt();
    img.drawLine(image, x1: x1, y1: y1, x2: x2, y2: y2, color: grey,
        thickness: thickness);
  }

  // Draw hour hand (pointing to 10 o'clock)
  final hourAngle = (300 - 90) * pi / 180;
  final hx = cx + (radius * 0.5 * cos(hourAngle)).toInt();
  final hy = cy + (radius * 0.5 * sin(hourAngle)).toInt();
  img.drawLine(image, x1: cx, y1: cy, x2: hx, y2: hy, color: grey,
      thickness: thickness + 1);

  // Draw minute hand (pointing to 2 o'clock)
  final minuteAngle = (60 - 90) * pi / 180;
  final mx = cx + (radius * 0.7 * cos(minuteAngle)).toInt();
  final my = cy + (radius * 0.7 * sin(minuteAngle)).toInt();
  img.drawLine(image, x1: cx, y1: cy, x2: mx, y2: my, color: grey,
      thickness: thickness);

  // Draw center dot
  img.fillCircle(image, x: cx, y: cy, radius: thickness + 1, color: grey);

  // Draw a diagonal slash through the clock (conveying "no history")
  final slashOffset = (radius * 1.15).toInt();
  img.drawLine(
    image,
    x1: cx - slashOffset,
    y1: cy + slashOffset,
    x2: cx + slashOffset,
    y2: cy - slashOffset,
    color: lightGrey,
    thickness: thickness + 2,
  );

  return image;
}

/// Draws a circle outline by plotting points around the circumference.
void _drawCircleOutline(
  img.Image image,
  int cx,
  int cy,
  int radius,
  img.Color color,
  int thickness,
) {
  // Draw multiple concentric circles for thickness
  for (var t = 0; t < thickness; t++) {
    final r = radius - thickness ~/ 2 + t;
    final steps = max(360, r * 4);
    for (var i = 0; i < steps; i++) {
      final angle = (i * 2 * pi) / steps;
      final x = cx + (r * cos(angle)).round();
      final y = cy + (r * sin(angle)).round();
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        image.setPixelRgba(x, y, color.r.toInt(), color.g.toInt(),
            color.b.toInt(), color.a.toInt());
      }
    }
  }
}

void main() {
  // Generate at 1x, 2x, 3x resolutions
  const sizes = {
    200: 'assets/images/empty_history.png',
    400: 'assets/images/2.0x/empty_history.png',
    600: 'assets/images/3.0x/empty_history.png',
  };

  for (final entry in sizes.entries) {
    final image = drawEmptyHistory(entry.key);
    final file = File(entry.value);
    file.createSync(recursive: true);
    file.writeAsBytesSync(img.encodePng(image));
    print('Generated: ${entry.value} (${entry.key}x${entry.key})');
  }

  print('Done! Generated ${sizes.length} placeholder images.');
}
