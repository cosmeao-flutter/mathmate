import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/l10n/l10n.dart';
import 'package:math_mate/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';

/// Swipeable onboarding tutorial screen.
///
/// Shows 4 pages with page indicators, Skip/Next buttons,
/// and a Get Started button on the last page.
///
/// When [isReplay] is true (opened from Settings), completing
/// the tutorial pops the screen without marking onboarding complete.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({this.isReplay = false, super.key});

  /// Whether this is a replay from Settings (vs first-launch).
  final bool isReplay;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  static const _totalPages = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    final reduceMotion =
        context.read<AccessibilityCubit>().state.reduceMotion;
    if (reduceMotion) {
      _pageController.jumpToPage(page);
    } else {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNext() {
    if (_currentPage < _totalPages - 1) {
      _goToPage(_currentPage + 1);
    }
  }

  void _onSkip() {
    _goToPage(_totalPages - 1);
  }

  void _onGetStarted() {
    if (!widget.isReplay) {
      context.read<OnboardingCubit>().completeOnboarding();
    }
    if (widget.isReplay && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _totalPages - 1;

    final pages = [
      _OnboardingPage(
        icon: Icons.calculate_outlined,
        title: l10n.onboardingPage1Title,
        description: l10n.onboardingPage1Desc,
      ),
      _OnboardingPage(
        icon: Icons.history,
        title: l10n.onboardingPage2Title,
        description: l10n.onboardingPage2Desc,
      ),
      _OnboardingPage(
        icon: Icons.currency_exchange,
        title: l10n.onboardingPage3Title,
        description: l10n.onboardingPage3Desc,
      ),
      _OnboardingPage(
        icon: Icons.settings_outlined,
        title: l10n.onboardingPage4Title,
        description: l10n.onboardingPage4Desc,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (top right, hidden on last page)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isLastPage
                    ? const SizedBox(height: 48)
                    : TextButton(
                        onPressed: _onSkip,
                        child: Text(l10n.onboardingSkip),
                      ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  context.read<OnboardingCubit>().setPage(page);
                },
                children: pages,
              ),
            ),

            // Page indicator dots
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                key: const Key('onboarding_dots'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalPages, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: 32,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isLastPage ? _onGetStarted : _onNext,
                  child: Text(
                    isLastPage
                        ? l10n.onboardingGetStarted
                        : l10n.onboardingNext,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single onboarding page with icon, title, and description.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 120,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
