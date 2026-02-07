# MathMate - Development Todo

## Session Summary

**Date:** 2026-02-07
**Status:** Phase 19 complete — 509 tests passing + iOS smoke test passed

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

## Current Work

### Phase 16: User Profile — Forms & Validation ✅
**Goal:** Add a Profile screen to Settings, learning Flutter's Form, TextFormField, validation APIs, TextEditingController lifecycle, and RegExp validation.

#### 16.0 Documentation Update ✅
- [x] Update TODO.md, docs.md, categories.md with Phase 16 plan

#### 16.1 Constants ✅
- [x] Create `profile_avatars.dart` — `ProfileAvatar` enum with 10 Material Icons
- [x] Add profile strings to `app_strings.dart` — labels, hints, validation errors

#### 16.2 ProfileRepository (TDD, 18 tests) ✅
- [x] Write 18 tests first for `ProfileRepository`
- [x] Implement `profile_repository.dart` (SharedPreferences: name, email, school, avatar)

#### 16.3 ProfileCubit + State (TDD, 12 tests) ✅
- [x] Write 12 cubit tests first
- [x] Implement `profile_state.dart` (Equatable, copyWith, nullable avatar)
- [x] Implement `profile_cubit.dart` (saveProfile, updateAvatar)

#### 16.4 Profile Screen UI ✅
- [x] Implement `profile_screen.dart` (StatefulWidget with Form)
  - Form + GlobalKey<FormState>
  - TextFormField with validators (name, email, school)
  - Avatar grid with selection
  - Save button with validation flow
  - TextEditingController lifecycle (init/dispose)
  - AutovalidateMode (disabled → onUserInteraction after first submit)

#### 16.5 Profile Screen Widget Tests (12 tests) ✅
- [x] Rendering tests (5): title, fields, avatar grid, save button, pre-populated
- [x] Validation tests (5): name required, email required, email invalid, avatar required, name too short
- [x] Submission tests (2): saves when valid, shows success snackbar

#### 16.6 Integration & Wiring ✅
- [x] Add Profile ListTile to `settings_screen.dart` (top of list)
- [x] Initialize ProfileRepository in `main.dart`
- [x] Provide ProfileCubit in `app.dart` MultiBlocProvider
- [x] All 394 tests pass (352 + 42 new)
- [x] Test on iOS Simulator

**New concepts learned:**
- `Form` widget + `GlobalKey<FormState>`
- `TextFormField` with `validator` callbacks
- `TextEditingController` lifecycle (init/dispose)
- `AutovalidateMode` (disabled → onUserInteraction)
- `FormState.validate()` / form submission flow
- `InputDecoration` (labels, hints, error styling)
- `RegExp` for email validation
- `TextInputType.emailAddress` for keyboard optimization

---

## Current Work

### Phase 17: Location Detection — Device APIs & Permissions
**Goal:** Add location detection to Profile, learning iOS device APIs (`geolocator`, `geocoding`), runtime permission flows, reverse geocoding, and service composition in Cubits.

#### 17.0 Documentation Update
- [x] Update TODO.md, docs.md, categories.md with Phase 17 plan

#### 17.1 Dependencies & iOS Config ✅
- [x] Add `geolocator` and `geocoding` packages to pubspec.yaml
- [x] Add `NSLocationWhenInUseUsageDescription` to `ios/Runner/Info.plist`
- [x] Run `flutter pub get`

#### 17.2 LocationService ✅
- [x] Create `location_service.dart` in `features/profile/data/`
  - `create()` — factory constructor
  - `requestPermission()` — requests iOS location permission, returns bool
  - `detectCityAndRegion()` → `Future<({String city, String region})?>`

#### 17.3 Update ProfileRepository (TDD, +6 tests → 24 total) ✅
- [x] Write 6 new tests for city/region persistence
- [x] Add `saveCity(String)` / `loadCity()` methods
- [x] Add `saveRegion(String)` / `loadRegion()` methods

#### 17.4 Update ProfileState & ProfileCubit (TDD, +6 tests → 18 total) ✅
- [x] Add `city` and `region` to ProfileState
- [x] Add `isDetectingLocation` bool to state
- [x] Add `detectLocation()` method (uses LocationService)
- [x] Update `saveProfile()` to include city and region
- [x] Add LocationService as cubit dependency (mock with mocktail in tests)

