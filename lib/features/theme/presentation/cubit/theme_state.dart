part of 'theme_cubit.dart';

/// State representing the current theme preferences.
///
/// Contains the current [themeMode] (light/dark/system) and
/// [accentColor] (blue/green/purple/orange/teal).
class ThemeState extends Equatable {
  const ThemeState({
    required this.themeMode,
    required this.accentColor,
  });

  /// The current theme mode (light, dark, or system).
  final ThemeMode themeMode;

  /// The current accent color.
  final AccentColor accentColor;

  /// Creates a copy with optionally updated values.
  ThemeState copyWith({
    ThemeMode? themeMode,
    AccentColor? accentColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  List<Object> get props => [themeMode, accentColor];
}
