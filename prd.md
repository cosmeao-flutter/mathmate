# MathMate - Product Requirements Document

## Overview

**MathMate** is a student-friendly calculator app built with Flutter, featuring expression-based input with live result preview, designed with Google Calculator as inspiration.

---

## Target Audience

- **Primary:** Students (high school/college)
- **Use cases:** Homework, exam prep, quick calculations
- **Design philosophy:** Clean, professional, approachable

---

## MVP Scope (Phase 1)

The initial release focuses on a polished basic calculator only:
- Basic arithmetic operations
- Expression-based input with PEMDAS
- Clean, modern UI inspired by Google Calculator
- No themes, scientific mode, or settings in MVP

---

## Platform & Technical Requirements

| Requirement | Value |
|-------------|-------|
| Framework | Flutter |
| Primary Platform | iOS (iPhone) |
| Minimum iOS | 15.0+ |
| Future Support | iPad (architect for later) |
| State Management | BLoC Pattern |
| Testing | TDD (Test-Driven Development) |
| Dev Environment | iOS Simulator |

---

## Core Features

### 1. Calculator Engine

#### Calculation Style
- **Expression-based input** (not immediate execution)
- Full PEMDAS/order of operations support
- User types complete expression: `2 + 3 × 4`
- Press `=` to evaluate: `14`

#### Number Handling
- Maximum display: 15 digits
- Long results: **Scientific notation** (e.g., `1.23e+15`)
- Decimal precision: Configurable (default 10 places)

#### Parentheses Handling
- **Auto-balance:** Unclosed parentheses auto-close on `=`
- **Visual hints:** Unmatched parentheses highlighted in red
- **Implicit multiplication:** `2(3+4)` becomes `2 × (3 + 4)`

#### Error Handling (Hybrid Approach)
1. **Prevention first:** Disable buttons that would cause errors when possible
   - Example: Disable `÷` if result would be division by zero
   - Example: Disable decimal if number already has one
2. **Inline feedback:** When prevention isn't possible, show brief inline message
   - "Cannot divide by zero"
   - "Invalid expression"
   - Message displays for 2 seconds, then clears

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
| Equals | `=` | **Standard evaluate only** (no repeat) |
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

### 4. State Persistence

- **Full state restore** on app reopen:
  - Current expression
  - Last result
  - Calculator mode (for future scientific)
  - Memory values (for future)
- Uses `shared_preferences` for persistence

---

## UI/UX Specifications

### Design Inspiration
- **Google Calculator** - Material design, expression-based, clean

### Button Layout (6×4 Grid)

```
┌─────┬─────┬─────┬─────┐
│ AC  │  ⌫  │     │     │  ← Control row (2 slots reserved for future)
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

**Row breakdown:**
- **Row 1 (Control):** AC (all clear), ⌫ (backspace), 2 empty slots for future features (history, settings)
- **Row 2 (Functions):** Parentheses together, percent, division
- **Rows 3-5 (Numbers):** Standard number pad with operators on right
- **Row 6 (Bottom):** Plus/minus toggle, zero, decimal point, equals

### Button Style
- **Shape:** Rounded rectangles (modern look)
- **Size:** Large touch targets (minimum 48dp)
- **Spacing:** 8-12dp between buttons

### Color Scheme (MVP - Light Theme Only)

| Element | Color | Hex |
|---------|-------|-----|
| Background | Light gray | `#F5F5F5` |
| Display background | White | `#FFFFFF` |
| Number buttons | White | `#FFFFFF` |
| Operator buttons | **Blue** (accent) | `#2196F3` |
| Function buttons | Light gray | `#E0E0E0` |
| Equals button | **Blue** (accent) | `#2196F3` |
| Primary text | Dark gray | `#212121` |
| Secondary text | Medium gray | `#757575` |
| Operator text | White | `#FFFFFF` |

### Typography

