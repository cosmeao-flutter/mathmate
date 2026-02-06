part of 'accessibility_cubit.dart';

/// State representing the current accessibility preferences.
///
/// Contains:
/// - [reduceMotion]: Whether to minimize animations (default: false)
/// - [hapticFeedback]: Whether to vibrate on button press (default: true)
/// - [soundFeedback]: Whether to play sound on button press (default: false)
class AccessibilityState extends Equatable {
  const AccessibilityState({
    this.reduceMotion = false,
    this.hapticFeedback = true,
    this.soundFeedback = false,
  });

  /// Whether to minimize animations.
  final bool reduceMotion;

  /// Whether to provide haptic feedback on button press.
  final bool hapticFeedback;

  /// Whether to play sound on button press.
  final bool soundFeedback;

  /// Creates a copy with optionally updated values.
  AccessibilityState copyWith({
    bool? reduceMotion,
    bool? hapticFeedback,
    bool? soundFeedback,
  }) {
    return AccessibilityState(
      reduceMotion: reduceMotion ?? this.reduceMotion,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundFeedback: soundFeedback ?? this.soundFeedback,
    );
  }

  @override
  List<Object> get props => [reduceMotion, hapticFeedback, soundFeedback];
}
