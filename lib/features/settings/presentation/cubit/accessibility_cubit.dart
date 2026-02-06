import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';

part 'accessibility_state.dart';

/// Cubit for managing accessibility preferences.
///
/// Loads saved preferences from [AccessibilityRepository] on creation and
/// persists changes automatically.
///
/// Usage:
/// ```dart
/// final repository = await AccessibilityRepository.create();
/// final cubit = AccessibilityCubit(repository: repository);
///
/// // Toggle reduce motion
/// cubit.setReduceMotion(value: true);
///
/// // Toggle haptic feedback
/// cubit.setHapticFeedback(value: false);
///
/// // Toggle sound feedback
/// cubit.setSoundFeedback(value: true);
/// ```
class AccessibilityCubit extends Cubit<AccessibilityState> {
  AccessibilityCubit({required this.repository})
      : super(
          AccessibilityState(
            reduceMotion: repository.loadReduceMotion(),
            hapticFeedback: repository.loadHapticFeedback(),
            soundFeedback: repository.loadSoundFeedback(),
          ),
        );

  /// Repository for persisting accessibility preferences.
  final AccessibilityRepository repository;

  /// Sets the reduce motion preference and persists it.
  Future<void> setReduceMotion({required bool value}) async {
    if (state.reduceMotion == value) return;

    await repository.saveReduceMotion(value: value);
    emit(state.copyWith(reduceMotion: value));
  }

  /// Sets the haptic feedback preference and persists it.
  Future<void> setHapticFeedback({required bool value}) async {
    if (state.hapticFeedback == value) return;

    await repository.saveHapticFeedback(value: value);
    emit(state.copyWith(hapticFeedback: value));
  }

  /// Sets the sound feedback preference and persists it.
  Future<void> setSoundFeedback({required bool value}) async {
    if (state.soundFeedback == value) return;

    await repository.saveSoundFeedback(value: value);
    emit(state.copyWith(soundFeedback: value));
  }
}
