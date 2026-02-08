# MathMate - Product Requirements Document

## Overview

**MathMate** is a student-friendly calculator app built with Flutter, featuring expression-based input with live result preview, inspired by Google Calculator. The app supports multiple languages (English & Spanish), dark/light themes with custom accent colors, calculation history, user profiles, homework reminders, and accessibility settings.

---

## Target Audience

- **Primary:** Students (high school/college)
- **Use cases:** Homework, exam prep, quick calculations
- **Design philosophy:** Clean, professional, approachable

---

## Current Status

**Phase 22 Complete** — The app has been built incrementally through 22 development phases, totaling **562 tests** across all features. All phases use TDD methodology.

| Phase | Feature | Tests |
|-------|---------|-------|
| 1 | Project Setup | — |
| 2 | Core Constants & Theme | — |
| 3 | Calculator Engine (TDD) | 45 |
| 4 | Domain Models | — |
| 5 | Calculator BLoC (TDD) | 41 |
| 6 | UI Widgets (TDD) | 59 |
| 7 | Main Screen & Integration | — |
| 7.5 | Keypad Layout Update | — |
| 8 | State Persistence | 17 |
| 9 | Full Theme System | 34 |
| 11 | Calculation History (Drift) | 34 |
| 12 | Accessibility Settings | 33 |
| 13 | Navigation & Settings Screens | — |
| 14/14b | Responsive & Adaptive UI | 54 |
| 15 | Homework Reminder Notifications | 34 |
| 16 | User Profile (Forms & Validation) | 57 |
| 17 | Location Detection (Device APIs) | 15 |
| 18 | Internationalization (i18n) | 26 |
| 19 | Currency Converter + Bottom Nav | 74 |
| 20 | Error Handling & Logging | 43 |
| 21 | Clipboard Copy (Long Press) | 6 |
| 22 | Adaptive Navigation (NavigationRail) | 4 |

---

## Platform & Technical Requirements

| Requirement | Value |
|-------------|-------|
| Framework | Flutter |
| Primary Platform | iOS (iPhone) |
| Minimum iOS | 15.0+ |
| State Management | BLoC Pattern (Cubit for simpler state) |
| Testing | TDD (Test-Driven Development) — 562 tests |
| Persistence | SharedPreferences + Drift (SQLite) |
| Localization | ARB-based (`flutter gen-l10n`) — English & Spanish |
| Dev Environment | iOS Simulator |

---

## Core Features

### 1. Calculator Engine

#### Calculation Style
- **Expression-based input** (not immediate execution)
- Full PEMDAS/order of operations support
- User types complete expression: `2 + 3 × 4`
- Press `=` to evaluate: `14`
- Live result preview as user types

#### Number Handling
- Maximum display: 15 digits
- Long results: **Scientific notation** (e.g., `1.23e+15`)
- Decimal precision: Configurable (default 10 places)

#### Parentheses Handling
- **Auto-balance:** Unclosed parentheses auto-close on `=`
- **Implicit multiplication:** `2(3+4)` becomes `2 × (3 + 4)`

#### Error Handling
- Domain layer returns `CalculationErrorType` enum (no UI dependency)
- UI layer resolves error types to localized strings via `context.l10n`
- Error types: `divisionByZero`, `invalidExpression`, `overflow`, `undefined`, `generic`
- Error messages display inline, replacing result text in red

### 2. Basic Calculator Operations

| Operation | Symbol | Notes |
|-----------|--------|-------|
| Addition | `+` | |
| Subtraction | `−` | Using minus sign, not hyphen |
| Multiplication | `×` | Using multiplication sign |
| Division | `÷` | Using division sign |
| Percentage | `%` | Converts to decimal (50% → 0.5) |
| Positive/Negative | `±` | Toggles sign |
| Decimal | `.` | One per number |
| Backspace | `⌫` | Deletes last character |
| All Clear | `AC` | Clears entire expression |
| Equals | `=` | Evaluate expression |
| Parentheses | `( )` | For grouping in expressions |

### 3. Display Component

