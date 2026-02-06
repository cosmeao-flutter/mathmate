import 'package:flutter/material.dart';
import 'package:math_mate/app.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';

/// Entry point for the MathMate calculator app.
///
/// Initializes repositories for state persistence before launching the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repositories for state persistence
  final calculatorRepository = await CalculatorRepository.create();
  final themeRepository = await ThemeRepository.create();

  runApp(App(
    calculatorRepository: calculatorRepository,
    themeRepository: themeRepository,
  ));
}
