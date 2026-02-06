# App Development Categories

A tracker for learning app development concepts through building MathMate and future projects.

---

## Categories Covered

### State Management — High
**What it is:** Managing and updating app data in response to user actions, ensuring UI stays in sync with underlying state.

**What we did:**
- Implemented BLoC pattern with events, states, and stream-based updates
- Built 41 BLoC tests covering event handling, state transitions, edge cases
- Unidirectional data flow: Event → BLoC → State → UI
- Used Cubit (simpler BLoC) for ThemeCubit (15 tests) and HistoryCubit (13 tests)
- Multiple state managers working together (CalculatorBloc + ThemeCubit + HistoryCubit)
- Stream subscriptions in Cubit for reactive database updates (HistoryCubit)
- MultiBlocProvider for providing multiple BLoCs/Cubits

**To explore further:**
- Other state management solutions (Riverpod, Provider)
- Complex state with BLoC-to-BLoC communication
- State restoration (Android process death)

---

### Test-Driven Development (TDD) — High
**What it is:** Writing tests before implementation code. Red → Green → Refactor cycle.

**What we did:**
- Wrote tests first for calculator engine (45 tests)
- Wrote tests first for BLoC (41 tests)
- Widget tests for UI components (59 tests)
- Repository tests with SharedPreferences mocking (17 calculator + 19 theme)
- Theme cubit tests (15 tests)
- History repository tests with in-memory database (21 tests)
- History cubit tests (13 tests)
- **231 total tests**

**To explore further:**
- Integration tests (full app flows)
- Golden tests (screenshot comparison)
- Code coverage metrics
- Test doubles (mocks, stubs, fakes)

---

### Clean Architecture — High
**What it is:** Organizing code into layers with clear separation of concerns and dependency rules.

**What we did:**
- Presentation layer: widgets, screens, BLoC
- Domain layer: events, states (business logic models)
- Data layer: repository for persistence
- Dependency injection via constructors

**To explore further:**
- Use cases / interactors
- Domain entities vs data models
- Repository pattern with multiple data sources
- DI frameworks (get_it, injectable)

---

### Widget Composition — High
**What it is:** Building complex UIs from small, reusable widget components.

**What we did:**
- `CalculatorButton` → reusable button with types
- `CalculatorKeypad` → composes 24 buttons in grid
- `CalculatorDisplay` → dual-line display
- `CalculatorScreen` → combines display + keypad + BLoC

**To explore further:**
- Inherited widgets for data sharing
- Custom RenderObjects
- Keys and widget identity
- Performance optimization (const constructors, RepaintBoundary)

---

### Local Persistence — High
**What it is:** Saving data locally on the device so it survives app restarts.

**What we did:**
- SharedPreferences for key-value storage
- CalculatorRepository: save/load expression and result (17 tests)
- ThemeRepository: save/load theme mode and accent color (19 tests)
- Auto-save on state change, restore on app start
- Repository pattern with async factory constructors
- **Drift (SQLite ORM) for calculation history** (Phase 11 complete)
  - HistoryDatabase with migrations strategy
  - HistoryRepository with CRUD operations (21 tests)
  - Reactive database queries (Streams)
  - Code generation with build_runner

**To explore further:**
- Hive for NoSQL local storage
- Secure storage for sensitive data
- File system storage
- Database migrations (schema changes)

---

### Theming & Constants — High
**What it is:** Centralizing visual design (colors, typography, spacing) for consistency and maintainability.

**What we did:**
- `AppColors` — light + dark color palettes (70+ constants)
- `AppDimensions` — sizes, spacing, animation durations
- `AppStrings` — text constants
- `AppTheme` — Material 3 light and dark themes
- `CalculatorColors` — ThemeExtension for widget-specific colors
- Dark mode with full color system
- System theme following (ThemeMode.system)
- 5 custom accent colors (blue, green, purple, orange, teal)
- Settings bottom sheet with theme mode selector + color picker
- Theme state management with ThemeCubit (15 tests)
- Theme persistence with ThemeRepository (19 tests)

**To explore further:**
- Typography scales
- Design tokens
- Animated theme transitions

---

### Accessibility — Medium-Low
**What it is:** Making apps usable by people with disabilities (vision, motor, hearing impairments).

**What we did:**
- Semantic labels on buttons for screen readers
- Sufficient color contrast (not formally tested)

**To explore further:**
- Testing with VoiceOver / TalkBack
- Dynamic type / text scaling
- Focus management
- Sufficient touch target sizes (48x48dp minimum)
- Reduce motion preferences

---

### Animations — Low
**What it is:** Motion design that provides feedback, guides attention, and creates delight.

**What we did:**
- Button press scale animation (0.95)
- AnimatedScale widget with 150ms duration

**To explore further:**
- Implicit animations (AnimatedContainer, AnimatedOpacity)
- Explicit animations (AnimationController, Tween)
- Page transitions
- Hero animations
- Staggered animations
- Lottie / Rive animations

---

## Categories Not Yet Explored

### Navigation & Routing — Not covered
**What it is:** Moving between screens, passing data, managing navigation stack.

**Topics to learn:**
- Navigator 1.0 (push, pop, named routes)
- Navigator 2.0 / go_router for declarative routing
- Passing arguments between screens
- Deep linking
- Bottom navigation / tab bars
- Drawer navigation

---

### Networking & APIs — Not covered
**What it is:** Communicating with remote servers to fetch or send data.

**Topics to learn:**
- HTTP requests (GET, POST, PUT, DELETE)
- REST API consumption
- JSON parsing / serialization
- Error handling (timeouts, 4xx, 5xx)
- Loading and error states in UI
- Caching strategies
- GraphQL (optional)

