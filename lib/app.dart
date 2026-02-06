import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/history/presentation/cubit/history_cubit.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';

/// Root widget for the MathMate calculator app.
///
/// This widget:
/// - Provides [ThemeCubit] for theme management
/// - Provides [HistoryCubit] for calculation history
/// - Configures [MaterialApp] with dynamic theming
/// - Sets [CalculatorScreen] as the home screen
class App extends StatelessWidget {
  const App({
    required this.calculatorRepository,
    required this.themeRepository,
    required this.historyRepository,
    super.key,
  });

  /// Repository for persisting calculator state.
  final CalculatorRepository calculatorRepository;

  /// Repository for persisting theme preferences.
  final ThemeRepository themeRepository;

  /// Repository for managing calculation history.
  final HistoryRepository historyRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(repository: themeRepository),
        ),
        BlocProvider(
          create: (_) => HistoryCubit(repository: historyRepository)..load(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'MathMate',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightWithAccent(themeState.accentColor),
            darkTheme: AppTheme.darkWithAccent(themeState.accentColor),
            themeMode: themeState.themeMode,
            home: CalculatorScreen(
              calculatorRepository: calculatorRepository,
              historyRepository: historyRepository,
            ),
          );
        },
      ),
    );
  }
}
