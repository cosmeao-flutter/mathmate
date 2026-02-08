# MathMate - App Documentation

## Overview

MathMate is a student-friendly calculator app built with Flutter. It features expression-based input with live result preview, inspired by Google Calculator.

---

## Architecture

### Clean Architecture Pattern

The app follows Clean Architecture with three layers:

1. **Presentation Layer** (`presentation/`)
   - UI widgets and screens
   - BLoC for state management
   - Handles user interactions

2. **Domain Layer** (`domain/`)
   - Business logic models
   - Use cases (if needed)
   - Pure Dart, no Flutter dependencies

3. **Data Layer** (`data/`)
   - Repositories for data access
   - Local storage with SharedPreferences

### State Management: BLoC Pattern

```
User Tap → Event → BLoC → State → UI Update

Example:
1. User taps "5" button
2. DigitPressed("5") event sent to BLoC
3. BLoC updates expression to "5"
4. New CalculatorInput state emitted
5. Display widget rebuilds showing "5"
```

---

## Project Structure

```
lib/
├── main.dart                  # ✅ App entry point (initializes all repositories + services)
├── app.dart                   # ✅ Root MaterialApp with MultiBlocProvider + locale
├── core/
│   ├── constants/
│   │   ├── accent_colors.dart # ✅ AccentColor enum + palettes
│   │   ├── app_colors.dart    # ✅ Color palette (light + dark)
│   │   ├── app_dimensions.dart # ✅ Sizes, spacing, animation durations
│   │   ├── app_strings.dart   # ✅ Non-translatable symbols + helper methods
│   │   ├── profile_avatars.dart # ✅ Phase 16 - ProfileAvatar enum
│   │   └── responsive_dimensions.dart # ✅ Phase 14 - responsive scaling
│   ├── l10n/
│   │   └── l10n.dart          # ✅ Phase 18 - context.l10n extension
│   ├── theme/
│   │   ├── app_theme.dart     # ✅ Light/dark theme configuration
│   │   └── calculator_colors.dart # ✅ ThemeExtension for widget colors
│   ├── error/
│   │   ├── error_boundary.dart    # ✅ Phase 20 — setupErrorBoundaries(AppLogger)
│   │   └── app_error_widget.dart  # ✅ Phase 20 — friendly error UI widget
│   ├── services/
│   │   └── app_logger.dart        # ✅ Phase 20 — injectable logger wrapper
│   └── utils/
│       └── calculator_engine.dart # ✅ Expression engine + CalculationErrorType
├── features/
│   ├── calculator/
│   │   ├── data/
│   │   │   └── calculator_repository.dart # ✅ State persistence
│   │   ├── domain/            # (future) Domain models
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── calculator_bloc.dart   # ✅ State management
│   │       │   ├── calculator_event.dart  # ✅ Event classes
│   │       │   └── calculator_state.dart  # ✅ State classes
│   │       ├── screens/
│   │       │   └── calculator_screen.dart # ✅ Main screen with BLoC
│   │       └── widgets/
│   │           ├── calculator_button.dart  # ✅ Reusable button
│   │           ├── calculator_display.dart # ✅ Dual-line display
│   │           └── calculator_keypad.dart  # ✅ 6×4 button grid + settings
│   ├── theme/
│   │   ├── data/
│   │   │   └── theme_repository.dart # ✅ Theme persistence
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── theme_cubit.dart  # ✅ Theme state management
│   │       │   └── theme_state.dart  # ✅ Theme state
│   │       └── widgets/
│   │           └── settings_bottom_sheet.dart # ✅ Settings UI
│   ├── history/               # Phase 11
│   │   ├── data/
│   │   │   ├── history_database.dart      # ✅ Drift database
│   │   │   ├── history_database.g.dart    # ✅ Generated code
│   │   │   └── history_repository.dart    # ✅ History CRUD (21 tests)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── history_cubit.dart     # ✅ History state management
│   │       │   └── history_state.dart     # ✅ History state class
│   │       └── widgets/
│   │           └── history_bottom_sheet.dart # ✅ History UI
│   ├── settings/              # Phase 12 + 13 + 18 ✅
│   │   ├── data/
│   │   │   ├── accessibility_repository.dart  # ✅ Accessibility persistence (19 tests)
│   │   │   └── locale_repository.dart         # ✅ Phase 18 - language persistence (9 tests)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── accessibility_cubit.dart   # ✅ Accessibility state mgmt (14 tests)
│   │       │   ├── accessibility_state.dart   # ✅ Accessibility state
│   │       │   ├── locale_cubit.dart          # ✅ Phase 18 - locale state mgmt (11 tests)
│   │       │   └── locale_state.dart          # ✅ Phase 18 - locale state
│   │       └── screens/               # ✅ Phase 13 + 18 - Navigation
│   │           ├── settings_screen.dart       # ✅ Settings menu
│   │           ├── appearance_screen.dart     # ✅ Theme settings
│   │           ├── accessibility_screen.dart  # ✅ Accessibility settings
│   │           └── language_screen.dart       # ✅ Phase 18 - language picker (6 tests)
│   ├── reminder/              # Phase 15 ✅
│   │   ├── data/
│   │   │   ├── reminder_repository.dart       # ✅ Reminder persistence (18 tests)
│   │   │   └── notification_service.dart      # ✅ flutter_local_notifications wrapper
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── reminder_cubit.dart        # ✅ Reminder state mgmt (16 tests)
│   │       │   └── reminder_state.dart        # ✅ Reminder state
│   │       └── screens/
│   │           └── reminder_screen.dart       # ✅ Reminder settings UI
│   ├── profile/               # Phase 16 ✅
│   │   ├── data/
│   │   │   ├── profile_repository.dart        # ✅ Profile persistence (24 tests)
│   │   │   └── location_service.dart          # ✅ Phase 17 — geolocator + geocoding wrapper
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── profile_cubit.dart         # ✅ Profile + location state mgmt (18 tests)
│   │       │   └── profile_state.dart         # ✅ Profile state + location fields
│   │       └── screens/
│   │           └── profile_screen.dart        # ✅ Profile form + location UI (15 tests)
│   ├── home/                  # Phase 19 ✅
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart           # ✅ NavigationBar + IndexedStack (8 tests)
│   └── currency/              # Phase 19 ✅
│       ├── data/
│       │   ├── currency_service.dart          # ✅ HTTP API calls (14 tests)
│       │   └── currency_repository.dart       # ✅ Cache management (22 tests)
│       ├── domain/
│       │   └── currency_constants.dart        # ✅ Defaults, cache duration
│       └── presentation/
│           ├── cubit/
│           │   ├── currency_cubit.dart        # ✅ State management (17 tests)
│           │   └── currency_state.dart        # ✅ Sealed state classes
│           ├── screens/
│           │   └── currency_screen.dart       # ✅ Converter UI (13 tests)
│           └── widgets/
│               └── currency_picker.dart       # ✅ Reusable dropdown
├── l10n/                      # Phase 18 + 19 ✅
│   ├── app_en.arb             # ✅ English template (~105 keys)
│   └── app_es.arb             # ✅ Spanish translations
└── docs.md                    # This file

test/
├── core/
│   ├── error/                                   # Phase 20 ✅
│   │   ├── error_boundary_test.dart             # ✅ 2 tests
│   │   └── app_error_widget_test.dart           # ✅ 3 tests
│   ├── services/                                # Phase 20 ✅
│   │   └── app_logger_test.dart                 # ✅ 6 tests
│   └── utils/
│       └── calculator_engine_test.dart  # ✅ 45 tests
└── features/
    ├── calculator/
    │   ├── data/
    │   │   └── calculator_repository_test.dart # ✅ 19 tests
    │   └── presentation/
    │       ├── bloc/
    │       │   └── calculator_bloc_test.dart  # ✅ 44 tests
    │       └── widgets/
    │           ├── calculator_button_test.dart  # ✅ 14 tests
    │           ├── calculator_display_test.dart # ✅ 24 tests
    │           └── calculator_keypad_test.dart  # ✅ 27 tests
    ├── theme/
    │   ├── data/
    │   │   └── theme_repository_test.dart # ✅ 21 tests
    │   └── presentation/
    │       └── cubit/
    │           └── theme_cubit_test.dart  # ✅ 15 tests
    ├── history/
    │   ├── data/
    │   │   └── history_repository_test.dart # ✅ 25 tests
    │   └── presentation/
    │       └── cubit/
    │           └── history_cubit_test.dart  # ✅ 14 tests
    ├── settings/              # Phase 12 + 18 ✅
    │   ├── data/
    │   │   ├── accessibility_repository_test.dart # ✅ 22 tests
    │   │   └── locale_repository_test.dart        # ✅ 11 tests
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── accessibility_cubit_test.dart   # ✅ 14 tests
    │       │   └── locale_cubit_test.dart          # ✅ 11 tests
    │       └── screens/
    │           └── language_screen_test.dart       # ✅ 6 tests
    ├── reminder/              # Phase 15 ✅
    │   ├── data/
    │   │   └── reminder_repository_test.dart      # ✅ 21 tests
    │   └── presentation/
    │       └── cubit/
    │           └── reminder_cubit_test.dart        # ✅ 18 tests
    ├── profile/               # Phase 16 + 17 ✅
    │   ├── data/
    │   │   └── profile_repository_test.dart       # ✅ 30 tests
    │   └── presentation/
    │       ├── cubit/
    │       │   └── profile_cubit_test.dart        # ✅ 18 tests
    │       └── screens/
    │           └── profile_screen_test.dart       # ✅ 15 tests
    ├── home/                  # Phase 19 ✅
    │   └── presentation/
    │       └── screens/
    │           └── home_screen_test.dart           # ✅ 8 tests
    └── currency/              # Phase 19 ✅
        ├── data/
        │   ├── currency_service_test.dart          # ✅ 14 tests
        │   └── currency_repository_test.dart       # ✅ 26 tests
        └── presentation/
            ├── cubit/
            │   └── currency_cubit_test.dart        # ✅ 17 tests
            └── screens/
                └── currency_screen_test.dart       # ✅ 13 tests
```