| Element | Size | Weight |
|---------|------|--------|
| Result (main) | 48-56sp | Regular |
| Expression | 24sp | Light |
| Buttons | 24-28sp | Medium |
| Error messages | 14sp | Regular |

### Feedback

#### Haptic Feedback
- Light haptic on number/operator tap
- Medium haptic on equals
- Error haptic on invalid action
- **Configurable:** Can disable in settings (future)

#### Sound Effects
- Subtle click sound on button tap
- Different tone for equals
- Error sound for invalid actions
- **Configurable:** Can disable in settings (future)

#### Visual Feedback
- Button press animation (scale down slightly)
- Ripple effect on tap
- Color change on press state

### Animations

- **Style:** Smooth and fluid
- **Duration:** 250-350ms
- **Easing:** Ease-in-out curves
- **Examples:**
  - Button press: Scale to 0.95, return to 1.0
  - Result update: Fade/slide transition
  - Error message: Fade in, hold, fade out
  - Mode switch (future): Slide/crossfade

---

## Scientific Mode (Phase 2 - Future)

### Mode Switching
- **Toggle button** at top of screen
- **Swipe gesture** left/right to switch
- Preserve current calculation when switching
- Smooth transition animation

### Scientific Functions (Student-Focused)

| Category | Functions |
|----------|-----------|
| Trigonometry | sin, cos, tan |
| Inverse Trig | sin⁻¹, cos⁻¹, tan⁻¹ |
| Logarithms | log (base 10), ln (natural) |
| Powers | x², x³, xʸ |
| Roots | √x, ³√x |
| Constants | π, e |

*Note: Intentionally limited set for students, not overwhelming*

---

## Settings (Phase 3 - Future)

### Access Method
- **Gear icon** in top-right corner of calculator screen

### Settings Options

#### Appearance
- Theme: Light / Dark / System
- Platform Style: iOS / Android / Auto
- Accent Color: Blue (default), Orange, Purple, Green, Custom
- Button Size: Small / Medium / Large

#### Behavior
- Haptic Feedback: On / Off
- Sound Effects: On / Off
- Decimal Precision: 2-10 places
- Angle Unit Default: Degrees / Radians

#### Data
- Clear History
- Reset All Settings

---

## User Flows

### Flow 1: Basic Calculation
```
1. User opens MathMate
2. Display shows "0"
3. User taps: 2 + 3 × 4
4. Expression shows: "2 + 3 × 4"
5. Live preview shows: "14" (PEMDAS applied)
6. User taps =
7. Result "14" is emphasized
8. Tapping a number starts new calculation
9. Tapping operator continues from result
```

### Flow 2: Error Prevention
```
1. User types: 5 ÷ 0
2. As "0" is typed after "÷", system detects potential error
3. "=" button shows warning state
4. User taps "="
5. Inline message: "Cannot divide by zero"
6. Message fades after 2 seconds
7. Expression remains editable
```

### Flow 3: Parentheses Auto-Balance
```
1. User types: 2 × (3 + 4
2. Expression shows: "2 × (3 + 4" with "(" highlighted
3. Live preview shows: "14" (auto-balanced internally)
4. User taps =
5. Expression auto-completes to: "2 × (3 + 4)"
6. Result: "14"
```

---

## Technical Architecture

### Project Structure (Clean Architecture)