#### Dual-Line Display
```
┌─────────────────────────────┐
│                   2 + 3 × 4 │  ← Expression (top, smaller)
│                          14 │  ← Live result preview (bottom, larger)
└─────────────────────────────┘
```

- **Top line:** Current expression being built
- **Bottom line:** Live result preview (updates as user types)
- Result shown in real-time before pressing `=`
- After `=`, expression moves to top, final result emphasized below
- `FittedBox` auto-shrinks text to fit available space
- Long press to copy expression or result to clipboard (with haptic feedback and snackbar)

### 4. State Persistence

- **Full state restore** on app reopen:
  - Current expression and last result
  - Theme mode and accent color
  - Accessibility settings
  - Reminder settings
  - User profile data
  - Language preference
- Uses `SharedPreferences` for key-value persistence
- Uses `Drift` (SQLite ORM) for calculation history

### 5. Theming System

- **Three theme modes:** Light, Dark, System (follows device)
- **Five accent colors:** Blue (default), Green, Purple, Orange, Teal
- Each accent has full light/dark palette (primary, on-primary, containers)
- `CalculatorColors` ThemeExtension for widget-specific colors
- `ThemeRepository` persists preferences via SharedPreferences
- `ThemeCubit` manages reactive theme state
- Settings accessible via Appearance screen

### 6. Calculation History

- Stored in SQLite via Drift ORM with reactive streams
- History button (🕐) in keypad opens DraggableScrollableSheet
- Each entry shows: expression → result with timestamp
- Tap entry to load expression into calculator
- Swipe left to delete individual entry (Dismissible)
- "Clear All" button with confirmation dialog
- Empty state when no history
- Timestamps: "Today HH:MM", "Yesterday HH:MM", or "MM/DD/YYYY HH:MM"

### 7. Accessibility Settings

- **Reduce Motion:** Disables button press animations
- **Haptic Feedback:** Enable/disable vibration on button press
- **Sound Feedback:** Enable/disable click sounds (placeholder)
- `AccessibilityRepository` for persistence
- `AccessibilityCubit` for state management
- Settings accessible via Accessibility screen

### 8. Homework Reminder Notifications

- Daily notification at user-selected time (default 4:00 PM)
- `flutter_local_notifications` with `zonedSchedule` for daily recurrence
- Timezone-aware scheduling with `TZDateTime`
- iOS permission request flow (graceful degradation if denied)
- `NotificationService` wraps native plugin
- `ReminderCubit` orchestrates repository + service
- Settings accessible via Reminder screen with toggle + time picker

### 9. User Profile

- Profile screen with form validation:
  - **Name:** Required, 2-50 chars, letters/spaces/hyphens only
  - **Email:** Required, valid format (RegExp)
  - **School:** Optional, max 100 chars
  - **Avatar:** Required, choose from 10 Material Icons
  - **Location:** Optional, auto-detect via GPS + reverse geocoding
- `Form` + `GlobalKey<FormState>` for collective validation
- `TextEditingController` lifecycle management
- `AutovalidateMode` (disabled → onUserInteraction after first submit)
- Location detection via `geolocator` + `geocoding` plugins

### 10. Currency Converter

- Real-time currency conversion using the free Frankfurter API (~31 currencies)
- Amount input with decimal keyboard
- From/To currency selection via `DropdownButton` ("CODE - Name" format)
- Swap button to quickly reverse conversion direction
- Converted result display with rate date label
- Cache-first strategy: SharedPreferences cache with 1-hour TTL
- Offline support: falls back to stale cache with `MaterialBanner` indicator
- Error state: "Could not load exchange rates" with Retry button
- Loading state: `CircularProgressIndicator`
- User preferences (from/to currencies) persist across restarts
- `CurrencyService` wraps `http.Client` (injectable for testing)
- `CurrencyRepository` for cache management (factory pattern with SharedPreferences)
- `CurrencyCubit` orchestrates service + repository with cache-first strategy

### 11. Bottom Navigation

- Adaptive navigation based on orientation:
  - **Portrait:** Material 3 `NavigationBar` (bottom bar)
  - **Landscape:** Material 3 `NavigationRail` (side rail)
- 2 destinations:
  - **Calculator** tab (`Icons.calculate`) — default
  - **Currency** tab (`Icons.currency_exchange`)
