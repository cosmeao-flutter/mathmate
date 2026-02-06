import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';

/// Appearance settings screen for theme mode and accent color.
///
/// Allows users to:
/// - Choose theme mode (light/dark/system)
/// - Choose accent color (blue, green, purple, orange, teal)
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appearance),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme mode section
                Text(
                  AppStrings.themeMode,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _ThemeModeSelector(
                  currentMode: state.themeMode,
                  onModeSelected: (mode) {
                    context.read<ThemeCubit>().setThemeMode(mode);
                  },
                ),
                const SizedBox(height: 32),

                // Accent color section
                Text(
                  AppStrings.accentColor,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _AccentColorSelector(
                  currentColor: state.accentColor,
                  onColorSelected: (color) {
                    context.read<ThemeCubit>().setAccentColor(color);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Segmented button for selecting theme mode.
class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({
    required this.currentMode,
    required this.onModeSelected,
  });

  final ThemeMode currentMode;
  final void Function(ThemeMode) onModeSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(AppStrings.themeModeLight),
          icon: Icon(Icons.light_mode),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(AppStrings.themeModeDark),
          icon: Icon(Icons.dark_mode),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(AppStrings.themeModeSystem),
          icon: Icon(Icons.settings_suggest),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (selected) => onModeSelected(selected.first),
    );
  }
}

/// Row of color circles for selecting accent color.
class _AccentColorSelector extends StatelessWidget {
  const _AccentColorSelector({
    required this.currentColor,
    required this.onColorSelected,
  });

  final AccentColor currentColor;
  final void Function(AccentColor) onColorSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AccentColor.values.map((color) {
        final isSelected = color == currentColor;
        final displayColor = isDark ? color.primaryDark : color.primaryLight;

        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Semantics(
            label: color.displayName,
            selected: isSelected,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: displayColor,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 3,
                      )
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: displayColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: isDark
                          ? color.onPrimaryDark
                          : color.onPrimaryLight,
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