---

### Authentication — Not covered
**What it is:** Verifying user identity and managing sessions.

**Topics to learn:**
- Email/password authentication
- OAuth / social login
- Token storage (secure storage)
- Session management
- Biometric authentication (Face ID, fingerprint)
- Protected routes

---

### Databases — Medium
**What it is:** Structured local storage for complex data with relationships and queries.

**What we did:**
- SQLite via Drift ORM for calculation history
- Type-safe queries with generated code (build_runner)
- Reactive streams for live database updates
- CRUD operations: insert, select, delete
- Migration strategy setup for future schema changes
- In-memory database for testing

**To explore further:**
- Complex queries with JOINs
- Relationships between tables
- Indexing and query optimization
- Hive for NoSQL alternative
- Data sync with remote backend

---

### Dependency Injection — Low
**What it is:** Providing dependencies to classes from the outside, enabling testing and flexibility.

**What we did:**
- Manual constructor injection (repository → BLoC)

**Topics to learn:**
- Service locators (get_it)
- Code generation (injectable)
- Scoped dependencies
- Lazy vs eager initialization

---

### Internationalization (i18n) — Not covered
**What it is:** Supporting multiple languages and regional formats.

**Topics to learn:**
- ARB files and localization
- flutter_localizations package
- Pluralization and gender
- RTL language support
- Date/number/currency formatting

---

### Responsive & Adaptive UI — Not covered
**What it is:** Layouts that adapt to different screen sizes and platforms.

**Topics to learn:**
- MediaQuery and LayoutBuilder
- Breakpoints for phone/tablet/desktop
- Orientation handling
- Platform-adaptive widgets
- Flexible and Expanded widgets

---

### Platform Channels — Not covered
**What it is:** Calling native iOS/Android code from Flutter.

**Topics to learn:**
- Method channels
- Event channels for streams
- Writing Swift/Kotlin code
- Platform-specific features (HealthKit, etc.)

---

### Background Processing — Not covered
**What it is:** Running code when the app is not in the foreground.

**Topics to learn:**
- Isolates for heavy computation
- WorkManager for background tasks
- Background fetch
- Foreground services

---

### Push Notifications — Not covered
**What it is:** Sending messages to users even when the app is closed.

**Topics to learn:**
- Firebase Cloud Messaging (FCM)
- Local notifications
- Notification channels (Android)
- Handling notification taps
- Rich notifications (images, actions)

---

### CI/CD & Deployment — Not covered
**What it is:** Automating testing, building, and releasing apps.

**Topics to learn:**
- GitHub Actions for Flutter
- Automated testing on PR
- Fastlane for deployment
- App Store Connect / Google Play Console
- Code signing
- Beta distribution (TestFlight, Firebase App Distribution)

---

### Error Monitoring & Analytics — Not covered
**What it is:** Tracking crashes, errors, and user behavior in production.

**Topics to learn:**
- Firebase Crashlytics
- Sentry for error tracking
- Firebase Analytics / Mixpanel
- Event tracking
- User properties and funnels

---

### Complex UI Patterns — Low-Medium
**What it is:** Advanced UI components for data-heavy apps.

**What we did:**
- ListView.builder for history list (lazy loading)
- DraggableScrollableSheet for expandable bottom sheet
- Modal bottom sheets (settings, history)

**To explore further:**
- GridView for grid layouts
- Infinite scroll / pagination
- Slivers and CustomScrollView
- Pull-to-refresh
- Custom painters (Canvas API)

---

### Forms & Validation — Not covered
**What it is:** Collecting and validating user input.

**Topics to learn:**
- TextFormField and Form widget
- Validation rules and error messages
- Form state management
- Input formatters
- Focus management
- Keyboard types

---

### Advanced Gestures — Low-Medium
**What it is:** Handling complex touch interactions beyond simple taps.

**What we did:**
- Dismissible widget for swipe-to-delete in history list
- DraggableScrollableSheet for history bottom sheet

**To explore further:**
- GestureDetector for custom gestures
- Drag and drop
- Pinch to zoom
- Long press menus
- Reorderable lists

---

## Progress Summary

| Category | Level | Project |
|----------|-------|---------|
| State Management (BLoC) | High | MathMate |
| Test-Driven Development | High | MathMate |
| Clean Architecture | High | MathMate |
| Widget Composition | High | MathMate |
| Local Persistence | High | MathMate |
| Theming & Constants | High | MathMate |
| Databases | Medium | MathMate |
| Complex UI Patterns | Low-Medium | MathMate |
| Advanced Gestures | Low-Medium | MathMate |
| Accessibility | Medium-Low | MathMate |
| Animations | Low | MathMate |
| Dependency Injection | Low | MathMate |
| Navigation & Routing | Not covered | — |
| Networking & APIs | Not covered | — |
| Authentication | Not covered | — |
| Internationalization | Not covered | — |
| Responsive UI | Not covered | — |
| Platform Channels | Not covered | — |
| Background Processing | Not covered | — |
| Push Notifications | Not covered | — |
| CI/CD & Deployment | Not covered | — |
| Error Monitoring | Not covered | — |
| Forms & Validation | Not covered | — |

---

## Suggested Learning Path

1. **Navigation** — Most apps have multiple screens
2. **Networking** — Almost every real app calls APIs
3. **Forms & Validation** — Essential for user input
4. **CI/CD** — Automate testing and deployment
5. **Authentication** — User accounts and sessions
6. **Internationalization** — Multi-language support