---

## Implemented Classes & Functions

### AppColors (`core/constants/app_colors.dart`)

Centralized color definitions for the app.

| Color | Hex | Usage |
|-------|-----|-------|
| `primary` | #2196F3 | Blue accent for operators, equals |
| `background` | #F5F5F5 | App background |
| `numberButton` | #FFFFFF | Number button background |
| `operatorButton` | #2196F3 | Operator button background |
| `functionButton` | #E0E0E0 | Function button (AC, ⌫, %, etc.) |
| `textPrimary` | #212121 | Main text color |
| `error` | #E53935 | Error messages |

### AppDimensions (`core/constants/app_dimensions.dart`)

Size and spacing constants.

| Constant | Value | Usage |
|----------|-------|-------|
| `buttonHeight` | 64dp | Calculator button height |
| `buttonBorderRadius` | 16dp | Rounded rectangle corners |
| `buttonPressedScale` | 0.95 | Scale when button pressed |
| `fontSizeResult` | 56sp | Main result display |
| `fontSizeExpression` | 24sp | Expression line |
| `fontSizeButton` | 28sp | Button text |
| `animationFast` | 150ms | Button press feedback |
| `animationNormal` | 250ms | Standard transition |

### AppStrings (`core/constants/app_strings.dart`)

Text constants and helper methods.

**Key Strings:**
- Button labels: `zero` to `nine`, `plus`, `minus`, `multiply`, `divide`, `backspace`
- Error messages: `errorDivisionByZero`, `errorInvalidExpression`
- Accessibility labels for screen readers

**Helper Methods:**
- `toCalcOperator(String)` - Converts display operator (×) to calc operator (*)
- `toDisplayOperator(String)` - Converts calc operator (*) to display operator (×)

### AppTheme (`core/theme/app_theme.dart`)

Material 3 theme configuration with light and dark variants.

```dart
// Basic usage (default blue accent)
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
)

// With custom accent color
MaterialApp(
  theme: AppTheme.lightWithAccent(AccentColor.purple),
  darkTheme: AppTheme.darkWithAccent(AccentColor.purple),
  themeMode: ThemeMode.system,
)
```

**Static getters:**
- `AppTheme.light` - Light theme with blue accent
- `AppTheme.dark` - Dark theme with blue accent

**Static methods:**
- `AppTheme.lightWithAccent(AccentColor)` - Light theme with custom accent
- `AppTheme.darkWithAccent(AccentColor)` - Dark theme with custom accent

### CalculatorColors (`core/theme/calculator_colors.dart`)

ThemeExtension for calculator-specific colors. Provides theme-aware colors for custom widgets.

```dart
// Usage in widgets
final colors = Theme.of(context).extension<CalculatorColors>()!;
Container(color: colors.numberButton);
Text('5', style: TextStyle(color: colors.textOnNumber));
```

**Properties:**
- Button backgrounds: `numberButton`, `operatorButton`, `functionButton`, `equalsButton`
- Button text: `textOnNumber`, `textOnOperator`, `textOnFunction`, `textOnEquals`
- Display: `displayBackground`, `expressionText`, `resultText`, `errorText`

**Static instances:**
- `CalculatorColors.light` - Light theme colors (default blue accent)
- `CalculatorColors.dark` - Dark theme colors (default blue accent)

**Factory constructors for custom accents:**
- `CalculatorColors.fromAccentLight(AccentColor)` - Light theme with custom accent
- `CalculatorColors.fromAccentDark(AccentColor)` - Dark theme with custom accent

### AccentColor (`core/constants/accent_colors.dart`)

Enum defining available accent color options for the calculator.

```dart
// Available options
AccentColor.blue    // Default - Google Calculator inspired
AccentColor.green   // Nature/calm theme
AccentColor.purple  // Creative/modern theme
AccentColor.orange  // Energetic/warm theme
AccentColor.teal    // Professional/balanced theme

// Usage with themes
AppTheme.lightWithAccent(AccentColor.purple)
AppTheme.darkWithAccent(AccentColor.green)
```

**Extension properties:**
- `displayName` - Human-readable name for UI
- `primaryLight` / `primaryDark` - Main accent color
- `primaryDarkLight` / `primaryDarkDark` - Pressed state color
- `primaryLightLight` / `primaryLightDark` - Highlight color
- `onPrimaryLight` / `onPrimaryDark` - Text color on accent

### CalculatorEngine (`core/utils/calculator_engine.dart`)

Mathematical expression evaluation engine.

```dart
// Usage
final engine = CalculatorEngine();
final result = engine.evaluate('2 + 3 * 4');

if (result.isError) {
  print(result.errorType); // CalculationErrorType enum
} else {
  print(result.displayValue); // "14"
}
```

**Features:**
- PEMDAS order of operations
- Auto-balances unclosed parentheses
- Implicit multiplication: `2(3)` → `2*(3)`
- Percentage handling: `50%` → `0.5`

### ThemeRepository (`features/theme/data/theme_repository.dart`)

Repository for persisting theme preferences using SharedPreferences.

```dart
// Usage
final repository = await ThemeRepository.create();

// Save theme mode
await repository.saveThemeMode(ThemeMode.dark);

// Load theme mode (defaults to system if not saved)
final mode = repository.loadThemeMode();

// Save accent color
await repository.saveAccentColor(AccentColor.purple);

// Load accent color (defaults to blue if not saved)
final color = repository.loadAccentColor();
```

**Features:**
- Persists theme mode (light/dark/system)
- Persists accent color (blue/green/purple/orange/teal)
- Defaults: ThemeMode.system, AccentColor.blue

### ThemeCubit (`features/theme/presentation/cubit/theme_cubit.dart`)

Cubit for managing theme state.

```dart
// Usage
final cubit = ThemeCubit(repository: repository);

// Set theme mode
await cubit.setThemeMode(ThemeMode.dark);

// Set accent color
await cubit.setAccentColor(AccentColor.purple);

// Access current state
print(cubit.state.themeMode);   // ThemeMode.dark
print(cubit.state.accentColor); // AccentColor.purple
```

