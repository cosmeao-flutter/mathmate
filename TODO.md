# MathMate - Development Todo

## Session Summary

**Date:** 2026-02-06
**Status:** Phase 15 Complete (Homework Reminder Notifications)

---

## Work Completed

### Phase 1: Project Setup ✅
- [x] Created Flutter project with `flutter create`
- [x] Configured `pubspec.yaml` with dependencies
- [x] Created clean architecture folder structure
- [x] Set iOS deployment target to 15.0 in Podfile
- [x] Created `analysis_options.yaml` with very_good_analysis

### Phase 2: Core Constants & Theme ✅
- [x] `app_colors.dart` - Color palette (blue accent)
- [x] `app_dimensions.dart` - Sizes, spacing, animations
- [x] `app_strings.dart` - Button labels, error messages
- [x] `app_theme.dart` - Material 3 light theme

### Phase 3: Calculator Engine (TDD) ✅
- [x] Wrote 45 tests first (TDD approach)
- [x] `calculator_engine.dart` - Expression evaluator
- [x] All 45 tests passing
- [x] Features: PEMDAS, auto-balance, implicit multiply, percentages

### Phase 4: Domain Models ✅
- [x] `calculator_event.dart` - 11 sealed event classes
- [x] `calculator_state.dart` - 4 sealed state classes

### Phase 5: Calculator BLoC (TDD) ✅
- [x] Wrote 34 tests first (TDD approach)
- [x] `calculator_bloc.dart` - State management
- [x] All 34 tests passing
- [x] Features: event handlers, live preview, error recovery

### Phase 6: UI Widgets (TDD) ✅
- [x] `calculator_button.dart` - 14 tests
  - Rounded rectangle buttons with press animation (scale to 0.95)
  - Color variants: number (white), operator (blue), function (gray), equals (blue)
  - Haptic feedback on press
  - Accessibility support with semantic labels
- [x] `calculator_display.dart` - 18 tests
  - Dual-line display (expression top, result bottom)
  - Error message display (replaces result in red)
  - Right-aligned text with correct font sizes
- [x] `calculator_keypad.dart` - 27 tests
  - 6×4 grid with all buttons
  - All button callbacks wired (digits, operators, functions, parentheses)
  - Correct button types for styling

---

### Phase 7: Main Screen & Integration ✅
- [x] Created `calculator_screen.dart`:
  - Combined display and keypad widgets
  - Wrapped with BlocProvider
  - Wired keypad callbacks to BLoC events
  - Wired display to BLoC state with BlocBuilder
- [x] Created `app.dart`:
  - Root widget with AppTheme.light
  - Provided calculator screen as home
- [x] Updated `main.dart`:
  - Replaced default Flutter template
  - Launch the app
- [x] Tested on iOS Simulator - App runs correctly

---

### Phase 7.5: Keypad Layout Update ✅
- [x] Updated `calculator_keypad.dart` to 6×4 grid layout:
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
- [x] Added `BackspacePressed` event to BLoC
- [x] Added `onBackspacePressed` callback to keypad
- [x] Removed `onClearPressed` (C button removed, using only AC and ⌫)
- [x] Updated `app_strings.dart` with backspace label
- [x] Updated `calculator_screen.dart` to wire backspace
- [x] Updated keypad tests for new layout (27 tests)
- [x] Tested on iOS Simulator - New layout works correctly

---

### Phase 8: Persistence ✅
- [x] Created `calculator_repository.dart` - SharedPreferences wrapper (17 tests)
  - `saveState()` - saves expression and result
  - `loadState()` - restores saved state
  - `clearState()` - removes saved state
  - `hasState` - checks if state exists
- [x] Updated `calculator_bloc.dart` to use repository:
  - Accepts optional repository in constructor
  - Loads saved state on `CalculatorStarted` event
  - Auto-saves state on every state change via `onChange`
  - Clears saved state on `AllClearPressed`
- [x] Updated `main.dart` to initialize repository at app startup
- [x] Updated `app.dart` to pass repository to calculator screen
- [x] Updated `calculator_screen.dart` to pass repository to BLoC
- [x] Added 7 persistence tests to BLoC tests (now 41 total)
- [x] Tested on iOS Simulator - State persists across app restarts

---

## Current Work

