# MathMate

A student-friendly calculator app built with Flutter, featuring expression-based input with live result preview. Built as a learning project covering Clean Architecture, BLoC pattern, TDD, error handling, and progressive feature development.

## Features

- **Expression-based input** - Type full expressions like `2 + 3 × 4`
- **Live result preview** - See results update as you type
- **PEMDAS support** - Correct order of operations
- **Parentheses** - Auto-balanced for convenience
- **Percentage calculations** - Built-in percent operator
- **State persistence** - Remembers your last calculation
- **Dark mode** - Light, dark, and system-following themes
- **Custom accent colors** - 5 color themes (blue, green, purple, orange, teal)
- **Calculation history** - SQLite-backed history with swipe-to-delete
- **Accessibility settings** - Reduce motion, haptic feedback toggles
- **Homework reminders** - Daily notification scheduling with time picker
- **User profile** - Form with name, email, school, and avatar selection
- **Location detection** - GPS-based city/region detection with reverse geocoding
- **Responsive UI** - Adapts to iPhone SE through Pro Max, portrait and landscape
- **Multi-language** - English (US) and Spanish (MX) with reactive switching
- **Currency converter** - Real-time conversion with Frankfurter API and offline cache
- **Adaptive navigation** - NavigationBar (portrait) / NavigationRail (landscape) with tab state preservation
- **Error handling** - Structured logging, defensive persistence, global error boundaries
- **Clipboard copy** - Long press expression or result to copy to clipboard

## Architecture

Built with Clean Architecture and the BLoC pattern:

```
lib/
├── core/              # Constants, theme, utilities, error handling, logging
├── features/
│   ├── calculator/    # Calculator engine, BLoC, UI widgets
│   ├── theme/         # Theme management (Cubit + repository)
│   ├── history/       # Calculation history (Drift/SQLite)
│   ├── settings/      # Accessibility, language settings
│   ├── reminder/      # Homework reminder notifications
│   ├── profile/       # User profile with location detection
│   ├── home/          # Adaptive navigation (NavigationBar/NavigationRail + IndexedStack)
│   └── currency/      # Currency converter (Frankfurter API + cache)
├── l10n/              # ARB translation files (English, Spanish)
```

Each feature follows the same structure:
- `data/` - Repositories (persistence) and services (native plugins)
- `presentation/` - Cubit/BLoC, screens, widgets

## Getting Started

### Prerequisites

- Flutter SDK 3.10+
- iOS 15.0+ / Android SDK 21+

### Installation

```bash
git clone https://github.com/cosmeao-flutter/mathmate.git
cd mathmate
flutter pub get
flutter run
```

## Testing

```bash
# Run all 562 tests
flutter test

# Run specific feature tests
flutter test test/core/                    # Engine + error handling (56)
flutter test test/features/calculator/     # Calculator (96 + 54 responsive)
flutter test test/features/theme/          # Theme (36)
flutter test test/features/history/        # History (39)
flutter test test/features/settings/       # Settings (64: accessibility + locale + language)
flutter test test/features/reminder/       # Reminder (39)
flutter test test/features/profile/        # Profile (63)
flutter test test/features/currency/       # Currency (70)
flutter test test/features/home/           # Home/nav (12)
```

## Tech Stack

- **Flutter** - UI framework
- **flutter_bloc** - State management (BLoC + Cubit)
- **equatable** - Value equality
- **shared_preferences** - Key-value local storage
- **drift** - SQLite ORM for calculation history
- **flutter_local_notifications** - Scheduled homework reminders
- **timezone / flutter_timezone** - Timezone-aware notification scheduling
- **geolocator** - GPS location access
- **geocoding** - Reverse geocoding (coordinates to city/state)
- **flutter_localizations / intl** - i18n with ARB files
- **logger** - Structured logging with log levels
- **http** - HTTP client for currency API requests
- **very_good_analysis** - Strict lint rules
- **bloc_test / mocktail** - Testing utilities

## Development Approach

- **TDD** - Tests written before implementation (Red → Green → Refactor)
- **562 tests** covering engine, BLoC, widgets, repositories, cubits, screens, and error handling
- **Clean Architecture** - Presentation, domain, and data layers
- **Repository pattern** - SharedPreferences and Drift for persistence
- **Service pattern** - Wrappers for native plugins (notifications, location)

## License

MIT License
