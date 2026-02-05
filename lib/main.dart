import 'package:flutter/material.dart';
import 'package:math_mate/app.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';

/// Entry point for the MathMate calculator app.
///
/// Initializes the [CalculatorRepository] for state persistence
/// before launching the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize repository for state persistence
  final repository = await CalculatorRepository.create();

  runApp(App(repository: repository));
}