### Phase 9: Full Theme System ✅
**Goal:** Dark mode + system theme following + custom accent colors

#### 9.1 Dark Theme ✅
- [x] Create dark color palette in `AppColors` (70+ dark color constants)
- [x] Create `AppTheme.dark` theme data
- [x] Create `CalculatorColors` ThemeExtension for theme-aware widget colors
- [x] Update `calculator_button.dart` to use theme colors
- [x] Update `calculator_display.dart` to use theme colors
- [x] Update widget tests to use `AppTheme.light` with extension

#### 9.2 System Theme Following ✅
- [x] Support `ThemeMode.system` in MaterialApp
- [x] Add `darkTheme: AppTheme.dark` to MaterialApp
- [x] Remove hardcoded background color from calculator_screen.dart
- [x] Reactive updates when system theme changes

#### 9.3 Custom Accent Colors ✅
- [x] Created `AccentColor` enum with 5 options (blue, green, purple, orange, teal)
- [x] Defined light/dark color palettes for each accent in `accent_colors.dart`
- [x] Added `CalculatorColors.fromAccentLight/Dark()` factory methods
- [x] Added `AppTheme.lightWithAccent/darkWithAccent()` methods
- [x] All 163 tests passing

#### 9.4 Theme State Management ✅
- [x] Created `ThemeCubit` for theme state (15 tests)
- [x] Methods: `setThemeMode()`, `setAccentColor()`
- [x] State: `ThemeState` with themeMode and accentColor

#### 9.5 Theme Persistence ✅
- [x] Created `ThemeRepository` for saving preferences (19 tests)
- [x] Save/load theme mode preference
- [x] Save/load accent color preference
- [x] Defaults: system theme mode, blue accent

#### 9.6 Integration & Testing ✅
- [x] Wire theme system to MaterialApp via BlocProvider/BlocBuilder
- [x] Add settings button (⚙) to calculator keypad
- [x] Created settings bottom sheet with theme mode selector and color picker
- [x] All 197 tests passing
- [x] Tested on iOS Simulator

---

## Current Work

### Phase 11: Calculation History (Enhanced Local Persistence)
**Goal:** Store calculation history using Drift (SQLite ORM) to learn structured database storage

#### 11.1 Database Setup ✅
- [x] Add `drift` and `drift_dev` dependencies to pubspec.yaml
- [x] Create `HistoryEntry` table schema (id, expression, result, timestamp)
- [x] Create `HistoryDatabase` class with Drift annotations
- [x] Run build_runner to generate database code
- [x] Write migration strategy for future schema changes

#### 11.2 History Repository (TDD) ✅
- [x] Write tests first for `HistoryRepository` (21 tests)
- [x] `addEntry(expression, result)` - inserts new history entry
- [x] `getAllEntries()` - returns Stream<List<HistoryEntry>> (reactive)
- [x] `deleteEntry(id)` - removes single entry
- [x] `clearAll()` - removes all history
- [x] `getEntryCount()` - returns count for UI badge

#### 11.3 History State Management ✅
- [x] Create `HistoryCubit` for history state (13 tests)
- [x] State: `HistoryState` sealed class (HistoryInitial, HistoryLoading, HistoryLoaded)
- [x] Methods: `load()`, `delete(id)`, `clearAll()`
- [x] Write cubit tests with TDD

#### 11.4 History UI ✅
- [x] Create history button (🕐) in keypad (replace empty slot)
- [x] Create `HistoryBottomSheet` widget
  - DraggableScrollableSheet with list of past calculations
  - Tap entry to load into calculator
  - Swipe to delete individual entry (Dismissible)
  - "Clear All" button with confirmation dialog
  - Empty state when no history
- [x] Wire to CalculatorBloc (load expression via HistoryEntryLoaded event)

#### 11.5 Integration ✅
- [x] Initialize database in main.dart
- [x] Provide HistoryCubit via MultiBlocProvider in app.dart
- [x] Save to history on EqualsPressed (successful calculations only)
- [x] Update tests count (231 total)
- [x] Test on iOS Simulator

**New concepts learned:**
- Drift ORM for SQLite
- Code generation with build_runner
- Reactive database queries (Streams)
- Database migrations
- Dismissible widgets (swipe to delete)

---

