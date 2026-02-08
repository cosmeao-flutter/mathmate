import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:math_mate/app.dart';
import 'package:math_mate/core/error/app_error_widget.dart';
import 'package:math_mate/core/error/error_boundary.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/currency/data/currency_repository.dart';
import 'package:math_mate/features/currency/data/currency_service.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/profile/data/location_service.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';
import 'package:math_mate/features/reminder/data/notification_service.dart';
import 'package:math_mate/features/reminder/data/reminder_repository.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';

/// Entry point for the MathMate calculator app.
///
/// Initializes the logger, error boundaries, and repositories
/// for state persistence before launching the app.
///
/// Uses [runZonedGuarded] to catch unhandled async errors and
/// [setupErrorBoundaries] for Flutter framework errors.
Future<void> main() async {
  final logger = AppLogger();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Set up global error handlers
      setupErrorBoundaries(logger);
      ErrorWidget.builder = (details) =>
          AppErrorWidget(details: details);
      PlatformDispatcher.instance.onError =
          (error, stack) {
        logger.error('Platform error', error, stack);
        return true;
      };

      try {
        // Initialize repositories with logger
        final calculatorRepository =
            await CalculatorRepository.create(
          logger: logger,
        );
        final themeRepository =
            await ThemeRepository.create(
          logger: logger,
        );
        final accessibilityRepository =
            await AccessibilityRepository.create(
          logger: logger,
        );

        // Initialize history database and repository
        final historyDatabase = HistoryDatabase();
        final historyRepository = HistoryRepository(
          historyDatabase,
          logger: logger,
        );

        // Initialize reminder repository and service
        final reminderRepository =
            await ReminderRepository.create(
          logger: logger,
        );
        final notificationService =
            await NotificationService.create();

        // Initialize profile repository and service
        final profileRepository =
            await ProfileRepository.create(
          logger: logger,
        );
        final locationService = LocationService();

        // Initialize locale repository
        final localeRepository =
            await LocaleRepository.create(
          logger: logger,
        );

        // Initialize currency service and repository
        final currencyService = CurrencyService();
        final currencyRepository =
            await CurrencyRepository.create(
          logger: logger,
        );

        runApp(App(
          calculatorRepository: calculatorRepository,
          themeRepository: themeRepository,
          accessibilityRepository: accessibilityRepository,
          historyRepository: historyRepository,
          reminderRepository: reminderRepository,
          notificationService: notificationService,
          profileRepository: profileRepository,
          locationService: locationService,
          localeRepository: localeRepository,
          currencyService: currencyService,
          currencyRepository: currencyRepository,
          logger: logger,
        ));
      } on Exception catch (e, stackTrace) {
        logger.error(
          'Fatal: initialization failed',
          e,
          stackTrace,
        );
        runApp(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Failed to start app'),
              ),
            ),
          ),
        );
      }
    },
    (error, stackTrace) {
      logger.error(
        'Unhandled async error',
        error,
        stackTrace,
      );
    },
  );
}