#### 17.5 Update ProfileScreen UI & Tests (+3 tests → 15 screen total) ✅
- [x] Add Location section below school field
- [x] Add location strings to `app_strings.dart`
- [x] Write 3 new screen tests

#### 17.6 Integration & Wiring ✅
- [x] Create LocationService in `main.dart`
- [x] Pass LocationService to ProfileCubit in `app.dart`
- [x] All 409 tests pass (394 + 15 new)
- [x] Test on iOS Simulator

**New concepts learned:**
- `geolocator` plugin for GPS coordinates (wraps Core Location)
- `geocoding` plugin for reverse geocoding (wraps CLGeocoder)
- iOS `NSLocationWhenInUseUsageDescription` in Info.plist
- Runtime permission request flow (request → check → handle denied)
- Service composition (cubit with both repository + service dependencies)
- Loading states in Cubit (`isDetectingLocation`)
- Dart record types `({String city, String region})` for structured returns
- `mocktail` for mocking native services in cubit tests

---

### Phase 18: Internationalization (i18n) — English (US) & Spanish (MX) ✅
**Goal:** Add multi-language support using Flutter's ARB-based localization system with a language picker in Settings.

#### 18.1 Dependencies & Configuration ✅
- [x] Add `flutter_localizations` SDK dependency to `pubspec.yaml`
- [x] Add `generate: true` under `flutter:` section
- [x] Create `l10n.yaml` at project root
- [x] Run `flutter pub get` + `flutter gen-l10n`

#### 18.2 ARB Files — English & Spanish Translations ✅
- [x] Create `lib/l10n/app_en.arb` with ~85 translatable keys
- [x] Create `lib/l10n/app_es.arb` with full Spanish translations
- [x] Run `flutter gen-l10n` to generate `AppLocalizations`

#### 18.3 Context Extension + Error Type Enum ✅
- [x] Create `lib/core/l10n/l10n.dart` with `context.l10n` extension
- [x] Create `CalculationErrorType` enum in `calculator_engine.dart`
- [x] Refactor `CalculationResult.errorMessage` → `CalculationResult.errorType`
- [x] Update `CalculatorError` state, BLoC, and screen

#### 18.4 LocaleRepository (TDD, 9 tests) ✅
- [x] Write tests first for `LocaleRepository`
- [x] Implement `locale_repository.dart` (SharedPreferences: languageCode)

#### 18.5 LocaleCubit + State (TDD, 11 tests) ✅
- [x] Write cubit tests first
- [x] Implement `locale_state.dart` and `locale_cubit.dart`

#### 18.6 Language Screen + Settings Integration (6 tests) ✅
- [x] Create `language_screen.dart` (RadioGroup + RadioListTile: System, English, Español)
- [x] Add Language ListTile to `settings_screen.dart`
- [x] Write screen widget tests

#### 18.7 Wire Locale into MaterialApp ✅
- [x] Initialize `LocaleRepository` in `main.dart`
- [x] Add `LocaleCubit` to `MultiBlocProvider` in `app.dart`
- [x] Set `localizationsDelegates`, `supportedLocales`, `locale` on `MaterialApp`

#### 18.8 Migrate AppStrings → context.l10n ✅
- [x] Migrate `reminder_screen.dart` (4 refs)
- [x] Migrate `accessibility_screen.dart` (7 refs)
- [x] Migrate `appearance_screen.dart` (7 refs)
- [x] Migrate `settings_screen.dart` (8 refs)
- [x] Migrate `history_bottom_sheet.dart` (7+1 refs)
- [x] Migrate `settings_bottom_sheet.dart` (17 refs)
- [x] Migrate `profile_screen.dart` (22 refs)
- [x] Migrate `calculator_keypad.dart` (~25 a11y refs)
- [x] Migrate `calculator_screen.dart` (1 ref — error type resolution)
- [x] Migrate `language_screen.dart`

#### 18.9 Update Tests ✅
- [x] Add `localizationsDelegates` + `supportedLocales` to all test `MaterialApp` wrappers
- [x] Update `calculator_engine_test.dart` (errorMessage → errorType)
- [x] Update `calculator_bloc_test.dart` (errorMessage → errorType)
- [x] Update widget test assertions (AppStrings → literal English strings)

#### 18.10 Verification ✅
- [x] `flutter test` — all 435 tests pass
- [x] `flutter analyze` — 0 errors, 0 warnings
- [x] Test on iOS Simulator: switch English, Spanish, System