- `IndexedStack` preserves state of both screens when switching tabs
- Theme-aware styling (respects dark mode + accent colors)

### 12. Internationalization (i18n)

- **Supported languages:** English (US), Español (MX)
- **System default:** Follows device language
- ARB-based localization with `flutter gen-l10n`
- `AppLocalizations.of(context)` via `context.l10n` extension
- ICU message format for parameterized strings (`{time}` placeholder)
- `LocaleRepository` for persisting language preference
- `LocaleCubit` for reactive locale switching
- Language picker screen (RadioListTile: System, English, Español)
- Material widgets (time picker, dialogs) also switch language
- Domain layer uses `CalculationErrorType` enum; UI resolves to localized strings

---

## UI/UX Specifications

### Navigation Flow

```
Home Screen (NavigationBar)
├── Tab 0: Calculator Screen (default)
│       ├── 🕐 History → Bottom Sheet (DraggableScrollableSheet)
│       └── ⚙  Settings → Settings Screen
│               ├── Profile → Profile Screen (Form)
│               ├── Appearance → Appearance Screen (Theme Mode + Accent Color)
│               ├── Accessibility → Accessibility Screen (3 Toggles)
│               ├── Language → Language Screen (Radio Buttons)
│               └── Reminder → Reminder Screen (Toggle + Time Picker)
└── Tab 1: Currency Screen
        ├── Amount input, From/To dropdowns, Swap button
        ├── Converted result + rate date
        └── Loading / Error / Offline states
```

### Button Layout