**Methods:**
- `setThemeMode(ThemeMode)` - Updates theme mode and persists to repository
- `setAccentColor(AccentColor)` - Updates accent color and persists to repository

### ThemeState (`features/theme/presentation/cubit/theme_state.dart`)

Immutable state class for theme settings.

```dart
// Properties
final state = ThemeState(
  themeMode: ThemeMode.system,
  accentColor: AccentColor.blue,
);

// Copy with updated values
final newState = state.copyWith(themeMode: ThemeMode.dark);
```

**Properties:**
- `themeMode` - Current ThemeMode (light/dark/system)
- `accentColor` - Current AccentColor

### SettingsBottomSheet (`features/theme/presentation/widgets/settings_bottom_sheet.dart`)

Bottom sheet widget for theme settings.

```dart
// Show the settings bottom sheet
showSettingsBottomSheet(context);
```

**Features:**
- Theme mode selector (SegmentedButton: Light/Dark/System)
- Accent color picker (5 color circles with checkmark on selected)
- Requires ThemeCubit in widget tree

---

## History Classes (Phase 11)

### HistoryEntry (Drift Table)

Database table for storing calculation history.

```dart
// Table definition (Drift)
class HistoryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get expression => text()();
  TextColumn get result => text()();
  DateTimeColumn get timestamp => dateTime()();
}

// Usage
final entry = HistoryEntry(
  id: 1,
  expression: '2 + 3 × 4',
  result: '14',
  timestamp: DateTime.now(),
);
```

### HistoryRepository (`features/history/data/history_repository.dart`)

Repository for managing calculation history with Drift.

```dart
// Usage
final repository = HistoryRepository(database);

// Add entry (called on successful EqualsPressed)
await repository.addEntry(expression: '2 + 3', result: '5');

// Get all entries (reactive stream)
repository.getAllEntries().listen((entries) {
  print('${entries.length} entries');
});

// Delete single entry
await repository.deleteEntry(id: 1);

// Clear all history
await repository.clearAll();

// Get count (for badge)
final count = await repository.getEntryCount();
```

### HistoryCubit (`features/history/presentation/cubit/history_cubit.dart`)

Cubit for managing history UI state.

```dart
// Usage
final cubit = HistoryCubit(repository: repository);

// Load history (subscribes to stream)
cubit.load();

// Delete entry
await cubit.delete(id: 1);

// Clear all
await cubit.clearAll();

// Access state
print(cubit.state.entries);    // List<HistoryEntry>
print(cubit.state.isLoading);  // bool
```

### HistoryBottomSheet (`features/history/presentation/widgets/history_bottom_sheet.dart`)

Bottom sheet for viewing and managing calculation history.

```dart
// Show the history bottom sheet
showHistoryBottomSheet(context);
```

**Features:**
- Scrollable list of past calculations
- Each item shows: expression → result (timestamp)
- Tap to load expression into calculator
- Swipe left to delete individual entry
- "Clear All" button with confirmation dialog
- Empty state when no history

---

## Accessibility Classes (Phase 12) ✅

### AccessibilityRepository (`features/settings/data/accessibility_repository.dart`)

Repository for persisting accessibility preferences using SharedPreferences.

```dart
// Usage
final repository = await AccessibilityRepository.create();

// Save settings
await repository.saveReduceMotion(true);
await repository.saveHapticFeedback(false);
await repository.saveSoundFeedback(true);

// Load settings (with defaults)
final reduceMotion = repository.loadReduceMotion();   // default: false
final hapticFeedback = repository.loadHapticFeedback(); // default: true
final soundFeedback = repository.loadSoundFeedback();  // default: false
```

**Features:**
- Persists reduce motion, haptic feedback, and sound feedback settings
- Sensible defaults (haptic on, others off)
- Follows existing repository pattern

### AccessibilityState (`features/settings/presentation/cubit/accessibility_state.dart`)

Immutable state class for accessibility settings.

```dart
// Properties
final state = AccessibilityState(
  reduceMotion: false,
  hapticFeedback: true,
  soundFeedback: false,
);

// Copy with updated values
final newState = state.copyWith(reduceMotion: true);
```

**Properties:**
- `reduceMotion` - Whether to disable animations (default: false)
- `hapticFeedback` - Whether to enable haptic feedback on button press (default: true)
- `soundFeedback` - Whether to play click sound on button press (default: false)

### AccessibilityCubit (`features/settings/presentation/cubit/accessibility_cubit.dart`)

Cubit for managing accessibility state.

```dart
// Usage
final cubit = AccessibilityCubit(repository: repository);

// Set reduce motion
await cubit.setReduceMotion(true);

// Set haptic feedback
await cubit.setHapticFeedback(false);

// Set sound feedback
await cubit.setSoundFeedback(true);

// Access current state
print(cubit.state.reduceMotion);    // true
print(cubit.state.hapticFeedback);  // false
print(cubit.state.soundFeedback);   // true
```

**Methods:**
- `setReduceMotion(bool)` - Updates reduce motion and persists
- `setHapticFeedback(bool)` - Updates haptic feedback and persists
- `setSoundFeedback(bool)` - Updates sound feedback and persists

### AccessibilitySection (`features/settings/presentation/widgets/accessibility_section.dart`)

Widget section for accessibility toggles in settings bottom sheet.

```dart
// Usage (inside SettingsBottomSheet)
AccessibilitySection()
```

**Features:**
- Three `SwitchListTile` widgets for each setting
- Uses `BlocBuilder<AccessibilityCubit, AccessibilityState>`
- Consistent styling with theme section

---

### CalculatorRepository (`features/calculator/data/calculator_repository.dart`)

Repository for persisting calculator state using SharedPreferences.

```dart
// Usage
final repository = await CalculatorRepository.create();

// Save state
await repository.saveState(expression: '2 + 3', result: '5');

// Load state
final state = repository.loadState();
print(state.expression); // '2 + 3'
print(state.result);     // '5'

// Check if state exists
if (repository.hasState) {
  // ...
}

// Clear saved state
await repository.clearState();
```

**Features:**
- Persists expression and result across app restarts
- Auto-saves on every state change (via BLoC integration)
- Clears state on AllClearPressed

### CalculatorEvent (`features/calculator/presentation/bloc/calculator_event.dart`)

Sealed class hierarchy for calculator events.

| Event | Properties | Description |
|-------|------------|-------------|
| `DigitPressed` | `digit: String` | User pressed 0-9 |
| `OperatorPressed` | `operator: String` | User pressed +, −, ×, ÷ |
| `DecimalPressed` | - | User pressed decimal point |
| `EqualsPressed` | - | User pressed equals |
| `ClearPressed` | - | User pressed C (clear last) |
| `AllClearPressed` | - | User pressed AC (reset) |
| `BackspacePressed` | - | User pressed ⌫ (delete last char) |
| `ParenthesisPressed` | `isOpen: bool` | User pressed ( or ) |
| `PlusMinusPressed` | - | User pressed ± toggle |
| `PercentPressed` | - | User pressed % |
| `CalculatorStarted` | - | Calculator initialization |

### CalculatorState (`features/calculator/presentation/bloc/calculator_state.dart`)

Sealed class hierarchy for calculator states.

| State | Additional Properties | Description |
|-------|----------------------|-------------|
| `CalculatorInitial` | - | Initial state, display shows "0" |
| `CalculatorInput` | `liveResult: String` | User building expression |
| `CalculatorResult` | `result: String` | After pressing = |
| `CalculatorError` | `errorType: CalculationErrorType` | Error occurred |

### CalculatorBloc (`features/calculator/presentation/bloc/calculator_bloc.dart`)

BLoC for managing calculator state.

```dart
// Usage
final bloc = CalculatorBloc();
bloc.add(const DigitPressed('5'));
bloc.add(const OperatorPressed('+'));
bloc.add(const DigitPressed('3'));
bloc.add(const EqualsPressed());
// State emits CalculatorResult with result: "8"
```