**New concepts learned:**
- ARB file format and `flutter gen-l10n` code generation
- `flutter_localizations` SDK package for Material widget translations
- `AppLocalizations.of(context)` via `context.l10n` extension
- ICU message format for parameterized strings (`{time}` placeholder)
- Reactive locale switching with `BlocBuilder`
- Clean architecture i18n: domain returns `CalculationErrorType` enum, UI resolves to localized strings
- `RadioGroup<T>` wrapper widget (Flutter 3.38+ API replacing deprecated RadioListTile.groupValue)
- `l10n.yaml` configuration with `nullable-getter: false`

---

### Dependency Upgrades & Maintenance ✅
**Goal:** Upgrade all outdated dependencies to latest versions, migrate breaking API changes, verify with unit tests and full iOS Simulator smoke test.

#### Packages Upgraded
| Package | From | To | Breaking Changes |
|---------|------|----|------------------|
| flutter_bloc | ^8.1.3 | ^9.1.0 | None (drop-in) |
| bloc_test | ^9.1.5 | ^10.0.0 | None (drop-in) |
| flutter_local_notifications | ^18.0.1 | ^20.0.0 | v19: removed `uiLocalNotificationDateInterpretation`; v20: all methods switched to named parameters |
| flutter_timezone | ^3.0.1 | ^5.0.1 | `getLocalTimezone()` returns `TimezoneInfo` instead of `String` (use `.identifier`) |
| geocoding | ^3.0.0 | ^4.0.0 | Infrastructure only (Flutter 3.29+) |
| geolocator | ^13.0.2 | ^14.0.0 | Infrastructure only (Flutter 3.29+) |
| math_expressions | ^2.4.0 | ^3.1.0 | `Expression.evaluate()` removed; use `RealEvaluator` pattern |

#### Code Changes
- [x] `notification_service.dart` — `initialize(settings:)`, `zonedSchedule(id:, title:, ...)`, `cancel(id:)` named params; `TimezoneInfo.identifier`
- [x] `calculator_engine.dart` — Added `RealEvaluator`, changed `_evaluator.evaluate(exp).toDouble()`
- [x] `analysis_options.yaml` — Added `sort_pub_dependencies: false`
- [x] `calculator_keypad.dart` — Fixed `comment_references` lint (`[isOpen]` → `` `isOpen` ``)

#### Verification
- [x] `flutter analyze` — 0 errors, 0 warnings
- [x] `flutter test` — 435/435 pass
- [x] iOS Simulator smoke test — 18/18 tests pass:
  - Phase 1: 10/10 math calculations (addition, multiplication, division, subtraction, PEMDAS, parentheses, percentage, division by zero, decimals, AC reset)
  - Phase 2: 5/5 settings menus (Profile, Appearance/dark mode/accent, Accessibility, Language/Spanish, Reminder)
  - Phase 3: 3/3 history (drawer opens, scroll, tap-to-load)

---

## Current Work

### Phase 19: Currency Converter with Bottom Navigation Bar ✅
**Goal:** Add a currency converter feature using a free public API (Frankfurter), with a Material 3 NavigationBar to switch between Calculator and Currency modes. Teaches HTTP requests, JSON parsing, cache-first networking, BottomNavigationBar, IndexedStack, DropdownButton, and offline/error state handling.

#### 19.1 Currency Service (HTTP Layer) ✅
- [x] Write 14 tests first for `CurrencyService`
- [x] Create `currency_service.dart` in `features/currency/data/`
  - `CurrencyService({http.Client? client})` — injectable for testing
  - `fetchCurrencies()` → `Map<String, String>` (code → name)
  - `fetchRates({required String base})` → `ExchangeRates` model
  - `CurrencyServiceException` for error handling
- [x] Tests mock `http.Client` with mocktail (success, non-200, network error, invalid JSON)

#### 19.2 Currency Repository (Cache Layer) ✅
- [x] Write 22 tests first for `CurrencyRepository`
- [x] Create `currency_repository.dart` in `features/currency/data/`
  - Factory pattern: `static Future<CurrencyRepository> create()`
  - `saveRates/loadRates` — JSON-encode rates map to SharedPreferences
  - `isCacheFresh(base)` — timestamp-based 1hr TTL
  - `saveCurrencies/loadCurrencies` — cache currency name list
  - `saveFromCurrency/loadFromCurrency` — user preference (default: USD)
  - `saveToCurrency/loadToCurrency` — user preference (default: EUR)
  - All keys prefixed `currency_` to avoid collisions

