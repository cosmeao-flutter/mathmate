import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/features/onboarding/data/onboarding_repository.dart';

part 'onboarding_state.dart';

/// Cubit for managing the onboarding tutorial flow.
///
/// Loads the completion status from [OnboardingRepository] on creation
/// and persists changes automatically.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required this.repository})
      : super(OnboardingState(
          hasCompleted: repository.loadCompleted(),
          currentPage: 0,
        ));

  /// Repository for persisting onboarding completion.
  final OnboardingRepository repository;

  /// Marks onboarding as completed and persists it.
  Future<void> completeOnboarding() async {
    if (state.hasCompleted) return;

    await repository.saveCompleted(value: true);
    emit(state.copyWith(hasCompleted: true));
  }

  /// Updates the current page index.
  void setPage(int page) {
    if (state.currentPage == page) return;

    emit(state.copyWith(currentPage: page));
  }

  /// Resets the current page to 0.
  void resetPage() {
    if (state.currentPage == 0) return;

    emit(state.copyWith(currentPage: 0));
  }
}