### CalculatorButton (`features/calculator/presentation/widgets/calculator_button.dart`)

Reusable button widget with press animation.

```dart
// Usage
CalculatorButton(
  label: '7',
  onPressed: () => bloc.add(DigitPressed('7')),
  type: CalculatorButtonType.number,
  semanticLabel: 'Seven',
)
```

**Features:**
- Rounded rectangle shape (16dp radius)
- Press animation (scales to 0.95)
- Haptic feedback on press
- Four button types: `number`, `operator`, `function`, `equals`

**CalculatorButtonType enum:**
| Type | Background | Text Color |
|------|------------|------------|
| `number` | White | Dark |
| `operator` | Blue | White |
| `function` | Gray | Dark |
| `equals` | Blue | White |

### CalculatorDisplay (`features/calculator/presentation/widgets/calculator_display.dart`)

Dual-line display showing expression and result.

```dart
// Usage
CalculatorDisplay(
  expression: '2 + 3 × 4',
  result: '14',
)

// With error
CalculatorDisplay(
  expression: '5 ÷ 0',
  result: '',
  errorMessage: 'Cannot divide by zero',
)
```

**Features:**
- Top line: Expression (smaller, secondary color)
- Bottom line: Result (larger, primary color)
- Error message replaces result (red color)
- Right-aligned text
- White background with padding
- Long press to copy: optional `onExpressionLongPress` and `onResultLongPress` callbacks
- Error state: result area does not fire copy callback

### CalculatorKeypad (`features/calculator/presentation/widgets/calculator_keypad.dart`)

6×4 grid of calculator buttons.

```dart
// Usage
CalculatorKeypad(
  onDigitPressed: (digit) => bloc.add(DigitPressed(digit)),
  onOperatorPressed: (op) => bloc.add(OperatorPressed(op)),
  onEqualsPressed: () => bloc.add(const EqualsPressed()),
  onAllClearPressed: () => bloc.add(const AllClearPressed()),
  onBackspacePressed: () => bloc.add(const BackspacePressed()),
  onDecimalPressed: () => bloc.add(const DecimalPressed()),
  onPercentPressed: () => bloc.add(const PercentPressed()),
  onPlusMinusPressed: () => bloc.add(const PlusMinusPressed()),
  onParenthesisPressed: ({required bool isOpen}) =>
      bloc.add(ParenthesisPressed(isOpen: isOpen)),
  onSettingsPressed: () => showSettingsBottomSheet(context), // Optional
)
```

**Layout (6×4 grid):**
```
┌─────┬─────┬─────┬─────┐
│ AC  │  ⌫  │  🕐 │  ⚙  │  ← Control row (history + settings)
├─────┼─────┼─────┼─────┤
│  (  │  )  │  %  │  ÷  │  ← Functions & division
├─────┼─────┼─────┼─────┤
│  7  │  8  │  9  │  ×  │
├─────┼─────┼─────┼─────┤
│  4  │  5  │  6  │  −  │
├─────┼─────┼─────┼─────┤
│  1  │  2  │  3  │  +  │
├─────┼─────┼─────┼─────┤
│  ±  │  0  │  .  │  =  │  ← Plus/minus, zero, decimal, equals
└─────┴─────┴─────┴─────┘
```

**Callbacks:**
| Callback | Parameter | Description |
|----------|-----------|-------------|
| `onDigitPressed` | `String digit` | 0-9 pressed |
| `onOperatorPressed` | `String operator` | +, −, ×, ÷ pressed |
| `onEqualsPressed` | - | = pressed |
| `onAllClearPressed` | - | AC pressed |
| `onBackspacePressed` | - | ⌫ pressed (deletes last char) |
| `onDecimalPressed` | - | . pressed |
| `onPercentPressed` | - | % pressed |
| `onPlusMinusPressed` | - | ± pressed |
| `onParenthesisPressed` | `{required bool isOpen}` | ( or ) pressed |
| `onHistoryPressed` | - | 🕐 pressed (optional) |
| `onSettingsPressed` | - | ⚙ pressed (optional) |

---

## Test Coverage

**Total: 558 tests, all passing**

### Calculator Engine Tests (45 tests)

| Test Group | Tests |
|------------|-------|
| Basic Arithmetic | 7 |
| PEMDAS Order of Operations | 6 |
| Decimal Handling | 5 |
| Parentheses Auto-Balance | 4 |
| Implicit Multiplication | 4 |
| Percentage | 3 |
| Error Handling | 5 |
| Edge Cases | 7 |
| Result Formatting | 4 |

### Calculator Repository Tests (19 tests)

| Test Group | Tests |
|------------|-------|
| saveState | 4 |
| loadState | 4 |
| clearState | 2 |
| hasState | 4 |
| Edge Cases | 3 |
| Error Handling | 2 |

### Calculator BLoC Tests (44 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 1 |
| DigitPressed | 4 |
| OperatorPressed | 3 |
| DecimalPressed | 4 |
| EqualsPressed | 4 |
| ClearPressed | 4 |
| AllClearPressed | 2 |
| ParenthesisPressed | 3 |
| PlusMinusPressed | 2 |
| PercentPressed | 2 |
| Live Result Preview | 2 |
| CalculatorStarted | 1 |
| Error Recovery | 2 |
| Persistence | 7 |
| Error Handling | 3 |

### Calculator Button Tests (14 tests)

| Test Group | Tests |
|------------|-------|
| Rendering | 3 |
| Interaction | 2 |
| Button Types | 5 |
| Press Animation | 2 |
| Accessibility | 2 |

### Calculator Display Tests (24 tests)

| Test Group | Tests |
|------------|-------|
| Expression Display | 4 |
| Result Display | 4 |
| Initial State | 2 |
| Error State | 4 |
| Layout | 3 |
| Accessibility | 1 |
| Clipboard Copy | 6 |

### Calculator Keypad Tests (27 tests)

| Test Group | Tests |
|------------|-------|
| Layout | 7 |
| Digit Callbacks | 3 |
| Operator Callbacks | 4 |
| Function Callbacks | 6 |
| Parenthesis Callbacks | 2 |
| Button Types | 5 |

### Theme Repository Tests (21 tests)

| Test Group | Tests |
|------------|-------|
| saveThemeMode | 3 |
| loadThemeMode | 5 |
| saveAccentColor | 3 |
| loadAccentColor | 5 |
| Edge Cases | 3 |
| Error Handling | 2 |

### Theme Cubit Tests (15 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 2 |
| setThemeMode | 5 |
| setAccentColor | 5 |
| ThemeState | 3 |

### History Repository Tests (25 tests)

| Test Group | Tests |
|------------|-------|
| addEntry | 5 |
| getAllEntries | 4 |
| deleteEntry | 3 |
| clearAll | 2 |
| getEntryCount | 4 |
| Edge Cases | 3 |
| Error Handling | 4 |

### History Cubit Tests (14 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 1 |
| load | 4 |
| delete | 2 |
| clearAll | 1 |
| close | 1 |
| HistoryState | 4 |
| Error Handling | 1 |

### Accessibility Repository Tests (22 tests)

| Test Group | Tests |
|------------|-------|
| create | 1 |
| saveReduceMotion | 2 |
| loadReduceMotion | 3 |
| saveHapticFeedback | 2 |
| loadHapticFeedback | 3 |
| saveSoundFeedback | 2 |
| loadSoundFeedback | 3 |
| Edge Cases | 3 |
| Error Handling | 3 |

### Accessibility Cubit Tests (14 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 2 |
| setReduceMotion | 3 |
| setHapticFeedback | 3 |
| setSoundFeedback | 3 |
| AccessibilityState | 3 |

### Reminder Repository Tests (21 tests)

| Test Group | Tests |
|------------|-------|
| create | 1 |
| saveReminderEnabled | 2 |
| loadReminderEnabled | 3 |
| saveReminderHour | 2 |
| loadReminderHour | 3 |
| saveReminderMinute | 2 |
| loadReminderMinute | 3 |
| Edge Cases | 2 |
| Error Handling | 3 |

