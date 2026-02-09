part of 'onboarding_cubit.dart';

/// State representing the onboarding tutorial status.
class OnboardingState extends Equatable {
  const OnboardingState({
    required this.hasCompleted,
    required this.currentPage,
  });

  /// Whether the user has completed onboarding.
  final bool hasCompleted;

  /// The current page index in the tutorial.
  final int currentPage;

  /// Creates a copy with optionally updated values.
  OnboardingState copyWith({bool? hasCompleted, int? currentPage}) {
    return OnboardingState(
      hasCompleted: hasCompleted ?? this.hasCompleted,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [hasCompleted, currentPage];
}