```
lib/
├── main.dart                      # App entry point
├── app.dart                       # App widget, theme setup
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # Color definitions
│   │   ├── app_strings.dart       # Text constants
│   │   └── app_dimensions.dart    # Sizes, padding, spacing
│   ├── theme/
│   │   └── app_theme.dart         # Theme configuration
│   └── utils/
│       ├── calculator_engine.dart # Math evaluation logic
│       └── expression_parser.dart # Parse and validate expressions
│
├── features/
│   └── calculator/
│       ├── data/
│       │   └── calculator_repository.dart  # State persistence
│       ├── domain/
│       │   └── models/
│       │       ├── calculation.dart        # Calculation model
│       │       └── calculator_state.dart   # State model
│       └── presentation/
│           ├── bloc/
│           │   ├── calculator_bloc.dart    # Business logic
│           │   ├── calculator_event.dart   # Events
│           │   └── calculator_state.dart   # States
│           ├── screens/
│           │   └── calculator_screen.dart  # Main screen
│           └── widgets/
│               ├── calculator_display.dart # Display component
│               ├── calculator_keypad.dart  # Button grid
│               └── calculator_button.dart  # Individual button
│
└── docs.md                        # App documentation
```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3        # State management
  equatable: ^2.0.5           # Value equality for states
  shared_preferences: ^2.2.2  # Persistence
  math_expressions: ^2.4.0    # Expression parsing

dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5           # BLoC testing
  mocktail: ^1.0.1            # Mocking for tests
  very_good_analysis: ^5.1.0  # Lint rules
```

### State Management (BLoC)

```
Events → BLoC → States → UI

Events:
- NumberPressed(String digit)
- OperatorPressed(String operator)
- EqualsPressed()
- ClearPressed()
- AllClearPressed()
- ParenthesisPressed(bool isOpen)

States:
- CalculatorInitial
- CalculatorInput(expression, liveResult)
- CalculatorResult(expression, result)
- CalculatorError(expression, errorMessage)
```

---

## Development Approach

### Methodology: MVP First + TDD

1. **Write test first** for each feature
2. **Implement minimal code** to pass test
3. **Refactor** for clean code
4. **Repeat** for next feature

### Documentation Strategy

1. **Inline comments:** Explain what each part does (beginner-friendly)
2. **Chat explanations:** Detailed explanations during implementation
3. **docs.md file:** Living documentation of app functionality

### MVP Implementation Order

```
1. Project Setup
   └── Create Flutter project
   └── Configure dependencies
   └── Set up folder structure

2. Calculator Engine (TDD)
   └── Test: Basic arithmetic
   └── Test: PEMDAS order
   └── Test: Error handling
   └── Implement engine

3. Display Widget
   └── Test: Shows expression
   └── Test: Shows live result
   └── Implement dual-line display

4. Keypad Widget
   └── Test: Button rendering
   └── Test: Button callbacks
   └── Implement button grid

5. BLoC Integration
   └── Test: State transitions
   └── Wire up UI to BLoC

6. Polish
   └── Animations
   └── Haptic/sound feedback
   └── Error handling UI
```

---

## Non-Functional Requirements

### Performance
- App launch: < 2 seconds cold start
- Button response: < 100ms
- Animations: 60fps smooth

### Accessibility (Minimal for MVP)
- Semantic labels on buttons (for future VoiceOver)
- Sufficient color contrast
- Large touch targets (48dp minimum)

### Code Quality
- Clean Architecture separation
- BLoC pattern for state
- TDD with good test coverage
- Well-documented code

---

## Future Roadmap

### Phase 2: Scientific Mode
- Scientific keypad
- Mode toggle + swipe switching
- Trig, log, power functions

### Phase 3: Themes & Settings
- Dark mode
- Platform-adaptive UI (Cupertino/Material)
- Settings screen
- Custom accent colors

### Phase 4: iPad Support
- Adaptive layout for larger screens
- Side-by-side history panel

### Out of Scope (Not Planned)
- Calculation history
- Unit/currency converter
- Programmer mode (hex/binary)
- Graphing
- Apple Watch app

---

## Success Criteria (MVP)

- [ ] App builds and runs on iOS Simulator
- [ ] All basic operations work correctly
- [ ] PEMDAS order of operations correct
- [ ] Expression + live result display works
- [ ] Error handling prevents crashes
- [ ] State persists across app restarts
- [ ] Animations are smooth (60fps)
- [ ] Tests pass with 80%+ coverage
- [ ] Code is well-documented