### Reminder Cubit Tests (18 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 2 |
| setReminderEnabled (enable) | 3 |
| setReminderEnabled (disable) | 2 |
| setReminderEnabled (no-op) | 1 |
| setReminderTime | 4 |
| ReminderState | 4 |
| Error Handling | 2 |

### Profile Repository Tests (30 tests)

| Test Group | Tests |
|------------|-------|
| saveName / loadName | 4 |
| saveEmail / loadEmail | 3 |
| saveSchool / loadSchool | 3 |
| saveAvatar / loadAvatar | 4 |
| saveCity / loadCity | 3 |
| saveRegion / loadRegion | 3 |
| Persistence Roundtrip | 4 |
| Error Handling | 6 |

### Profile Cubit Tests (18 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 2 |
| saveProfile | 3 |
| updateAvatar | 2 |
| detectLocation | 5 |
| ProfileState | 3 |
| Nullable Avatar | 2 |
| Loading State | 1 |

### Profile Screen Tests (15 tests)

| Test Group | Tests |
|------------|-------|
| Rendering | 6 |
| Validation | 5 |
| Form Submission | 2 |
| Location Section | 2 |

### Locale Repository Tests (11 tests)

| Test Group | Tests |
|------------|-------|
| create | 1 |
| saveLocale | 2 |
| loadLocale | 3 |
| Edge Cases | 3 |
| Error Handling | 2 |

### Locale Cubit Tests (11 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 2 |
| setLocale | 4 |
| LocaleState | 3 |
| Persistence | 2 |

### Language Screen Tests (6 tests)

| Test Group | Tests |
|------------|-------|
| Rendering | 3 |
| Selection | 3 |

### Currency Service Tests (14 tests)

| Test Group | Tests |
|------------|-------|
| fetchCurrencies | 5 |
| fetchRates | 6 |
| ExchangeRates | 2 |
| CurrencyServiceException | 1 |

### Currency Repository Tests (26 tests)

| Test Group | Tests |
|------------|-------|
| create | 1 |
| saveFromCurrency / loadFromCurrency | 3 |
| saveToCurrency / loadToCurrency | 3 |
| saveCurrencies / loadCurrencies | 3 |
| saveRates / loadRates | 4 |
| saveRateDate / loadRateDate | 2 |
| isCacheFresh | 3 |
| Persistence Roundtrip | 1 |
| Edge Cases | 2 |
| Error Handling | 4 |

### Currency Cubit Tests (17 tests)

| Test Group | Tests |
|------------|-------|
| Initial State | 2 |
| loadRates | 5 |
| updateAmount | 2 |
| setFromCurrency | 1 |
| setToCurrency | 1 |
| swapCurrencies | 2 |
| refresh | 1 |
| CurrencyState Equality | 3 |

### Currency Screen Tests (13 tests)

| Test Group | Tests |
|------------|-------|
| Loading State | 1 |
| Error State | 2 |
| Loaded State | 5 |
| Offline State | 2 |
| Initial State | 1 |

### Home Screen Tests (8 tests)

| Test Group | Tests |
|------------|-------|
| Rendering | 3 |
| Default Tab | 1 |
| Tab Switching | 2 |
| IndexedStack | 2 |

---

## Development Progress

### Phase 1: Project Setup ✅
### Phase 2: Core Constants & Theme ✅
### Phase 3: Calculator Engine ✅
### Phase 4: Domain Models ✅
### Phase 5: Calculator BLoC ✅
### Phase 6: UI Widgets ✅
- `calculator_button.dart` - 14 tests
- `calculator_display.dart` - 24 tests
- `calculator_keypad.dart` - 27 tests

### Phase 7: Main Screen ✅
- `calculator_screen.dart` - Main screen with BlocProvider/BlocBuilder
- `app.dart` - Root MaterialApp with theme
- `main.dart` - Clean entry point
- App runs on iOS Simulator

### Phase 7.5: Keypad Layout Update ✅
- Updated to 6×4 grid layout
- Added backspace (⌫) button
- Added decimal (.) button
- Reorganized button positions
- Updated tests

### Phase 8: Persistence ✅
- `calculator_repository.dart` - SharedPreferences wrapper (17 tests)
- Updated BLoC to use repository for auto-save/restore
- State persists across app restarts
- MVP Complete!

### Phase 9: Full Theme System ✅

**Goal:** Implement dark mode, system theme following, and custom accent colors.

1. **Dark Theme ✅**
   - Dark color palette in `AppColors` (70+ dark color constants)
   - `AppTheme.dark` theme data
   - `CalculatorColors` ThemeExtension for theme-aware widget colors
   - Widgets use theme colors instead of hardcoded values

2. **System Theme Following ✅**
   - Support `ThemeMode.light`, `ThemeMode.dark`, `ThemeMode.system`
   - Reactive updates when user changes device settings

3. **Custom Accent Colors ✅**
   - `AccentColor` enum with 5 options (blue, green, purple, orange, teal)
   - `accent_colors.dart` with light/dark color palettes
   - `CalculatorColors.fromAccentLight/Dark()` factory methods
   - `AppTheme.lightWithAccent/darkWithAccent()` methods

4. **Theme State Management ✅**
   - `ThemeCubit` manages theme state (15 tests)
   - State: current mode (light/dark/system), current accent color

5. **Theme Persistence ✅**
   - `ThemeRepository` saves/loads preferences via SharedPreferences (19 tests)
   - Persists theme mode and accent color
   - Loads on app start

6. **Integration & UI ✅**
   - Wire theme system to MaterialApp via BlocProvider/BlocBuilder
   - Settings button (⚙) in calculator keypad
   - Settings bottom sheet with theme mode selector and color picker

---

### Phase 11: Calculation History ✅

**Goal:** Enhanced local persistence using Drift (SQLite ORM)

1. **Database Setup ✅**
   - Drift ORM for type-safe SQLite access
   - `HistoryEntry` table (id, expression, result, timestamp)
   - Code generation with build_runner
   - Migration strategy for schema changes

2. **History Repository (TDD) ✅**
   - `addEntry()` - insert new calculation
   - `getAllEntries()` - reactive Stream<List<HistoryEntry>>
   - `deleteEntry(id)` - remove single entry
   - `clearAll()` - remove all history
   - 21 tests passing

3. **History State Management ✅**
   - `HistoryCubit` for history state (13 tests)
   - Reactive updates from database stream via subscription
   - Proper stream cleanup on close

4. **History UI ✅**
   - History button (🕐) in keypad control row
   - DraggableScrollableSheet bottom sheet
   - Tap entry to load expression into calculator
   - Swipe left to delete individual entry (Dismissible)
   - Clear all with confirmation dialog
   - Integration with CalculatorBloc (saves on equals, loads from history)

---

### Phase 12: Accessibility & Settings Expansion ✅

**Goal:** Expand settings bottom sheet with accessibility features

1. **Accessibility Repository (TDD) ✅**
   - `AccessibilityRepository` for SharedPreferences persistence
   - Save/load: reduceMotion, hapticFeedback, soundFeedback
   - 19 tests

2. **Accessibility State Management (TDD) ✅**
   - `AccessibilityState` immutable state class
   - `AccessibilityCubit` with setters for each setting
   - 14 tests

3. **Settings UI Update ✅**
   - Expanded `SettingsBottomSheet` with two sections
   - Section 1: "Appearance" (theme mode + accent colors)
   - Section 2: "Accessibility" (reduce motion, haptic feedback, sound feedback)
   - Three `SwitchListTile` toggles for accessibility settings

4. **Integration ✅**
   - Updated `CalculatorButton` to respect accessibility settings
   - Animations skip when reduceMotion is enabled
   - Haptic feedback respects hapticFeedback setting
   - `AccessibilityCubit` provided in `app.dart`

---

### Phase 13: Navigation & Settings Screens ✅

**Goal:** Learn Navigator 1.0 by replacing settings bottom sheet with proper screen navigation

