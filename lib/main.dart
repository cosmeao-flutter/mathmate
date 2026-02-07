import 'package:flutter/material.dart';
import 'package:math_mate/app.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/history/data/history_database.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/reminder/data/notification_service.dart';
import 'package:math_mate/features/reminder/data/reminder_repository.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';

/// Entry point for the MathMate calculator app.
///
/// Initializes repositories for state persistence before launching the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repositories for state persistence
  final calculatorRepository = await CalculatorRepository.create();
  final themeRepository = await ThemeRepository.create();
  final accessibilityRepository = await AccessibilityRepository.create();

  // Initialize history database and repository
  final historyDatabase = HistoryDatabase();
  final historyRepository = HistoryRepository(historyDatabase);

  // Initialize reminder repository and notification service
  final reminderRepository = await ReminderRepository.create();
  final notificationService = await NotificationService.create();

  runApp(App(
    calculatorRepository: calculatorRepository,
    themeRepository: themeRepository,
    accessibilityRepository: accessibilityRepository,
    historyRepository: historyRepository,
    reminderRepository: reminderRepository,
    notificationService: notificationService,
  ));
}