#### 19.3 Constants & i18n Strings ✅
- [x] Create `currency_constants.dart` in `features/currency/domain/`
- [x] Add ~20 new keys to `app_en.arb` (currency UI, nav labels, a11y)
- [x] Add ~20 Spanish translations to `app_es.arb`
- [x] Run `flutter gen-l10n`

#### 19.4 Currency Cubit (State Management) ✅
- [x] Write 17 tests first for `CurrencyCubit`
- [x] Create `currency_state.dart` — sealed states:
  - `CurrencyInitial` — before rates loaded (has fromCurrency, toCurrency)
  - `CurrencyLoading` — fetching from API
  - `CurrencyLoaded` — rates available (amount, result, rates, currencies, rateDate, isOfflineCache)
  - `CurrencyError` — network/API failure with message
- [x] Create `currency_cubit.dart` — methods:
  - `loadRates()` — cache-first strategy
  - `updateAmount(double)` — recalculate conversion
  - `setFromCurrency(String)` / `setToCurrency(String)` — change + persist
  - `swapCurrencies()` — swap from/to + recalculate
  - `refresh()` — force-refresh ignoring cache

#### 19.5 Currency Screen UI ✅
- [x] Write 13 tests first for `CurrencyScreen`
- [x] Create `currency_picker.dart` — reusable `DropdownButton<String>` ("CODE - Name")
- [x] Create `currency_screen.dart` — layout:
  - Amount `TextField` with `TextEditingController`
  - From/To currency dropdowns
  - Swap button (⇅)
  - Converted result display
  - Rate date label ("Rates from {date}")
  - Loading: `CircularProgressIndicator`
  - Error: message + Retry button
  - Offline: `MaterialBanner` when showing stale cache

#### 19.6 Home Screen (Bottom Navigation Bar) ✅
- [x] Write 8 tests first for `HomeScreen`
- [x] Create `home_screen.dart` in `features/home/presentation/screens/`
  - Material 3 `NavigationBar` with 2 destinations: Calculator + Currency
  - `IndexedStack` to preserve both screens' state
  - Icons: `Icons.calculate` + `Icons.currency_exchange`
- [x] Modify `app.dart`: change `home:` from `CalculatorScreen` to `HomeScreen`
- [x] Modify `main.dart`: initialize `CurrencyService` + `CurrencyRepository`

#### 19.7 Integration & Final Verification ✅
- [x] Add `http` dependency to `pubspec.yaml`
- [x] Wire `CurrencyCubit` in `MultiBlocProvider` with `..loadRates()`
- [x] `flutter analyze` — 0 errors, 0 warnings
- [x] `flutter test` — all 509 tests pass (435 existing + 74 new)
- [x] Test on iOS Simulator — both tabs, currency conversion, tab state preserved

**New concepts learned:**
- HTTP GET requests with `http` package (`Uri`, `Response`, status codes)
- JSON parsing with `dart:convert` (`jsonDecode`, `jsonEncode`)
- Cache-first networking strategy (local cache → network fallback → stale cache fallback)
- `NavigationBar` (Material 3 bottom navigation)
- `IndexedStack` for preserving tab state
- `DropdownButton` for selection UI
- `TextField` with `TextInputType.numberWithOptions(decimal: true)`
- Offline/error state UI patterns (loading spinner, retry button, offline `MaterialBanner`)
- Mocking `http.Client` for testable network code
- `CurrencyServiceException` for typed error handling
- `BlocConsumer` for listener + builder pattern

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
- [x] Homework reminder notifications (Phase 15)
- [x] User profile with forms & validation (Phase 16)
- [x] Location detection with device APIs (Phase 17)
- [x] Internationalization — English & Spanish (Phase 18)
- [x] Currency converter with Frankfurter API (Phase 19)
- [x] Bottom navigation bar with tab switching (Phase 19)
- [x] All tests passing (509 tests)
- [x] Runs on iOS Simulator

**MVP COMPLETE + ACCESSIBILITY + NAVIGATION + RESPONSIVE + REMINDERS + PROFILE + LOCATION + i18n + CURRENCY!**

---

## Files Created

