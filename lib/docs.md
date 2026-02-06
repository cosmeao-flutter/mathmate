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
├── main.dart                  # ✅ App entry point (initializes repository)
├── app.dart                   # ✅ Root MaterialApp widget
├── core/
│   ├── constants/
│   │   ├── app_colors.dart    # ✅ Color palette definitions
│   │   ├── app_dimensions.dart # ✅ Sizes, spacing, animation durations
│   │   └── app_strings.dart   # ✅ Button labels, error messages
│   ├── theme/
│   │   └── app_theme.dart     # ✅ Light theme configuration
│   └── utils/
│       └── calculator_engine.dart # ✅ Expression evaluation engine
├── features/
│   └── calculator/
│       ├── data/
│       │   └── calculator_repository.dart # ✅ State persistence
│       ├── domain/            # (future) Domain models
│       └── presentation/
│           ├── bloc/
│           │   ├── calculator_bloc.dart   # ✅ State management
│           │   ├── calculator_event.dart  # ✅ Event classes
│           │   └── calculator_state.dart  # ✅ State classes
│           ├── screens/
│           │   └── calculator_screen.dart # ✅ Main screen with BLoC
│           └── widgets/
│               ├── calculator_button.dart  # ✅ Reusable button
│               ├── calculator_display.dart # ✅ Dual-line display
│               └── calculator_keypad.dart  # ✅ 6×4 button grid
└── docs.md                    # This file

test/
├── core/
│   └── utils/
│       └── calculator_engine_test.dart  # ✅ 45 tests
└── features/
    └── calculator/
        ├── data/
        │   └── calculator_repository_test.dart # ✅ 17 tests
        └── presentation/
            ├── bloc/
            │   └── calculator_bloc_test.dart  # ✅ 41 tests
            └── widgets/
                ├── calculator_button_test.dart  # ✅ 14 tests
                ├── calculator_display_test.dart # ✅ 18 tests
                └── calculator_keypad_test.dart  # ✅ 27 tests
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
  print(result.errorMessage);
} else {
  print(result.displayValue); // "14"
}
```

**Features:**
- PEMDAS order of operations
- Auto-balances unclosed parentheses
- Implicit multiplication: `2(3)` → `2*(3)`
- Percentage handling: `50%` → `0.5`

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
| `CalculatorError` | `errorMessage: String` | Error occurred |

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
)
```

**Layout (6×4 grid):**
```
┌─────┬─────┬─────┬─────┐
│ AC  │  ⌫  │     │     │  ← Control row (2 slots for future)
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

---

## Test Coverage

**Total: 163 tests, all passing**

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

### Calculator Repository Tests (17 tests)

| Test Group | Tests |
|------------|-------|
| saveState | 4 |
| loadState | 4 |
| clearState | 2 |
| hasState | 4 |
| Edge Cases | 3 |

### Calculator BLoC Tests (41 tests)

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

### Calculator Button Tests (14 tests)

| Test Group | Tests |
|------------|-------|
| Rendering | 3 |
| Interaction | 2 |
| Button Types | 5 |
| Press Animation | 2 |
| Accessibility | 2 |

### Calculator Display Tests (18 tests)

| Test Group | Tests |
|------------|-------|
| Expression Display | 4 |
| Result Display | 4 |
| Initial State | 2 |
| Error State | 4 |
| Layout | 3 |
| Accessibility | 1 |

### Calculator Keypad Tests (27 tests)

| Test Group | Tests |
|------------|-------|
| Layout | 7 |
| Digit Callbacks | 3 |
| Operator Callbacks | 4 |
| Function Callbacks | 6 |
| Parenthesis Callbacks | 2 |
| Button Types | 5 |

---

## Development Progress

### Phase 1: Project Setup ✅
### Phase 2: Core Constants & Theme ✅
### Phase 3: Calculator Engine ✅
### Phase 4: Domain Models ✅
### Phase 5: Calculator BLoC ✅
### Phase 6: UI Widgets ✅
- `calculator_button.dart` - 14 tests
- `calculator_display.dart` - 18 tests
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

### Phase 9: Full Theme System (In Progress)

**Goal:** Implement dark mode, system theme following, and custom accent colors.

**Completed:**

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

**Remaining:**

4. **Theme State Management**
   - `ThemeCubit` manages theme state
   - State: current mode (light/dark/system), current accent color

5. **Theme Persistence**
   - `ThemeRepository` saves/loads preferences via SharedPreferences
   - Persists theme mode and accent color
   - Loads on app start

6. **Integration & UI**
   - Wire theme system to MaterialApp
   - Add settings UI with color picker

---

### Phase 10: Polish (Pending)

---

## Quick Reference

### Running Tests
```bash
flutter test                    # All 163 tests
flutter test test/core/         # Engine tests (45)
flutter test test/features/calculator/data/                 # Repository tests (17)
flutter test test/features/calculator/presentation/bloc/    # BLoC tests (41)
flutter test test/features/calculator/presentation/widgets/ # Widget tests (59)
```

### Checking for Issues
```bash
flutter analyze
```

### Running the App
```bash
flutter run
```
