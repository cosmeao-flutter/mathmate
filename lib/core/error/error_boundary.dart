import 'package:flutter/foundation.dart';
import 'package:math_mate/core/services/app_logger.dart';

/// Sets up global error boundaries for the app.
///
/// Configures [FlutterError.onError] to log framework errors
/// (widget build, layout, painting) via [AppLogger] instead
/// of crashing the app.
///
/// Should be called once during app initialization, after
/// [WidgetsFlutterBinding.ensureInitialized].
void setupErrorBoundaries(AppLogger logger) {
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.error(
      'Flutter error: ${details.exceptionAsString()}',
      details.exception,
      details.stack,
    );
  };
}