```
lib/
├── main.dart                    ✅ (UPDATED - initializes all repositories + services)
├── app.dart                     ✅ (UPDATED - MultiBlocProvider + locale)
├── core/
│   ├── constants/
│   │   ├── accent_colors.dart   ✅ (AccentColor enum + palettes)
│   │   ├── app_colors.dart      ✅ (dark theme colors)
│   │   ├── app_dimensions.dart  ✅
│   │   ├── app_strings.dart     ✅ (UPDATED - symbols only, translated strings moved to ARB)
│   │   ├── profile_avatars.dart ✅ (Phase 16 - ProfileAvatar enum)
│   │   └── responsive_dimensions.dart  ✅ (Phase 14 - responsive scaling)
│   ├── l10n/
│   │   └── l10n.dart            ✅ (Phase 18 - context.l10n extension)
│   ├── theme/
│   │   ├── app_theme.dart       ✅ (accent color methods)
│   │   └── calculator_colors.dart ✅ (accent factories)
│   └── utils/
│       └── calculator_engine.dart ✅ (UPDATED - CalculationErrorType enum)
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
│   ├── settings/                ✅ (Phase 12 + 13 + 18)
│   │   ├── data/
│   │   │   ├── accessibility_repository.dart  ✅ (accessibility persistence)
│   │   │   └── locale_repository.dart         ✅ (Phase 18 - language persistence)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── accessibility_cubit.dart   ✅ (accessibility state)
│   │       │   ├── accessibility_state.dart   ✅ (accessibility state class)
│   │       │   ├── locale_cubit.dart          ✅ (Phase 18 - locale state mgmt)
│   │       │   └── locale_state.dart          ✅ (Phase 18 - locale state class)
│   │       └── screens/              ✅ (Phase 13 + 18 - Navigation)
│   │           ├── settings_screen.dart       ✅ (settings menu)
│   │           ├── appearance_screen.dart     ✅ (theme settings)
│   │           ├── accessibility_screen.dart  ✅ (accessibility settings)
│   │           └── language_screen.dart       ✅ (Phase 18 - language picker)
│   ├── reminder/                 ✅ (Phase 15)
│   │   ├── data/
│   │   │   ├── reminder_repository.dart       ✅ (reminder persistence)
│   │   │   └── notification_service.dart      ✅ (flutter_local_notifications wrapper)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── reminder_cubit.dart        ✅ (reminder state management)
│   │       │   └── reminder_state.dart        ✅ (reminder state class)
│   │       └── screens/
│   │           └── reminder_screen.dart       ✅ (reminder settings UI)
│   ├── profile/                  ✅ (Phase 16 + 17)
│   │   ├── data/
│   │   │   ├── profile_repository.dart        ✅ (profile persistence + city/region)
│   │   │   └── location_service.dart          ✅ (Phase 17 - geolocator + geocoding)
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── profile_cubit.dart         ✅ (profile + location state management)
│   │       │   └── profile_state.dart         ✅ (profile state + location fields)
│   │       └── screens/
│   │           └── profile_screen.dart        ✅ (profile form + location section)
│   ├── home/                     ✅ (Phase 19)
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart           ✅ (NavigationBar + IndexedStack)
│   └── currency/                 ✅ (Phase 19)
│       ├── data/
│       │   ├── currency_service.dart          ✅ (HTTP API calls - Frankfurter)
│       │   └── currency_repository.dart       ✅ (cache rates in SharedPreferences)
│       ├── domain/
│       │   └── currency_constants.dart        ✅ (defaults, cache duration)
│       └── presentation/
│           ├── cubit/
│           │   ├── currency_cubit.dart        ✅ (state management)
│           │   └── currency_state.dart        ✅ (sealed state classes)
│           ├── screens/
│           │   └── currency_screen.dart       ✅ (converter UI)
│           └── widgets/
│               └── currency_picker.dart       ✅ (reusable dropdown)
├── l10n/                        ✅ (Phase 18 + 19)
│   ├── app_en.arb               ✅ (English template, ~105 keys)
│   └── app_es.arb               ✅ (Spanish translations)
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
    ├── settings/                ✅ (Phase 12 + 18)
    │   ├── data/
    │   │   ├── accessibility_repository_test.dart ✅ (19 tests)
    │   │   └── locale_repository_test.dart        ✅ (9 tests)
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── accessibility_cubit_test.dart   ✅ (14 tests)
    │       │   └── locale_cubit_test.dart          ✅ (11 tests)
    │       └── screens/
    │           └── language_screen_test.dart       ✅ (6 tests)
    ├── reminder/                 ✅ (Phase 15)
    │   ├── data/
    │   │   └── reminder_repository_test.dart ✅ (18 tests)
    │   └── presentation/
    │       └── cubit/
    │           └── reminder_cubit_test.dart ✅ (16 tests)
    ├── profile/                  ✅ (Phase 16 + 17)
    │   ├── data/
    │   │   └── profile_repository_test.dart  ✅ (24 tests)
    │   └── presentation/
    │       ├── cubit/
    │       │   └── profile_cubit_test.dart   ✅ (18 tests)
    │       └── screens/
    │           └── profile_screen_test.dart  ✅ (15 tests)
    ├── home/                     ✅ (Phase 19)
    │   └── presentation/
    │       └── screens/
    │           └── home_screen_test.dart     ✅ (8 tests)
    └── currency/                 ✅ (Phase 19)
        ├── data/
        │   ├── currency_service_test.dart    ✅ (14 tests)
        │   └── currency_repository_test.dart ✅ (22 tests)
        └── presentation/
            ├── cubit/
            │   └── currency_cubit_test.dart  ✅ (17 tests)
            └── screens/
                └── currency_screen_test.dart ✅ (13 tests)

Root:
├── pubspec.yaml                 ✅
├── analysis_options.yaml        ✅
├── l10n.yaml                    ✅ (Phase 18 - localization config)
├── prd.md                       ✅
└── TODO.md                      ✅ (this file)
```