### Phase 12: Accessibility & Settings Expansion ✅
**Goal:** Expand settings bottom sheet with accessibility features (P1 priority)

#### 12.1 Accessibility Repository (TDD) ✅
- [x] Write 19 tests first (TDD approach)
- [x] Create `accessibility_repository.dart` (SharedPreferences)
- [x] Methods:
  - `saveReduceMotion(bool)` / `loadReduceMotion()` → default: false
  - `saveHapticFeedback(bool)` / `loadHapticFeedback()` → default: true
  - `saveSoundFeedback(bool)` / `loadSoundFeedback()` → default: false

#### 12.2 Accessibility State Management (TDD) ✅
- [x] Write 14 cubit tests first (TDD approach)
- [x] Create `AccessibilityState` class with `Equatable`
- [x] Create `AccessibilityCubit` with methods:
  - `setReduceMotion(bool)` - persists and emits
  - `setHapticFeedback(bool)` - persists and emits
  - `setSoundFeedback(bool)` - persists and emits

#### 12.3 Settings UI Update ✅
- [x] Add accessibility strings to `app_strings.dart`
- [x] Create `_AccessibilityToggle` widget with `SwitchListTile`
- [x] Update `SettingsBottomSheet`:
  - Added "Appearance" section header
  - Added "Accessibility" section with 3 toggles
  - Uses nested `BlocBuilder` for both cubits

#### 12.4 Integration ✅
- [x] Initialize `AccessibilityRepository` in `main.dart`
- [x] Provide `AccessibilityCubit` via `MultiBlocProvider` in `app.dart`
- [x] Update `CalculatorButton` to respect settings:
  - Skip animation if `reduceMotion` is true
  - Skip haptic if `hapticFeedback` is false
  - (Sound feedback placeholder - requires audioplayers package)

#### 12.5 Testing & Verification ✅
- [x] All 33 new tests pass (19 repository + 14 cubit)
- [x] All 231 existing tests pass (264 total)
- [x] Updated widget tests with AccessibilityCubit provider
- [x] Test on iOS Simulator - settings accessible via gear button

**New concepts learned:**
- Accessibility toggles (reduce motion, haptics)
- SharedPreferences for boolean settings
- Nested BlocBuilders for multiple cubits
- Widget test setup with multiple providers

---

### Phase 13: Navigation & Settings Screens ✅
**Goal:** Learn Navigator 1.0 by replacing settings bottom sheet with proper screen navigation

#### 13.1 Settings Screen ✅
- [x] Create `settings_screen.dart` - main settings menu
  - AppBar with "Settings" title (back button auto-added)
  - ListView with ListTile menu items
  - "Appearance" tile → navigates to AppearanceScreen
  - "Accessibility" tile → navigates to AccessibilityScreen

#### 13.2 Appearance Screen ✅
- [x] Create `appearance_screen.dart` - theme settings
  - Extract theme mode selector from SettingsBottomSheet
  - Extract accent color picker from SettingsBottomSheet
  - AppBar with "Appearance" title

#### 13.3 Accessibility Screen ✅
- [x] Create `accessibility_screen.dart` - accessibility settings
  - Extract accessibility toggles from SettingsBottomSheet
  - AppBar with "Accessibility" title

#### 13.4 Navigation Integration ✅
- [x] Update `calculator_screen.dart`:
  - Change ⚙ button to call `Navigator.push()` instead of showing bottom sheet
- [x] Add navigation strings to `app_strings.dart`:
  - Appearance subtitle: "Theme, accent color"
  - Accessibility subtitle: "Reduce motion, haptic feedback"

#### 13.5 Verification ✅
- [x] All 264 tests pass
- [x] Test navigation flow on iOS Simulator
- [ ] (Optional) Remove old `settings_bottom_sheet.dart` in future cleanup

**New concepts learned:**
- `Navigator.push()` / `Navigator.pop()`
- `MaterialPageRoute`
- AppBar with automatic back button
- Screen composition patterns
- Extracting widgets into standalone screens

---

### Phase 14: Responsive & Adaptive UI ✅
**Goal:** Make the calculator adapt to different phone sizes (iPhone SE → Pro Max) and work in both portrait and landscape orientations

