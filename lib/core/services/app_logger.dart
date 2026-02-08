import 'package:logger/logger.dart';

/// Application-wide structured logger.
///
/// Wraps the `logger` package for consistent log formatting.
/// Uses constructor injection so tests can provide a custom [Logger]
/// instance to capture and verify log output.
///
/// ```dart
/// final logger = AppLogger();
/// logger.info('User opened settings');
/// logger.error('Save failed', exception, stackTrace);
/// ```
class AppLogger {
  /// Creates an [AppLogger] with the given [Logger] instance.
  ///
  /// Uses a default [Logger] if none provided.
  AppLogger({Logger? logger})
      : _logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                lineLength: 80,
                noBoxingByDefault: true,
              ),
            );

  final Logger _logger;

  /// Logs a debug message (development-only detail).
  void debug(String message) {
    _logger.d(message);
  }

  /// Logs an informational message (normal operation).
  void info(String message) {
    _logger.i(message);
  }

  /// Logs a warning (recoverable issue, something unexpected).
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs an error (operation failed, but app can continue).
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