#### Portrait (6×4 Grid)

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
│  ±  │  0  │  .  │  =  │
└─────┴─────┴─────┴─────┘
```

#### Landscape (4×6 Grid)

```
┌─────┬─────┬─────┬─────┬─────┬─────┐
│ AC  │  ⌫  │  7  │  8  │  9  │  ÷  │
├─────┼─────┼─────┼─────┼─────┼─────┤
│  (  │  )  │  4  │  5  │  6  │  ×  │
├─────┼─────┼─────┼─────┼─────┼─────┤
│  %  │  ±  │  1  │  2  │  3  │  −  │
├─────┼─────┼─────┼─────┼─────┼─────┤
│  🕐 │  ⚙  │  0  │  .  │  =  │  +  │
└─────┴─────┴─────┴─────┴─────┴─────┘
```

### Button Style
- **Shape:** Rounded rectangles (16dp radius)
- **Size:** Responsive, minimum 44dp height (accessibility)
- **Spacing:** Responsive, scales with screen size
- **Press animation:** Scale to 0.95 (respects reduce motion setting)
- **Haptic feedback:** Light haptic on tap (respects haptic setting)

### Color Scheme

Supports light and dark themes with 5 accent color options (blue, green, purple, orange, teal).

**Light theme example (blue accent):**

| Element | Color |
|---------|-------|
| Background | Light gray (#F5F5F5) |
| Number buttons | White |
| Operator buttons | Blue accent |
| Function buttons | Light gray |
| Equals button | Blue accent |
| Error text | Red |

**Dark theme** mirrors the structure with dark surface colors and adjusted accent brightness.

### Responsive Design

- **Reference device:** iPhone 14 (390dp width)
- **Scale factor:** screenWidth / 390, clamped to [0.75, 1.2]
- **Landscape adjustments:** buttonHeight × 0.7, spacing × 0.6
- **Accessibility floor:** Minimum 44dp button height
- Portrait: Column layout (display expanded, keypad below)
- Landscape: Column layout (compact display, expanded 4×6 keypad)

### Typography

| Element | Base Size | Scaling |
|---------|-----------|---------|
| Result (main) | 56sp | Responsive |
| Expression | 24sp | Responsive |
| Buttons | 28sp | Responsive |
| Error messages | 14sp | Fixed |

All text uses `FittedBox(fit: BoxFit.scaleDown)` to prevent overflow.

### Feedback

- **Haptic:** Light haptic on button tap (configurable in Accessibility settings)
- **Animation:** Button press scale (0.95), disabled when Reduce Motion is on
- **Sound:** Placeholder for future (configurable toggle exists)

---

## Technical Architecture

### Project Structure (Clean Architecture)

```
lib/
├── main.dart                      # App entry point (initializes all repositories & services)
├── app.dart                       # Root MaterialApp with MultiBlocProvider
│
├── core/
│   ├── constants/
│   │   ├── accent_colors.dart     # AccentColor enum + light/dark palettes
│   │   ├── app_colors.dart        # Color palette (light + dark)
│   │   ├── app_dimensions.dart    # Sizes, spacing, animation durations
│   │   ├── app_strings.dart       # Non-translatable symbols & helper methods
│   │   ├── profile_avatars.dart   # ProfileAvatar enum (10 Material Icons)
│   │   └── responsive_dimensions.dart  # Responsive scaling value class
│   ├── l10n/
│   │   └── l10n.dart              # BuildContext extension (context.l10n)
│   ├── theme/
│   │   ├── app_theme.dart         # Material 3 light/dark theme with accents
│   │   └── calculator_colors.dart # ThemeExtension for widget colors
│   ├── error/
│   │   ├── error_boundary.dart    # Global error boundaries (runZonedGuarded, FlutterError.onError)
│   │   └── app_error_widget.dart  # Friendly error UI widget
│   ├── services/
│   │   └── app_logger.dart        # Injectable logger wrapper (debug, info, warning, error)
│   └── utils/
│       └── calculator_engine.dart # Expression evaluation engine + CalculationErrorType
│
├── l10n/
│   ├── app_en.arb                 # English translations (~85 keys)
│   └── app_es.arb                 # Spanish translations
│
├── features/
│   ├── calculator/
│   │   ├── data/
│   │   │   └── calculator_repository.dart  # State persistence (SharedPreferences)
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── calculator_bloc.dart     # Calculator state management
│   │       │   ├── calculator_event.dart    # 11 sealed event classes
│   │       │   └── calculator_state.dart    # 4 sealed state classes
│   │       ├── screens/
│   │       │   └── calculator_screen.dart   # Main screen with responsive layout
│   │       └── widgets/
│   │           ├── calculator_button.dart   # Reusable animated button
│   │           ├── calculator_display.dart  # Dual-line display with FittedBox
│   │           └── calculator_keypad.dart   # Orientation-aware grid (6×4 / 4×6)
│   │
│   ├── theme/
│   │   ├── data/
│   │   │   └── theme_repository.dart       # Theme persistence
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── theme_cubit.dart        # Theme state management
│   │       │   └── theme_state.dart
│   │       └── widgets/
│   │           └── settings_bottom_sheet.dart  # Legacy settings UI
│   │
│   ├── history/
│   │   ├── data/
│   │   │   ├── history_database.dart       # Drift database
│   │   │   ├── history_database.g.dart     # Generated code
│   │   │   └── history_repository.dart     # History CRUD
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── history_cubit.dart      # History state management
│   │       │   └── history_state.dart
│   │       └── widgets/
│   │           └── history_bottom_sheet.dart  # History UI
│   │
│   ├── settings/
│   │   ├── data/
│   │   │   ├── accessibility_repository.dart  # Accessibility persistence
│   │   │   └── locale_repository.dart         # Language persistence
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── accessibility_cubit.dart
│   │       │   ├── accessibility_state.dart
│   │       │   ├── locale_cubit.dart
│   │       │   └── locale_state.dart
│   │       └── screens/
│   │           ├── settings_screen.dart       # Settings menu
│   │           ├── appearance_screen.dart     # Theme settings
│   │           ├── accessibility_screen.dart  # Accessibility toggles
│   │           └── language_screen.dart       # Language picker
│   │
│   ├── reminder/
│   │   ├── data/
│   │   │   ├── reminder_repository.dart       # Reminder persistence
│   │   │   └── notification_service.dart      # flutter_local_notifications wrapper
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── reminder_cubit.dart
│   │       │   └── reminder_state.dart
│   │       └── screens/
│   │           └── reminder_screen.dart       # Reminder toggle + time picker
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── profile_repository.dart        # Profile persistence
│   │   │   └── location_service.dart          # geolocator + geocoding wrapper
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── profile_cubit.dart
│   │       │   └── profile_state.dart
│   │       └── screens/
│   │           └── profile_screen.dart        # Profile form + location UI
│   │
│   ├── home/
│   │   └── presentation/
│   │       └── screens/
│   │           └── home_screen.dart           # Adaptive nav (NavigationBar/NavigationRail) + IndexedStack
│   │
│   └── currency/
│       ├── data/
│       │   ├── currency_service.dart          # HTTP API calls (Frankfurter)
│       │   └── currency_repository.dart       # Cache management (SharedPreferences)
│       ├── domain/
│       │   └── currency_constants.dart        # Defaults, cache duration, API URL
│       └── presentation/
│           ├── cubit/
│           │   ├── currency_cubit.dart        # Currency state management
│           │   └── currency_state.dart        # Sealed state classes
│           ├── screens/
│           │   └── currency_screen.dart       # Converter UI
│           └── widgets/
│               └── currency_picker.dart       # Reusable dropdown
│
└── docs.md                        # App documentation