- [x] 14.1 ResponsiveDimensions value class (18 tests)
- [x] 14.2 Update CalculatorButton with responsive dimensions (7 tests)
- [x] 14.3 Update CalculatorDisplay with responsive dimensions + FittedBox (7 tests)
- [x] 14.4 Update CalculatorKeypad with responsive dimensions (7 tests)
- [x] 14.5-14.6 CalculatorScreen responsive + landscape layout (11 tests)
- [x] 14.7 Verification - all 314 tests pass, tested on simulator

---

## Current Work

### Phase 14b: Landscape Keypad Redesign (4×6 Grid) ✅
**Goal:** Improve landscape layout by using display-on-top with a wider 4×6 keypad grid instead of side-by-side Row

- [x] 14b.1 Update screen landscape test (Column assertion instead of Row)
- [x] 14b.2 Change `_buildLandscape()` from Row to Column
- [x] 14b.3 Add 4 landscape keypad grid tests
- [x] 14b.4 Implement `_buildLandscapeGrid()` with 4×6 layout
- [x] 14b.5 Fix displayPadding scaling (use spacingScale for landscape)
- [x] 14b.6 Verification - all 318 tests pass, tested on simulator

**New concepts learned:**
- Orientation-aware grid layout (6×4 portrait vs 4×6 landscape)
- Extracting layout variants (`_buildPortraitGrid` / `_buildLandscapeGrid`)
- Aggressive spacing reduction for tight viewport fitting

---

### Phase 15: Homework Reminder Notifications ✅
**Goal:** Add a daily homework reminder notification via Settings, learning local notifications, timezone handling, permission flows, and the `showTimePicker` widget.

#### 15.1 Dependencies & iOS Config ✅
- [x] Add `flutter_local_notifications`, `timezone`, `flutter_timezone` to pubspec.yaml
- [x] Run `flutter pub get`

#### 15.2 ReminderRepository (TDD) ✅
- [x] Write 18 tests first for `ReminderRepository`
- [x] Implement `reminder_repository.dart` (SharedPreferences: enabled, hour, minute)

#### 15.3 NotificationService ✅
- [x] Implement `notification_service.dart` (flutter_local_notifications wrapper)
  - `create()` — initialize plugin + timezone (with UTC fallback)
  - `requestPermission()` — iOS permission dialog, returns bool
  - `scheduleDailyReminder(hour, minute)` — daily via `zonedSchedule`
  - `cancelReminder()` — cancel by notification ID

#### 15.4 ReminderCubit + State (TDD) ✅
- [x] Write 16 cubit tests first (mock NotificationService with mocktail)
- [x] Implement `reminder_state.dart` (Equatable: isEnabled, hour, minute)
- [x] Implement `reminder_cubit.dart` (orchestrates repository + service)
  - `setReminderEnabled(bool)` — permission-gated, schedules/cancels
  - `setReminderTime(TimeOfDay)` — persists + reschedules if enabled

#### 15.5 Reminder Screen + Settings Integration ✅
- [x] Add reminder strings to `app_strings.dart`
- [x] Create `reminder_screen.dart` (SwitchListTile + time picker ListTile)
- [x] Add Reminder ListTile to `settings_screen.dart`

#### 15.6 DI Wiring ✅
- [x] Initialize `ReminderRepository` + `NotificationService` in `main.dart`
- [x] Add `ReminderCubit` to `MultiBlocProvider` in `app.dart`

#### 15.7 Verification ✅
- [x] All 352 tests pass (318 + 34 new)
- [x] `flutter analyze` — info only (no errors/warnings)
- [x] Test on iOS Simulator

**New concepts learned:**
- `flutter_local_notifications` plugin setup and scheduling
- Timezone handling (`timezone`, `flutter_timezone`, `TZDateTime`)
- `zonedSchedule` with `DateTimeComponents.time` for daily recurrence
- iOS notification permission flow
- Service class pattern (vs repository pattern)
- Cubit with multiple dependencies (repo + service)
- Mocking with `mocktail` (`Mock`, `when`, `verify`)
- `showTimePicker` + `TimeOfDay.format(context)`
- `context.mounted` check after async gaps
- `unawaited()` for fire-and-forget futures in UI callbacks

---

## Future Work

### Phase 10: Polish
- [ ] Smooth animations (250-350ms)
- [ ] Error prevention (disable invalid buttons)

---

## MVP Checklist