1. **Settings Screen ✅**
   - `settings_screen.dart` - Main settings menu with ListTiles
   - AppBar with "Settings" title
   - Menu items: "Appearance", "Accessibility" with subtitles and chevrons

2. **Appearance Screen ✅**
   - `appearance_screen.dart` - Theme settings
   - Theme mode selector (SegmentedButton: Light/Dark/System)
   - Accent color picker (5 color circles)
   - AppBar with automatic back button

3. **Accessibility Screen ✅**
   - `accessibility_screen.dart` - Accessibility settings
   - 3 SwitchListTile toggles (reduce motion, haptic, sound)
   - AppBar with automatic back button

4. **Navigation Integration ✅**
   - Updated `calculator_screen.dart` to use `Navigator.push()`
   - Navigation flow: Calculator → Settings → Appearance/Accessibility
   - Back navigation via AppBar back button (automatic)

**Concepts learned:**
- `Navigator.push<void>(context, MaterialPageRoute(builder: ...))`
- `Navigator.pop()` (via AppBar back button)
- `MaterialPageRoute` for standard Material page transitions
- AppBar with automatic back button when Navigator has history
- Cubits at app root remain accessible in all pushed screens

---

### Phase 14: Responsive & Adaptive UI ✅

**Goal:** Adapt to different phone sizes (iPhone SE → Pro Max) and support landscape orientation.

#### ResponsiveDimensions (`core/constants/responsive_dimensions.dart`)

Value class that computes scaled dimensions from screen constraints.

```dart
// Factory constructor
final dimensions = ResponsiveDimensions.fromConstraints(
  constraints.maxWidth,   // from LayoutBuilder
  constraints.maxHeight,
  orientation,            // from MediaQuery.orientationOf(context)
);

// Access scaled values
dimensions.buttonHeight      // 64dp scaled for screen size
dimensions.fontSizeResult    // 56dp scaled for screen size
dimensions.fontSizeButton    // 28dp scaled for screen size
dimensions.buttonSpacing     // 12dp scaled for screen size
dimensions.isLandscape       // true if landscape orientation
```

**Scaling logic:**
- Reference device: iPhone 14 (390dp width)
- Portrait scale = screenWidth / 390, clamped to [0.75, 1.2]
- Landscape scale = screenHeight / 390, clamped to [0.75, 1.2]
- Landscape further reduces: buttonHeight × 0.7, spacing × 0.6
- Minimum buttonHeight floor = 44dp (accessibility)
- Default constructor returns AppDimensions values (backward compatible)

#### Layout Switching

Portrait (current Column layout):
```
┌─────────────────────────────┐
│        Display Area         │  ← Expanded
├─────────────────────────────┤
│         Keypad (6×4)        │  ← responsive height
└─────────────────────────────┘
```

Landscape (Column with 4×6 keypad):
```
┌─────────────────────────────┐
│    Expression + Result      │  ← compact display on top
├─────────────────────────────┤
│  AC  ⌫  7  8  9  ÷         │
│  (   )  4  5  6  ×         │  ← 4×6 grid fills width
│  %   ±  1  2  3  −         │
│  🕐  ⚙  0  .  =  +         │
└─────────────────────────────┘
```

#### Widget Changes

All widgets accept optional `ResponsiveDimensions? dimensions` parameter:
- `CalculatorButton` - responsive fontSize, height, borderRadius
- `CalculatorDisplay` - responsive fontSizes, padding, FittedBox for overflow
- `CalculatorKeypad` - responsive spacing, orientation-aware grid (6×4 portrait, 4×6 landscape)
- `CalculatorScreen` - LayoutBuilder + MediaQuery.orientationOf, computes dimensions

#### Key Flutter Concepts

| Concept | Usage |
|---------|-------|
| `LayoutBuilder` | Get parent constraints at screen level |
| `MediaQuery.orientationOf()` | Detect device orientation |
| `FittedBox(fit: BoxFit.scaleDown)` | Auto-shrink text to fit available space |
| `Expanded` | Fill remaining space in landscape Column |
| Scale factor + clamping | Responsive dimension computation |
| `tester.binding.setSurfaceSize()` | Testing at different screen sizes |

---

### Phase 15: Homework Reminder Notifications ✅

**Goal:** Add a daily homework reminder notification via Settings.

#### Architecture
```
lib/features/reminder/
├── data/
│   ├── reminder_repository.dart      # SharedPreferences (enabled, hour, minute)
│   └── notification_service.dart     # flutter_local_notifications wrapper
└── presentation/
    ├── cubit/
    │   ├── reminder_cubit.dart       # Orchestrates repository + service
    │   └── reminder_state.dart       # Equatable (isEnabled, hour, minute)
    └── screens/
        └── reminder_screen.dart      # SwitchListTile + showTimePicker
```

#### Key Classes

**ReminderRepository** — SharedPreferences persistence for reminder settings.
- `saveReminderEnabled(bool)` / `loadReminderEnabled()` → default: false
- `saveReminderHour(int)` / `loadReminderHour()` → default: 16 (4:00 PM)
- `saveReminderMinute(int)` / `loadReminderMinute()` → default: 0

**NotificationService** — Wrapper around `flutter_local_notifications` plugin.
- `create()` — initializes plugin + timezone
- `requestPermission()` — iOS permission dialog, returns bool
- `scheduleDailyReminder(hour, minute)` — `zonedSchedule` with `DateTimeComponents.time`
- `cancelReminder()` — cancels by notification ID

**ReminderCubit** — State management orchestrating repository + service.
- `setReminderEnabled(bool)` — requests permission when enabling, schedules/cancels notification
- `setReminderTime(TimeOfDay)` — persists hour+minute, reschedules if enabled
- Permission denied → toggle stays off (graceful degradation)

**ReminderState** — Equatable state class.
- `isEnabled` (bool), `hour` (int), `minute` (int)
- `TimeOfDay get timeOfDay` — convenience getter for UI

#### Dependencies Added
- `flutter_local_notifications` — local notification scheduling
- `timezone` — timezone-aware scheduling with `TZDateTime`
- `flutter_timezone` — device timezone detection

#### Key Concepts
| Concept | Usage |
|---------|-------|
| `flutter_local_notifications` | Plugin for scheduling local notifications |
| `zonedSchedule` + `DateTimeComponents.time` | Daily recurring notifications |
| `TZDateTime` | Timezone-aware date/time for scheduling |
| `showTimePicker` | Material time picker dialog |
| `TimeOfDay.format(context)` | Locale-aware time display |
| `context.mounted` | Safety check after async gaps |
| Service class pattern | Wrapping native plugin (vs repository for SharedPreferences) |
| `mocktail` mocking | `Mock`, `when`, `verify` for testing cubit with service |

---

### Phase 16: User Profile — Forms & Validation ✅

**Goal:** Add a Profile screen to Settings, introducing Flutter's form and validation APIs.

#### Architecture
```
lib/features/profile/
├── data/
│   └── profile_repository.dart      # SharedPreferences (name, email, school, avatar)
└── presentation/
    ├── cubit/
    │   ├── profile_cubit.dart       # State management (saveProfile, updateAvatar)
    │   └── profile_state.dart       # Equatable (name, email, school, avatar?)
    └── screens/
        └── profile_screen.dart      # StatefulWidget with Form + TextFormFields
```

#### Key Classes

**ProfileAvatar** (`core/constants/profile_avatars.dart`) — Enum with 10 avatar options.

```dart
// Available options (each maps to a Material Icon)
ProfileAvatar.person       // Icons.person
ProfileAvatar.face         // Icons.face
ProfileAvatar.school       // Icons.school
ProfileAvatar.star         // Icons.star
ProfileAvatar.rocket       // Icons.rocket_launch
ProfileAvatar.pets         // Icons.pets
ProfileAvatar.sportsEsports // Icons.sports_esports
ProfileAvatar.musicNote    // Icons.music_note
ProfileAvatar.brush        // Icons.brush
ProfileAvatar.science      // Icons.science
```

**ProfileRepository** — SharedPreferences persistence for profile data.

