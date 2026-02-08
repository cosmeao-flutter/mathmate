import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:math_mate/core/services/app_logger.dart';

/// Captures log output for verification in tests.
class _TestOutput extends LogOutput {
  final List<OutputEvent> events = [];

  @override
  void output(OutputEvent event) {
    events.add(event);
  }
}

void main() {
  group('AppLogger', () {
    late _TestOutput testOutput;
    late AppLogger logger;

    setUp(() {
      testOutput = _TestOutput();
      logger = AppLogger(
        logger: Logger(
          printer: SimplePrinter(printTime: false),
          output: testOutput,
          level: Level.all,
        ),
      );
    });

    test('debug logs at debug level', () {
      logger.debug('test debug message');

      expect(testOutput.events, hasLength(1));
      expect(testOutput.events.first.level, Level.debug);
    });

    test('info logs at info level', () {
      logger.info('test info message');

      expect(testOutput.events, hasLength(1));
      expect(testOutput.events.first.level, Level.info);
    });

    test('warning logs at warning level', () {
      logger.warning('test warning');

      expect(testOutput.events, hasLength(1));
      expect(testOutput.events.first.level, Level.warning);
    });

    test('error logs at error level', () {
      logger.error('test error');

      expect(testOutput.events, hasLength(1));
      expect(testOutput.events.first.level, Level.error);
    });

    test('error accepts exception and stack trace', () {
      final exception = Exception('disk full');
      final stackTrace = StackTrace.current;

      logger.error('save failed', exception, stackTrace);

      expect(testOutput.events, hasLength(1));
      expect(testOutput.events.first.level, Level.error);
    });

    test('warning accepts exception and stack trace', () {
      final exception = Exception('timeout');
      final stackTrace = StackTrace.current;

      logger.warning('slow operation', exception, stackTrace);

      expect(testOutput.events, hasLength(1));
      expect(testOutput.events.first.level, Level.warning);
    });
  });
}
