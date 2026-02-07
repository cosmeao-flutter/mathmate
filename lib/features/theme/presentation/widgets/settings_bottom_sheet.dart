import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/accent_colors.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';

/// Shows the settings bottom sheet.
///
/// Requires [ThemeCubit] to be available in the widget tree.
void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) => const SettingsBottomSheet(),
  );
}

/// Bottom sheet for theme settings.
///
/// Allows users to:
/// - Choose theme mode (light/dark/system)
/// - Choose accent color
class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<AccessibilityCubit, AccessibilityState>(
          builder: (context, a11yState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        l10n.settingsTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),

                      // Appearance section header
                      Text(
                        l10n.appearance,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Theme mode selector
                      Text(
                        l10n.themeMode,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _ThemeModeSelector(
                        currentMode: themeState.themeMode,
                        onModeSelected: (mode) {
                          context.read<ThemeCubit>().setThemeMode(mode);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Accent color selector
                      Text(
                        l10n.accentColor,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      _AccentColorSelector(
                        currentColor: themeState.accentColor,
                        onColorSelected: (color) {
                          context.read<ThemeCubit>().setAccentColor(color);
                        },
                      ),
                      const SizedBox(height: 32),

                      // Accessibility section header
                      Text(
                        l10n.accessibility,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // Accessibility toggles
                      _AccessibilityToggle(
                        title: l10n.reduceMotion,
                        subtitle: l10n.reduceMotionDesc,
                        value: a11yState.reduceMotion,
                        onChanged: (value) {
                          context
                              .read<AccessibilityCubit>()
                              .setReduceMotion(value: value);
                        },
                      ),
                      _AccessibilityToggle(
                        title: l10n.hapticFeedback,
                        subtitle: l10n.hapticFeedbackDesc,
                        value: a11yState.hapticFeedback,
                        onChanged: (value) {
                          context
                              .read<AccessibilityCubit>()
                              .setHapticFeedback(value: value);
                        },
                      ),
                      _AccessibilityToggle(
                        title: l10n.soundFeedback,
                        subtitle: l10n.soundFeedbackDesc,
                        value: a11yState.soundFeedback,
                        onChanged: (value) {
                          context
                              .read<AccessibilityCubit>()
                              .setSoundFeedback(value: value);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
    final l10n = context.l10n;

    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(l10n.themeModeLight),
          icon: const Icon(Icons.light_mode),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(l10n.themeModeDark),
          icon: const Icon(Icons.dark_mode),
        ),
        ButtonSegment(
          value: ThemeMode.system,
          label: Text(l10n.themeModeSystem),
          icon: const Icon(Icons.settings_suggest),
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

/// Toggle switch for accessibility settings.
class _AccessibilityToggle extends StatelessWidget {
  const _AccessibilityToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}