l10n.yaml                          # Localization code generation config
```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_bloc: ^9.1.0          # State management (BLoC + Cubit)
  equatable: ^2.0.5             # Value equality for states
  shared_preferences: ^2.2.2    # Key-value persistence
  math_expressions: ^3.1.0      # Expression parsing
  drift: ^2.22.1                # SQLite ORM for history
  sqlite3_flutter_libs: ^0.5.28 # SQLite native libs
  intl: ^0.20.2                 # Date/number formatting
  flutter_local_notifications: ^20.0.0  # Local notifications
  timezone: ^0.10.0             # Timezone-aware scheduling
  flutter_timezone: ^5.0.1      # Device timezone detection
  geolocator: ^14.0.0           # GPS location
  geocoding: ^4.0.0             # Reverse geocoding
  http: ^1.3.0                  # HTTP client for API requests
  logger: ^2.5.0                # Structured logging

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^10.0.0            # BLoC testing
  mocktail: ^1.0.1              # Mocking for tests
  very_good_analysis: ^5.1.0    # Lint rules
  drift_dev: ^2.22.1            # Drift code generation
  build_runner: ^2.4.14         # Code generation runner
```

### State Management

```
Events → BLoC → States → UI

Calculator BLoC Events:
- DigitPressed(digit)
- OperatorPressed(operator)
- EqualsPressed()
- AllClearPressed()
- BackspacePressed()
- DecimalPressed()
- PercentPressed()
- PlusMinusPressed()
- ParenthesisPressed(isOpen)
- CalculatorStarted()
- HistoryEntryLoaded(expression)

Calculator States:
- CalculatorInitial
- CalculatorInput(expression, liveResult)
- CalculatorResult(expression, result)
- CalculatorError(expression, errorType)

Cubits:
- ThemeCubit (themeMode, accentColor)
- HistoryCubit (entries, isLoading)
- AccessibilityCubit (reduceMotion, hapticFeedback, soundFeedback)
- ReminderCubit (isEnabled, hour, minute)
- ProfileCubit (name, email, school, avatar, city, region)
- LocaleCubit (languageCode, locale)
- CurrencyCubit (amount, result, fromCurrency, toCurrency, rates, currencies, rateDate, isOfflineCache)
```

All cubits are provided at the app root via `MultiBlocProvider` and accessible across all screens.
`CurrencyCubit` calls `loadRates()` at startup to eagerly fetch exchange rates.

---

## Development Approach

### Methodology: TDD

1. **Write test first** for each feature
2. **Implement minimal code** to pass test
3. **Refactor** for clean code
4. **Repeat** for next feature

### Architecture Patterns

- **Clean Architecture:** Presentation / Domain / Data layers
- **BLoC Pattern:** For complex state (Calculator)
- **Cubit Pattern:** For simpler state (Theme, Accessibility, Reminder, Profile, Locale, Currency)
- **Repository Pattern:** For data persistence (SharedPreferences, Drift)
- **Service Pattern:** For native plugin wrappers (NotificationService, LocationService)
- **Adaptive Navigation:** Orientation-aware navigation (NavigationBar in portrait, NavigationRail in landscape)

