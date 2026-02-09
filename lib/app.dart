import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/services/app_logger.dart';
import 'package:math_mate/core/theme/app_theme.dart';
import 'package:math_mate/features/calculator/data/calculator_repository.dart';
import 'package:math_mate/features/currency/data/currency_repository.dart';
import 'package:math_mate/features/currency/data/currency_service.dart';
import 'package:math_mate/features/currency/presentation/cubit/currency_cubit.dart';
import 'package:math_mate/features/history/data/history_repository.dart';
import 'package:math_mate/features/history/presentation/cubit/history_cubit.dart';
import 'package:math_mate/features/home/presentation/screens/home_screen.dart';
import 'package:math_mate/features/onboarding/data/onboarding_repository.dart';
import 'package:math_mate/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:math_mate/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:math_mate/features/profile/data/location_service.dart';
import 'package:math_mate/features/profile/data/profile_repository.dart';
import 'package:math_mate/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:math_mate/features/reminder/data/notification_service.dart';
import 'package:math_mate/features/reminder/data/reminder_repository.dart';
import 'package:math_mate/features/reminder/presentation/cubit/reminder_cubit.dart';
import 'package:math_mate/features/settings/data/accessibility_repository.dart';
import 'package:math_mate/features/settings/data/locale_repository.dart';
import 'package:math_mate/features/settings/presentation/cubit/accessibility_cubit.dart';
import 'package:math_mate/features/settings/presentation/cubit/locale_cubit.dart';
import 'package:math_mate/features/theme/data/theme_repository.dart';
import 'package:math_mate/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:math_mate/l10n/app_localizations.dart';

/// Root widget for the MathMate calculator app.
///
/// This widget:
/// - Provides [ThemeCubit] for theme management
/// - Provides [AccessibilityCubit] for accessibility settings
/// - Provides [HistoryCubit] for calculation history
/// - Provides [CurrencyCubit] for currency conversion
/// - Configures [MaterialApp] with dynamic theming
/// - Sets [HomeScreen] as the home screen with bottom navigation
class App extends StatelessWidget {
  const App({
    required this.calculatorRepository,
    required this.themeRepository,
    required this.accessibilityRepository,
    required this.historyRepository,
    required this.reminderRepository,
    required this.notificationService,
    required this.profileRepository,
    required this.locationService,
    required this.localeRepository,
    required this.currencyService,
    required this.currencyRepository,
    required this.onboardingRepository,
    required this.logger,
    super.key,
  });

  /// Repository for persisting calculator state.
  final CalculatorRepository calculatorRepository;

  /// Repository for persisting theme preferences.
  final ThemeRepository themeRepository;

  /// Repository for persisting accessibility settings.
  final AccessibilityRepository accessibilityRepository;

  /// Repository for managing calculation history.
  final HistoryRepository historyRepository;

  /// Repository for persisting reminder preferences.
  final ReminderRepository reminderRepository;

  /// Service for scheduling notifications.
  final NotificationService notificationService;

  /// Repository for persisting profile data.
  final ProfileRepository profileRepository;

  /// Service for detecting user location.
  final LocationService locationService;

  /// Repository for persisting locale preference.
  final LocaleRepository localeRepository;

  /// HTTP service for fetching exchange rates.
  final CurrencyService currencyService;

  /// Repository for caching currency data.
  final CurrencyRepository currencyRepository;

  /// Repository for persisting onboarding completion.
  final OnboardingRepository onboardingRepository;

  /// Logger for error handling throughout the app.
  final AppLogger logger;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(repository: themeRepository),
        ),
        BlocProvider(
          create: (_) =>
              AccessibilityCubit(repository: accessibilityRepository),
        ),
        BlocProvider(
          create: (_) => HistoryCubit(
            repository: historyRepository,
            logger: logger,
          )..load(),
        ),
        BlocProvider(
          create: (_) => ReminderCubit(
            repository: reminderRepository,
            notificationService: notificationService,
            logger: logger,
          ),
        ),
        BlocProvider(
          create: (_) => ProfileCubit(
            repository: profileRepository,
            locationService: locationService,
          ),
        ),
        BlocProvider(
          create: (_) => LocaleCubit(repository: localeRepository),
        ),
        BlocProvider(
          create: (_) => CurrencyCubit(
            service: currencyService,
            repository: currencyRepository,
          )..loadRates(),
        ),
        BlocProvider(
          create: (_) =>
              OnboardingCubit(repository: onboardingRepository),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: 'MathMate',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightWithAccent(themeState.accentColor),
                darkTheme: AppTheme.darkWithAccent(themeState.accentColor),
                themeMode: themeState.themeMode,
                locale: localeState.locale,
                localizationsDelegates:
                    AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: BlocBuilder<OnboardingCubit, OnboardingState>(
                  builder: (context, onboardingState) {
                    if (!onboardingState.hasCompleted) {
                      return const OnboardingScreen();
                    }
                    return HomeScreen(
                      calculatorRepository: calculatorRepository,
                      historyRepository: historyRepository,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