- [x] Project setup
- [x] Color scheme and theme
- [x] Calculator engine with PEMDAS
- [x] BLoC events and states (domain models)
- [x] BLoC implementation
- [x] Calculator button widget
- [x] Calculator display widget
- [x] Calculator keypad widget (6×4 layout)
- [x] Main calculator screen
- [x] State persistence
- [x] Full theme system (dark mode, system following, accent colors)
- [x] Calculation history with Drift database (Phase 11)
- [x] Accessibility settings (reduce motion, haptic feedback, sound feedback)
- [x] Navigation & Settings Screens (Phase 13)
- [x] Responsive UI with landscape support (Phase 14)
- [x] Homework reminder notifications (Phase 15)
- [x] All tests passing (352 tests)
- [x] Runs on iOS Simulator

**MVP COMPLETE + ACCESSIBILITY + NAVIGATION + RESPONSIVE + REMINDERS!**

---

## Files Created

```
lib/
├── main.dart                    ✅ (UPDATED - initializes both repositories)
├── app.dart                     ✅ (UPDATED - ThemeCubit + dynamic theming)
├── core/
│   ├── constants/
│   │   ├── accent_colors.dart   ✅ (AccentColor enum + palettes)
│   │   ├── app_colors.dart      ✅ (dark theme colors)
│   │   ├── app_dimensions.dart  ✅
│   │   ├── app_strings.dart     ✅ (UPDATED - settings strings)
│   │   └── responsive_dimensions.dart  ✅ (Phase 14 - responsive scaling)
│   ├── theme/
│   │   ├── app_theme.dart       ✅ (accent color methods)
│   │   └── calculator_colors.dart ✅ (accent factories)
│   └── utils/
│       └── calculator_engine.dart ✅
├── features/
│   ├── calculator/
│   │   ├── data/
│   │   │   └── calculator_repository.dart ✅
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── calculator_bloc.dart  ✅
│   │       │   ├── calculator_event.dart ✅
│   │       │   └── calculator_state.dart ✅
│   │       ├── screens/
│   │       │   └── calculator_screen.dart ✅ (UPDATED - settings button)
│   │       └── widgets/
│   │           ├── calculator_button.dart  ✅
│   │           ├── calculator_display.dart ✅
│   │           └── calculator_keypad.dart  ✅ (UPDATED - settings callback)
│   ├── theme/                   ✅ (Phase 9.4-9.6)
│   │   ├── data/
│   │   │   └── theme_repository.dart ✅ (theme persistence)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── theme_cubit.dart  ✅ (theme state management)
│   │       │   └── theme_state.dart  ✅ (theme state)
│   │       └── widgets/
│   │           └── settings_bottom_sheet.dart ✅ (settings UI)
│   ├── history/                 ✅ (Phase 11)
│   │   ├── data/
│   │   │   ├── history_database.dart    ✅ (Drift database)
│   │   │   ├── history_database.g.dart  ✅ (generated code)
│   │   │   └── history_repository.dart  ✅ (history CRUD)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── history_cubit.dart   ✅ (history state)
│   │       │   └── history_state.dart   ✅ (history state class)
│   │       └── widgets/
│   │           └── history_bottom_sheet.dart ✅ (history UI)
│   ├── settings/                ✅ (Phase 12 + Phase 13)
│   │   ├── data/
│   │   │   └── accessibility_repository.dart  ✅ (accessibility persistence)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── accessibility_cubit.dart   ✅ (accessibility state)
│   │       │   └── accessibility_state.dart   ✅ (accessibility state class)
│   │       └── screens/              ✅ (Phase 13 - Navigation)
│   │           ├── settings_screen.dart       ✅ (settings menu)
│   │           ├── appearance_screen.dart     ✅ (theme settings)
│   │           └── accessibility_screen.dart  ✅ (accessibility settings)
│   └── reminder/                 ✅ (Phase 15)
│       ├── data/
│       │   ├── reminder_repository.dart       ✅ (reminder persistence)
│       │   └── notification_service.dart      ✅ (flutter_local_notifications wrapper)
│       └── presentation/
│           ├── cubit/
│           │   ├── reminder_cubit.dart        ✅ (reminder state management)
│           │   └── reminder_state.dart        ✅ (reminder state class)
│           └── screens/
│               └── reminder_screen.dart       ✅ (reminder settings UI)
└── docs.md                      ✅

test/
├── core/
│   └── utils/
│       └── calculator_engine_test.dart ✅ (45 tests)
└── features/
    ├── calculator/
    │   ├── data/
    │   │   └── calculator_repository_test.dart ✅ (17 tests)
    │   └── presentation/
    │       ├── bloc/
    │       │   └── calculator_bloc_test.dart ✅ (41 tests)
    │       └── widgets/
    │           ├── calculator_button_test.dart  ✅ (14 tests)
    │           ├── calculator_display_test.dart ✅ (18 tests)
    │           └── calculator_keypad_test.dart  ✅ (27 tests)
    ├── theme/                   ✅ (Phase 9)
    │   ├── data/
    │   │   └── theme_repository_test.dart ✅ (19 tests)
    │   └── presentation/
    │       └── cubit/
    │           └── theme_cubit_test.dart ✅ (15 tests)
    ├── history/                 ✅ (Phase 11)
    │   ├── data/
    │   │   └── history_repository_test.dart ✅ (21 tests)
    │   └── presentation/
    │       └── cubit/
    │           └── history_cubit_test.dart ✅ (13 tests)
    ├── settings/                ✅ (Phase 12 complete)
    │   ├── data/
    │   │   └── accessibility_repository_test.dart ✅ (19 tests)
    │   └── presentation/
    │       └── cubit/
    │           └── accessibility_cubit_test.dart ✅ (14 tests)
    └── reminder/                 ✅ (Phase 15)
        ├── data/
        │   └── reminder_repository_test.dart ✅ (18 tests)
        └── presentation/
            └── cubit/
                └── reminder_cubit_test.dart ✅ (16 tests)

Root:
├── pubspec.yaml                 ✅
├── analysis_options.yaml        ✅
├── prd.md                       ✅
└── TODO.md                      ✅ (this file)
```