---

## User Flows

### Flow 1: Basic Calculation
```
1. User opens MathMate
2. Display shows "0" (or restored state)
3. User taps: 2 + 3 × 4
4. Expression shows: "2 + 3 × 4"
5. Live preview shows: "14" (PEMDAS applied)
6. User taps =
7. Result "14" is emphasized, saved to history
8. Tapping a number starts new calculation
9. Tapping operator continues from result
```

### Flow 2: History Recall
```
1. User taps 🕐 (history button)
2. Bottom sheet slides up with past calculations
3. User taps an entry (e.g., "2 + 3 × 4 = 14")
4. Expression "2 + 3 × 4" loaded into calculator
5. User can modify and re-evaluate
```

### Flow 3: Change Language
```
1. User taps ⚙ (settings)
2. Taps "Language" row
3. Selects "Español (MX)"
4. All screens update reactively to Spanish
5. Material widgets (time picker, etc.) also switch
```

### Flow 4: Currency Conversion
```
1. User taps "Currency" tab in bottom navigation
2. Exchange rates load (cache-first: use cached if < 1hr old)
3. User enters amount (default: 1)
4. User selects "From" currency (default: USD)
5. User selects "To" currency (default: EUR)
6. Converted result shown immediately (e.g., "0.85 EUR")
7. Rate date shown below (e.g., "Rates from 2026-02-06")
8. User taps swap button (⇅) to reverse currencies
9. If offline: shows stale cache with "Showing cached rates (offline)" banner
10. If error: shows "Could not load exchange rates" with Retry button
```

### Flow 5: Theme Customization
```
1. User navigates: Settings → Appearance
2. Switches theme to Dark mode
3. Selects Purple accent color
4. All UI updates immediately
5. Preferences persist across restarts
```

---

## Non-Functional Requirements

### Performance
- App launch: < 2 seconds cold start
- Button response: < 100ms
- Animations: 60fps smooth

### Accessibility
- Semantic labels on all buttons (localized)
- Sufficient color contrast
- Minimum 44dp touch targets
- Reduce motion toggle
- Haptic feedback toggle
- Screen reader compatible

### Code Quality
- Clean Architecture separation
- BLoC pattern for state
- TDD with 562 tests
- Well-documented code

### Localization
- English (US) and Spanish (MX) support
- System default follows device language
- Reactive updates when language changes
- All user-facing strings in ARB files

---

## Future Roadmap

### Completed Features (Originally "Future")
- ~~Dark mode~~ → Phase 9 ✅
- ~~Custom accent colors~~ → Phase 9 ✅
- ~~Settings screen~~ → Phase 13 ✅
- ~~Calculation history~~ → Phase 11 ✅

### Phase 10: Polish (Pending)
- Smooth animations (250-350ms)
- Error prevention (disable invalid buttons)

### Future Phases (Not Yet Planned)
- Scientific mode (trig, log, power functions)
- iPad adaptive layout
- CI/CD pipeline
- Remote push notifications (Firebase)
- User authentication
- Cloud sync for history/profile

### Out of Scope
- Programmer mode (hex/binary)
- Graphing
- Apple Watch app

---

## Success Criteria

- [x] App builds and runs on iOS Simulator
- [x] All basic operations work correctly
- [x] PEMDAS order of operations correct
- [x] Expression + live result display works
- [x] Error handling prevents crashes
- [x] State persists across app restarts
- [x] Animations are smooth (60fps)
- [x] 562 tests passing
- [x] Code is well-documented
- [x] Currency converter with Frankfurter API
- [x] Bottom navigation bar with tab switching
- [x] Dark/light/system themes with 5 accent colors
- [x] Calculation history with Drift database
- [x] Accessibility settings (reduce motion, haptics, sound)
- [x] Navigation with 5 settings screens
- [x] Responsive UI (iPhone SE → Pro Max, portrait + landscape)
- [x] Homework reminder notifications
- [x] User profile with form validation
- [x] Location detection via GPS + reverse geocoding
- [x] Internationalization (English + Spanish)
- [x] Error handling & logging infrastructure
