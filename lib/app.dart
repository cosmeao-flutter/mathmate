import 'package:flutter/material.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/screens/calculator_screen.dart';

/// Root widget for the MathMate calculator app.
///
/// This widget:
/// - Configures [MaterialApp] with the app theme
/// - Sets [CalculatorScreen] as the home screen
/// - Provides the foundation for the app's widget tree
class App extends StatelessWidget {
  const App({required this.repository, super.key});

  /// Repository for persisting calculator state.
  final CalculatorRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: CalculatorScreen(repository: repository),
    );
  }
}
