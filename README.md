# MathMate

A student-friendly calculator app built with Flutter, featuring expression-based input with live result preview.

## Features

- **Expression-based input** - Type full expressions like `2 + 3 × 4`
- **Live result preview** - See results as you type
- **PEMDAS support** - Correct order of operations
- **Parentheses** - Auto-balanced for convenience
- **Percentage calculations** - Built-in percent operator
- **State persistence** - Remembers your last calculation

## Screenshots

*Coming soon*

## Architecture

Built with Clean Architecture and the BLoC pattern:

```
lib/
├── core/           # Constants, theme, utilities
├── features/
│   └── calculator/
│       ├── data/           # Repository (persistence)
│       └── presentation/   # BLoC, screens, widgets
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
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
# Run all 163 tests
flutter test

# Run with coverage
flutter test --coverage
```

## Tech Stack

- **Flutter** - UI framework
- **flutter_bloc** - State management
- **equatable** - Value equality
- **shared_preferences** - Local storage

## License

MIT License