---

## Quick Commands

```bash
# Run all tests (509 total)
flutter test

# Run engine tests only (45)
flutter test test/core/

# Run calculator tests (82 total: 17 repo + 41 BLoC + 14 button + 18 display + 27 keypad)
flutter test test/features/calculator/

# Run responsive tests (54 total: 18 dimensions + 7 button + 7 display + 11 keypad + 11 screen)
# (included in calculator test path above)

# Run theme tests (34 total: 19 repository + 15 cubit)
flutter test test/features/theme/

# Run history tests (34 total: 21 repository + 13 cubit)
flutter test test/features/history/

# Run settings tests (59 total: 19 a11y repo + 14 a11y cubit + 9 locale repo + 11 locale cubit + 6 language screen)
flutter test test/features/settings/

# Run reminder tests (34 total: 18 repository + 16 cubit)
flutter test test/features/reminder/

# Run profile tests (57 total: 24 repository + 18 cubit + 15 screen)
flutter test test/features/profile/

# Run currency tests (66 total: 14 service + 22 repository + 17 cubit + 13 screen)
flutter test test/features/currency/

# Run home tests (8 total)
flutter test test/features/home/

# Regenerate localization files
flutter gen-l10n

# Analyze code
flutter analyze

# Run app
flutter run
```

---

## Notes

**Status: Phase 19 complete — currency converter + bottom navigation**
**509 tests passing, 0 errors, 0 warnings**

**Previous Commits:**
- `bf68658` - feat: add internationalization with English and Spanish support (Phase 18)
- `c89e99d` - feat: add homework reminder notifications (Phase 15)
- `1291ab9` - feat: add responsive UI with orientation support (Phase 14/14b)
- `44bacbd` - feat: add navigation screens for settings (Phase 13)
- `5420666` - feat: add accessibility settings with reduce motion and haptic toggles (Phase 12)
- `20908fa` - chore: add CLAUDE.md project instructions
- `5278b31` - feat: add history UI, state management and calculator integration (Phase 11.3-11.5)
- `b66bdb9` - feat: add calculation history with Drift database (Phase 11.1-11.2)

**Notes for Next Session:**
- Phase 19 (Currency + Navigation) not yet committed
- Dependency upgrades + lint fixes not yet committed
- Phase 10 (Polish) is still pending — animations, error prevention
- Consider: ARB `@` description metadata for translator context
- Consider: AppStrings cleanup (remove translated constants that moved to ARB)
- All 7 dependencies now at latest (flutter_bloc 9, flutter_local_notifications 20, flutter_timezone 5, geocoding 4, geolocator 14, math_expressions 3)
- Added `http: ^1.3.0` for Frankfurter API

**Skills Available:**
- `/start-session` - Initialize coding session with project context
- `/end-session` - Wrap up session and update documentation
- `/commit` - Stage and commit with auto-generated message (asks for review)
- `/rules` - Re-read CLAUDE.md and MEMORY.md (use after auto-compact)