```dart
final repository = await ProfileRepository.create();

// Save/load name, email, school (defaults: empty string)
await repository.saveName('Alice');
final name = repository.loadName();

// Save/load avatar (default: null)
await repository.saveAvatar(ProfileAvatar.star);
final avatar = repository.loadAvatar(); // ProfileAvatar? (null if not set)
```

**ProfileCubit** — State management for profile.

```dart
final cubit = ProfileCubit(repository: repository);

// Atomic save (used by form submit)
await cubit.saveProfile(
  name: 'Alice',
  email: 'alice@school.edu',
  school: 'Springfield Elementary',
  avatar: ProfileAvatar.star,
);

// Individual avatar update (used by grid selection)
await cubit.updateAvatar(ProfileAvatar.rocket);
```

**ProfileState** — Equatable state with nullable avatar.

```dart
const state = ProfileState(
  name: '',
  email: '',
  school: '',
  avatar: null, // ProfileAvatar? — null means "not yet chosen"
);
state.hasProfile; // false (name is empty)
```

**ProfileScreen** — `StatefulWidget` (first in settings) with Form.

```dart
// Key new concepts in this file:
GlobalKey<FormState> _formKey;           // Programmatic form access
TextEditingController _nameController;    // Pre-populate + read values
TextFormField(validator: _validateName);  // Inline validation
AutovalidateMode.onUserInteraction;       // Real-time after first submit
_formKey.currentState!.validate();        // Trigger all validators
RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$'); // Email regex
```

#### Validation Rules

| Field | Required | Rules |
|-------|----------|-------|
| Name | Yes | 2–50 chars, letters/spaces/hyphens only |
| Email | Yes | Valid email format (RegExp) |
| School | No | Max 100 chars |
| Avatar | Yes | Must select one from grid |

#### Key Concepts
| Concept | Usage |
|---------|-------|
| `Form` + `GlobalKey<FormState>` | Wraps fields for collective validation |
| `TextFormField` | Form-aware text input with built-in validation |
| `validator` callback | Returns null (valid) or error string (invalid) |
| `TextEditingController` | Pre-populate fields, read values, must dispose |
| `AutovalidateMode` | Disabled initially, enabled after first submit |
| `FormState.validate()` | Triggers all validators programmatically |
| `InputDecoration` | Labels, hints, error text styling |
| `RegExp` | Email format validation |
| `TextInputType.emailAddress` | Keyboard optimization for email input |
| `StatefulWidget` in settings | First stateful settings screen (controller lifecycle) |

---

### Phase 17: Location Detection — Device APIs & Permissions ✅

**Goal:** Add location detection to Profile, learning iOS device APIs, runtime permissions, and reverse geocoding.

#### Architecture
```
lib/features/profile/
├── data/
│   ├── profile_repository.dart      # + saveCity/loadCity, saveRegion/loadRegion
│   └── location_service.dart        # NEW — geolocator + geocoding wrapper
└── presentation/
    ├── cubit/
    │   ├── profile_cubit.dart       # + detectLocation() using LocationService
    │   └── profile_state.dart       # + city, region, isDetectingLocation
    └── screens/
        └── profile_screen.dart      # + Location section with Detect button
```

#### Key Classes

**LocationService** (`features/profile/data/location_service.dart`) — Wraps `geolocator` + `geocoding` plugins.

```dart
final service = await LocationService.create();

// Request iOS location permission
final granted = await service.requestPermission();

// Get city + region via GPS → reverse geocode
final result = await service.detectCityAndRegion();
// Returns ({String city, String region})? — null on error/denied
print(result?.city);    // "San Francisco"
print(result?.region);  // "California"
```

**Updated ProfileState** — Adds location fields.

```dart
const state = ProfileState(
  name: 'Alice',
  email: 'alice@school.edu',
  school: 'Springfield',
  avatar: ProfileAvatar.star,
  city: '',                    // NEW — from geocoding
  region: '',                  // NEW — from geocoding
  isDetectingLocation: false,  // NEW — loading state
);
```

**Updated ProfileCubit** — Adds location detection.

```dart
// Detect location (permission request + GPS + reverse geocode)
await cubit.detectLocation();

// State updates: isDetectingLocation → true → city/region updated → false
// Permission denied → stays unchanged, shows error
```

#### Dependencies
- `geolocator` — GPS location access (wraps Core Location on iOS)
- `geocoding` — Reverse geocoding (wraps CLGeocoder on iOS)

#### iOS Configuration
- `NSLocationWhenInUseUsageDescription` in Info.plist

#### Tests (15 new → 409 total at Phase 17)
- ProfileRepository: +6 (saveCity/loadCity 3, saveRegion/loadRegion 3)
- ProfileCubit: +6 (detectLocation success/denied/error, loading state, saveProfile with location)
- ProfileScreen: +3 (location section, detect button, pre-populated location)

#### Key Concepts
| Concept | Usage |
|---------|-------|
| `geolocator` | GPS position (latitude, longitude) via Core Location |
| `geocoding` | Reverse geocode coordinates to Placemark (city, state) |
| `Position` class | Latitude, longitude, accuracy from GPS |
| `Placemark` class | Locality, administrativeArea, country from geocoding |
| `NSLocationWhenInUseUsageDescription` | iOS permission string in Info.plist |
| Runtime permission flow | Request → check status → handle denied gracefully |
| Service composition | Cubit with both repository + service dependencies |
| Loading state in Cubit | `isDetectingLocation` bool for UI progress indicator |
| `mocktail` for LocationService | Mock native service in cubit tests |

---

### Phase 18: Internationalization (i18n) — English (US) & Spanish (MX)

**Goal:** Add multi-language support using Flutter's official ARB-based localization system with a language picker in Settings.

#### Architecture
```
lib/
├── l10n/
│   ├── app_en.arb                 # English template (~78 keys)
│   └── app_es.arb                 # Spanish translations
├── core/
│   └── l10n/
│       └── l10n.dart              # BuildContext extension (context.l10n)
└── features/
    └── settings/
        ├── data/
        │   └── locale_repository.dart    # SharedPreferences (languageCode)
        └── presentation/
            ├── cubit/
            │   ├── locale_cubit.dart     # Locale state management
            │   └── locale_state.dart     # Locale state class
            └── screens/
                └── language_screen.dart  # RadioListTile language picker

Root:
└── l10n.yaml                      # Code generation config
```

#### Key Classes

**AppLocalizations** (generated) — Access translated strings via `context.l10n`.

```dart
// Extension for concise access
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// Usage in widgets
Text(context.l10n.settingsTitle)  // "Settings" in English, "Configuración" in Spanish
```

**CalculationErrorType** — Enum for domain-layer error types (no BuildContext needed).

```dart
enum CalculationErrorType {
  divisionByZero, invalidExpression, overflow, undefined, generic
}

// Domain layer returns error types
final result = engine.evaluate('5 ÷ 0');
result.errorType; // CalculationErrorType.divisionByZero

// UI layer resolves to localized string
String _localizeError(CalculationErrorType type, AppLocalizations l10n) {
  switch (type) {
    case CalculationErrorType.divisionByZero: return l10n.errorDivisionByZero;
    // ...
  }
}
```

**LocaleRepository** — SharedPreferences persistence for language preference.

```dart
final repository = await LocaleRepository.create();
await repository.saveLocale('es');   // Spanish
final code = repository.loadLocale(); // 'es' or null (system default)
```

**LocaleCubit** — State management for locale selection.

```dart
final cubit = LocaleCubit(repository: repository);
await cubit.setLocale('es');    // Set Spanish
await cubit.setLocale(null);    // Set to system default
cubit.state.locale;             // Locale('es') or null
```

#### ARB File Format

```json
// app_en.arb (English template)
{
  "@@locale": "en",
  "settingsTitle": "Settings",
  "historyYesterday": "Yesterday {time}",
  "@historyYesterday": {
    "placeholders": {
      "time": { "type": "String" }
    }
  }
}
```

