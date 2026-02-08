import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_mate/core/error/error_boundary.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockAppLogger mockLogger;

  setUp(() {
    mockLogger = MockAppLogger();
    when(() => mockLogger.error(any(), any(), any()))
        .thenReturn(null);
  });

  group('setupErrorBoundaries', () {
    late FlutterExceptionHandler? originalOnError;

    setUp(() {
      originalOnError = FlutterError.onError;
    });

    tearDown(() {
      FlutterError.onError = originalOnError;
    });

    test('sets FlutterError.onError', () {
      setupErrorBoundaries(mockLogger);

      expect(FlutterError.onError, isNotNull);
    });

    test(
      'FlutterError.onError logs via AppLogger',
      () {
        setupErrorBoundaries(mockLogger);

        final details = FlutterErrorDetails(
          exception: Exception('test error'),
          stack: StackTrace.current,
        );
        FlutterError.onError!(details);

        verify(
          () => mockLogger.error(any(), any(), any()),
        ).called(1);
      },
    );
  });
}
