import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';

part 'theme_state.dart';

/// Cubit for managing theme preferences (mode and accent color).
///
/// Loads saved preferences from [ThemeRepository] on creation and
/// persists changes automatically.
///
/// Usage:
/// ```dart
/// final repository = await ThemeRepository.create();
/// final cubit = ThemeCubit(repository: repository);
///
/// // Change theme mode
/// cubit.setThemeMode(ThemeMode.dark);
///
/// // Change accent color
/// cubit.setAccentColor(AccentColor.purple);
/// ```
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.repository})
      : super(
          ThemeState(
            themeMode: repository.loadThemeMode(),
            accentColor: repository.loadAccentColor(),
          ),
        );

  /// Repository for persisting theme preferences.
  final ThemeRepository repository;

  /// Sets the theme mode and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state.themeMode == mode) return;

    await repository.saveThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  /// Sets the accent color and persists it.
  Future<void> setAccentColor(AccentColor color) async {
    if (state.accentColor == color) return;

    await repository.saveAccentColor(color);
    emit(state.copyWith(accentColor: color));
  }
}