---

## Quick Commands

```bash
# Run all tests (352 total)
flutter test

# Run engine tests only (45)
flutter test test/core/

# Run calculator repository tests only (17)
flutter test test/features/calculator/data/

# Run calculator BLoC tests only (41)
flutter test test/features/calculator/presentation/bloc/

# Run widget tests only (59)
flutter test test/features/calculator/presentation/widgets/

# Run theme tests (34 total: 19 repository + 15 cubit)
flutter test test/features/theme/

# Run history tests (34 total: 21 repository + 13 cubit)
flutter test test/features/history/

# Run settings tests (33 total: 19 repository + 14 cubit)
flutter test test/features/settings/

# Run reminder tests (~35 total: ~17 repository + ~18 cubit)
flutter test test/features/reminder/

# Analyze code
flutter analyze

# Run app
flutter run
```

---

## Notes

**Current Focus: Phase 10 - Polish (next)**

**Previous Commits:**
- `1291ab9` - feat: add responsive UI with orientation support (Phase 14/14b)
- `44bacbd` - feat: add navigation screens for settings (Phase 13)
- `5420666` - feat: add accessibility settings with reduce motion and haptic toggles (Phase 12)
- `20908fa` - chore: add CLAUDE.md project instructions
- `5278b31` - feat: add history UI, state management and calculator integration (Phase 11.3-11.5)
- `b66bdb9` - feat: add calculation history with Drift database (Phase 11.1-11.2)

**Skills Available:**
- `/start-session` - Initialize coding session with project context
- `/end-session` - Wrap up session and update documentation
- `/commit` - Stage and commit with auto-generated message (asks for review)

**Last Session Completed:**
- Implemented Phase 15 - Homework Reminder Notifications
  - Added `flutter_local_notifications`, `timezone`, `flutter_timezone` dependencies
  - ReminderRepository with SharedPreferences persistence (18 tests)
  - NotificationService wrapping flutter_local_notifications (with UTC fallback)
  - ReminderCubit orchestrating repo + service with permission gating (16 tests)
  - ReminderScreen with SwitchListTile + showTimePicker
  - Settings screen updated with Reminder navigation tile
  - DI wiring in main.dart and app.dart
  - All 352 tests passing, tested on iOS Simulator

**Next Priority: Phase 10 - Polish**
1. Smooth animations (250-350ms)
2. Error prevention (disable invalid buttons)