#### Key Concepts
| Concept | Usage |
|---------|-------|
| ARB file format | JSON-based translation files with metadata |
| `flutter gen-l10n` | Code generation for `AppLocalizations` class |
| `flutter_localizations` | SDK package for Material widget translations |
| `AppLocalizations.of(context)` | Access translated strings |
| `MaterialApp.locale` | Override system locale |
| `localizationsDelegates` | Delegates for localization (Material, Cupertino, app) |
| `supportedLocales` | List of supported locales |
| ICU message format | Parameterized strings with `{placeholders}` |
| `CalculationErrorType` enum | Domain-layer error types without BuildContext |
| Context extension (`context.l10n`) | Concise localization access pattern |
| `l10n.yaml` | Configuration for code generation |

#### Tests (26 new → 435 total)
- LocaleRepository: 9 tests (save/load locale, defaults, edge cases)
- LocaleCubit: 11 tests (initial state, setLocale, persistence)
- LanguageScreen: 6 tests (rendering, selection, navigation)

---

### Phase 19: Currency Converter with Bottom Navigation Bar

**Goal:** Add a currency converter using the free Frankfurter API, with a Material 3 NavigationBar to switch between Calculator and Currency modes.

#### Architecture
```
lib/features/
  home/
    presentation/screens/
      home_screen.dart              # NavigationBar + IndexedStack
  currency/
    data/
      currency_service.dart         # HTTP API calls (Frankfurter)
      currency_repository.dart      # Cache rates in SharedPreferences
    domain/
      currency_constants.dart       # Defaults, cache duration
    presentation/
      cubit/
        currency_cubit.dart         # State management
        currency_state.dart         # Sealed state classes
      screens/
        currency_screen.dart        # Converter UI
      widgets/
        currency_picker.dart        # Reusable dropdown
```

#### Key Classes

**CurrencyService** (`features/currency/data/currency_service.dart`) — HTTP client for Frankfurter API.

```dart
final service = CurrencyService(); // or CurrencyService(client: mockClient)

// Fetch available currencies
final currencies = await service.fetchCurrencies();
// {'USD': 'United States Dollar', 'EUR': 'Euro', ...}

// Fetch exchange rates
final rates = await service.fetchRates(base: 'USD');
// ExchangeRates(base: 'USD', date: '2026-02-07', rates: {'EUR': 0.92, ...})
```

**CurrencyRepository** (`features/currency/data/currency_repository.dart`) — Cache management.

```dart
final repository = await CurrencyRepository.create();

// Cache rates with TTL
await repository.saveRates('USD', {'EUR': 0.92, 'MXN': 17.15});
final fresh = repository.isCacheFresh('USD'); // true if < 1 hour old

// User preferences
await repository.saveFromCurrency('USD');
await repository.saveToCurrency('MXN');
```

**CurrencyCubit** (`features/currency/presentation/cubit/currency_cubit.dart`) — State management.

```dart
final cubit = CurrencyCubit(service: service, repository: repository);

await cubit.loadRates();           // cache-first: check cache → network fallback
cubit.updateAmount(100.0);         // recalculate conversion
await cubit.setFromCurrency('EUR');
await cubit.setToCurrency('MXN');
await cubit.swapCurrencies();      // swap from/to + recalculate
await cubit.refresh();             // force-refresh ignoring cache
```

**CurrencyState** — Sealed state classes:
- `CurrencyInitial` — before rates loaded (has fromCurrency, toCurrency)
- `CurrencyLoading` — fetching from API
- `CurrencyLoaded` — rates available (amount, result, rates, currencies, rateDate, isOfflineCache)
- `CurrencyError` — network/API failure with message

**HomeScreen** (`features/home/presentation/screens/home_screen.dart`) — Bottom navigation wrapper.

```dart
// Uses NavigationBar (Material 3) with IndexedStack
// Tab 0: Calculator (Icons.calculate)
// Tab 1: Currency   (Icons.currency_exchange)
// IndexedStack preserves state of both screens when switching
```

#### API: Frankfurter
- Base URL: `https://api.frankfurter.dev/v1`
- `GET /currencies` — list of supported currencies
- `GET /latest?base=USD` — latest exchange rates for base currency
- Free, no API key required, ~31 currencies

#### Key Concepts
| Concept | Usage |
|---------|-------|
| `http` package | HTTP GET requests, URI construction, JSON parsing |
| `http.Client` injection | Testability — mock client in tests |
| `jsonDecode` / `jsonEncode` | JSON serialization for API responses and cache |
| Cache-first strategy | Check local cache TTL → use cache or fetch from network |
| `NavigationBar` (Material 3) | Bottom navigation with tab switching |
| `IndexedStack` | Preserve state of inactive tabs |
| `DropdownButton<String>` | Currency selection UI |
| `TextField` + `TextEditingController` | Amount input with decimal keyboard |
| Offline handling | Show stale cache with banner, or error with retry |
| `CurrencyServiceException` | Typed exceptions for network/API errors |

#### Tests (74 new → 509 total)
- CurrencyService: 14 tests (fetch currencies, fetch rates, error handling, int-to-double parsing)
- CurrencyRepository: 22 tests (save/load rates, cache TTL, preferences, roundtrip, edge cases)
- CurrencyCubit: 17 tests (loadRates, convert, swap, error, offline cache, state equality)
- CurrencyScreen: 13 tests (loading, error, loaded, offline, initial states)
- HomeScreen: 8 tests (rendering, tab switching, IndexedStack behavior)

---

### Phase 20: Local Error Handling & Logging ✅

**Goal:** Add structured logging, defensive persistence, and global error boundaries.

1. **AppLogger Service ✅**
   - Injectable `AppLogger` wrapper around `logger` package
   - Log levels: `debug()`, `info()`, `warning()`, `error()`
   - Constructor injection for testability

2. **Repository Defensive Saves ✅**
   - All 7 repositories wrapped with try-catch on save methods
   - `@visibleForTesting` constructors for error-path tests
   - `AppLogger` field injected via constructor

3. **Database Error Handling ✅**
   - `HistoryRepository` wrapped with try-catch (returns safe defaults)
   - Custom `_FailingExecutor` in tests for Drift error simulation

4. **Cubit/Bloc Error Recovery ✅**
   - `HistoryCubit`: stream `onError` callback
   - `ReminderCubit`: try-catch around notification scheduling
   - `CalculatorBloc`: try-catch around history save + state save

5. **Global Error Boundaries ✅**
   - `runZonedGuarded` for unhandled async errors
   - `FlutterError.onError` for framework errors
   - `PlatformDispatcher.instance.onError` for platform errors
   - `ErrorWidget.builder` for friendly error UI
   - Fallback UI on initialization failure

6. **DI Wiring ✅**
   - Single `AppLogger` instance created in `main()`
   - Passed to all 7 repositories and relevant cubits/bloc

### Phase 10: Polish (Pending)

---

### AppLogger Tests (6 tests)

| Test Group | Tests |
|------------|-------|
| debug | 1 |
| info | 1 |
| warning | 1 |
| error | 1 |
| default logger | 1 |
| custom logger | 1 |

### Error Boundary Tests (2 tests)

| Test Group | Tests |
|------------|-------|
| sets FlutterError.onError | 1 |
| logs via AppLogger | 1 |

### App Error Widget Tests (3 tests)

| Test Group | Tests |
|------------|-------|
| renders icon | 1 |
| renders message | 1 |
| renders in MaterialApp | 1 |

---

## Quick Reference

### Running Tests
```bash
flutter test                    # All 558 tests
flutter test test/core/         # Engine + error handling (56)
flutter test test/features/calculator/     # Calculator (90 + 54 responsive)
flutter test test/features/theme/          # Theme (36)
flutter test test/features/history/        # History (39)
flutter test test/features/settings/       # Settings (64: a11y + locale + language)
flutter test test/features/reminder/       # Reminder (39)
flutter test test/features/profile/        # Profile (63)
flutter test test/features/currency/       # Currency (70)
flutter test test/features/home/           # Home/nav (8)
```

### Checking for Issues
```bash
flutter analyze
```

### Running the App
```bash
flutter run
```
