# Goal Keeper — Flutter Clean Architecture

A production-ready Flutter scaffold designed to scale to 50+ screens with strict separation of concerns between UI, controllers, and business logic.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                       PRESENTATION LAYER                         │
│                                                                 │
│   Screen               Controller            Widgets            │
│   (renders state)      (owns all logic)      (purely visual)    │
│       │                     │                     │             │
│       └──── calls ──────────┘                     │             │
│       └──── renders ──────────────────────────────┘             │
└────────────────────────────┬────────────────────────────────────┘
                             │  calls UseCases
┌────────────────────────────▼────────────────────────────────────┐
│                        DOMAIN LAYER                              │
│                                                                 │
│   Entities (pure Dart)    UseCases          Repository ABCs     │
│   Goal, User, ...         GetGoals()        GoalRepository      │
└────────────────────────────┬────────────────────────────────────┘
                             │  implements
┌────────────────────────────▼────────────────────────────────────┐
│                         DATA LAYER                               │
│                                                                 │
│   Models (DTOs)       Repository Impls      DataSources         │
│   GoalModel           GoalRepositoryImpl    Remote + Local      │
└─────────────────────────────────────────────────────────────────┘
```

**The golden rule**: dependencies only point inward. Domain never imports Flutter, data, or presentation code. Screens never import repositories or use cases directly.

---

## Full Folder Structure

```
lib/
├── main.dart
│
├── core/                                        # Shared infrastructure
│   ├── di/
│   │   └── service_locator.dart                # Wires the entire DI graph
│   ├── error/
│   │   ├── failures.dart                       # Typed failures: Network, Auth, Cache...
│   │   └── result.dart                         # Result<T> = Success<T> | Failure_<T>
│   ├── router/
│   │   └── app_router.dart                     # go_router config + AppRoutes constants
│   ├── theme/
│   │   └── app_theme.dart                      # AppColors, AppSpacing, AppRadius, AppTypography
│   ├── utils/
│   │   ├── screen_state.dart                   # ScreenState<T> sealed class (6 variants)
│   │   └── use_case.dart                       # UseCase<R,P> interface + NoParams
│   └── widgets/
│       ├── buttons/
│       │   └── app_button.dart                 # Unified button: primary / outlined / ghost
│       ├── inputs/
│       │   └── app_text_field.dart             # Labelled text field with error support
│       └── feedback/
│           └── state_handler.dart              # StateHandler<T>: loading/error/empty/loaded
│
└── features/
    │
    ├── splash/                                  # ─── SPLASH ──────────────────────────────
    │   └── presentation/
    │       └── screens/
    │           └── splash_screen.dart          # Animated gradient splash, auto-nav after 3s
    │
    ├── auth/                                    # ─── AUTH ────────────────────────────────
    │   └── presentation/
    │       ├── controllers/
    │       │   └── auth_controller.dart        # signIn, signInWithGoogle, validate, toggle pw
    │       └── screens/
    │           ├── login_screen.dart           # Thin: delegates all logic to AuthController
    │           └── signup_screen.dart          # Stub — ready to implement
    │
    ├── dashboard/                               # ─── DASHBOARD ───────────────────────────
    │   └── presentation/
    │       ├── controllers/
    │       │   └── dashboard_controller.dart   # Loads goals, toggles with optimistic update
    │       ├── screens/
    │       │   └── dashboard_screen.dart       # Goal score ring, milestone, today's goals
    │       └── widgets/
    │           ├── goal_item_widget.dart        # Goal row with animated toggle + pending state
    │           └── goal_score_ring.dart         # CustomPainter circular progress ring
    │
    ├── goals/                                   # ─── GOALS (domain + data) ───────────────
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── goal_model.dart             # DTO: fromJson, toJson, fromEntity
    │   │   └── repositories/
    │   │       └── goal_repository_impl.dart   # In-memory seed; swap for Firestore/REST
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── goal.dart                   # Pure Dart entity: id, title, category, priority
    │   │   ├── repositories/
    │   │   │   └── goal_repository.dart        # Abstract contract (interface)
    │   │   └── usecases/
    │   │       └── goal_usecases.dart          # GetGoals, GetTodaysGoals, Toggle, Create, Delete
    │   └── presentation/
    │       └── screens/
    │           ├── goal_detail_screen.dart     # Stub — ready to implement
    │           ├── goals_list_screen.dart      # Stub — ready to implement
    │           └── add_goal_screen.dart        # Stub (superseded by add_goal feature)
    │
    ├── goals_overview/                          # ─── GOALS OVERVIEW ──────────────────────
    │   ├── data/
    │   │   └── repositories/
    │   │       └── goals_overview_repository_impl.dart  # Seed data per timeframe; swap for API
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── goal_item.dart              # GoalItem, GoalStatus, GoalTimeframe, PriorityLevel
    │   │   ├── repositories/
    │   │   │   └── goals_overview_repository.dart  # Abstract contract: getGoalsByTimeframe, updateProgress
    │   │   └── usecases/
    │   │       └── goals_overview_usecases.dart  # GetGoalsByTimeframeUseCase
    │   └── presentation/
    │       ├── controllers/
    │       │   └── goals_overview_controller.dart  # Tab state + per-tab data fetching
    │       ├── screens/
    │       │   └── goals_overview_screen.dart  # Daily/Weekly/Monthly/Yearly/Life tabs + list
    │       └── widgets/
    │           └── goal_card.dart              # Status badge, progress bar, action button
    │
    ├── add_goal/                                # ─── ADD GOAL ────────────────────────────
    │   ├── domain/
    │   │   └── entities/
    │   │       └── add_goal_form.dart          # Immutable form state with isValid guard
    │   └── presentation/
    │       ├── controllers/
    │       │   └── add_goal_controller.dart    # Form fields, calendar nav, save with loading
    │       └── screens/
    │           └── add_goal_screen.dart        # Name, category, priority selector, calendar
    │
    ├── analytics/                               # ─── PROGRESS ANALYTICS ──────────────────
    │   ├── domain/
    │   │   └── entities/
    │   │       └── analytics_data.dart         # AnalyticsData, AnalyticsBadge, AnalyticsRange
    │   └── presentation/
    │       ├── controllers/
    │       │   └── analytics_controller.dart   # Range switching, data derivation
    │       ├── screens/
    │       │   └── progress_analytics_screen.dart  # Chart, stats, badges, quick insight
    │       └── widgets/
    │           └── analytics_line_chart.dart   # CustomPainter line chart with gradient fill
    │
    ├── settings/                                # ─── REMINDER SETTINGS ───────────────────
    │   ├── domain/
    │   │   └── entities/
    │   │       └── reminder_settings.dart      # Immutable settings entity + copyWith
    │   └── presentation/
    │       ├── controllers/
    │       │   └── reminder_settings_controller.dart  # Toggle/set each setting field
    │       └── screens/
    │           └── reminder_settings_screen.dart  # Toggles, time picker, frequency selector
    │
    └── profile/                                 # ─── PROFILE ─────────────────────────────
        └── presentation/
            └── screens/
                └── profile_screen.dart         # Stub — ready to implement
```

---

## Screens Implemented

| # | Screen | Route | Status | Controller |
|---|--------|-------|--------|------------|
| 1 | Splash | `/` | ✅ Done | — |
| 2 | Login | `/login` | ✅ Done | `AuthController` |
| 3 | Signup | `/signup` | 🔲 Stub | `AuthController` |
| 4 | Home Dashboard | `/dashboard` | ✅ Done | `DashboardController` |
| 5 | Goals Overview | `/goals` | ✅ Done | `GoalsOverviewController` |
| 6 | Add New Goal | `/goals/add` | ✅ Done | `AddGoalController` |
| 7 | Goal Detail | `/goals/:id` | 🔲 Stub | — |
| 8 | Progress Analytics | `/analytics` | ✅ Done | `AnalyticsController` |
| 9 | Reminder Settings | `/settings/reminders` | ✅ Done | `ReminderSettingsController` |
| 10 | Profile | `/profile` | 🔲 Stub | — |

---

## Core Patterns

### 1. Result\<T\> — No raw exceptions in business logic

Every use case returns `AsyncResult<T>`. Controllers always handle both branches. Exceptions never propagate to the UI.

```dart
final result = await getTodaysGoalsUseCase(const NoParams());
result.when(
  failure: (f) => _state = ScreenError(f.message),
  success: (goals) => _state = ScreenLoaded(_buildData(goals)),
);
```

### 2. ScreenState\<T\> — Consistent state machine across all screens

Six sealed variants: `ScreenInitial`, `ScreenLoading`, `ScreenLoaded`, `ScreenError`, `ScreenEmpty`, `ScreenLoadingMore`. Every screen uses `StateHandler<T>` — no copy-pasted loading/error boilerplate.

```dart
StateHandler<DashboardData>(
  state: _controller.state,
  onRetry: _controller.refresh,
  onLoaded: (data) => _DashboardBody(data: data),
)
```

### 3. Controller pattern — Screens are dumb by design

Screens own: widget tree, `TextEditingController`s, and one call to the controller per interaction. That's it.

```dart
// Screen calls a method — controller decides everything else
AppButton(
  label: 'Sign In',
  isLoading: isLoading,
  onPressed: () => _controller.signIn(
    email: _emailCtrl.text,
    password: _passwordCtrl.text,
    onSuccess: () => context.go(AppRoutes.dashboard),
  ),
)
```

### 4. Optimistic updates — Fast UI, safe rollback

`DashboardController.toggleGoal()` flips the local state instantly, fires the use case in the background, and rolls back on failure — without the screen knowing any of this happened.

```dart
// Controller handles this transparently:
_pendingToggles.add(id);                          // show spinner on item
_state = ScreenLoaded(_optimisticallyToggle(...)); // flip immediately
notifyListeners();

final result = await _toggleGoal(id);
result.when(
  failure: (_) { _state = previousState; ... },  // silent rollback
  success: (goal) { /* confirm */ },
);
```

### 5. Immutable form state — Forms as value objects

`AddGoalForm` and `ReminderSettings` are plain immutable Dart classes. Controllers update them via `copyWith` — no mutable form fields scattered across a screen.

```dart
void updatePriority(PriorityLevel priority) {
  _form = _form.copyWith(priority: priority);
  notifyListeners();
}
```

---

## Adding a New Screen (Checklist)

Follow these steps every time. The order matters — work from domain outward.

1. **Entity** → `features/x/domain/entities/x.dart`  
   Pure Dart class, zero Flutter imports, `copyWith`, `==` and `hashCode`.

2. **Repository interface** → `features/x/domain/repositories/x_repository.dart`  
   Abstract interface listing all data operations as `AsyncResult<T>` methods.

3. **Use cases** → `features/x/domain/usecases/x_usecases.dart`  
   One `final class` per action, implementing `UseCase<R, P>`.

4. **Model (DTO)** → `features/x/data/models/x_model.dart`  
   Extends the entity. Adds `fromJson`, `toJson`, `fromEntity`.

5. **Repository impl** → `features/x/data/repositories/x_repository_impl.dart`  
   Implements the interface. Start with in-memory fake data; swap for real datasource later.

6. **Controller** → `features/x/presentation/controllers/x_controller.dart`  
   `ChangeNotifier`, holds `ScreenState<XData>`, calls use cases, never touches widgets.

7. **Screen** → `features/x/presentation/screens/x_screen.dart`  
   Thin. Creates controller in `initState`, calls `addListener(_rebuild)`, disposes both. Uses `StateHandler<XData>` for the body.

8. **Register** → `core/di/service_locator.dart`  
   Add repository as a `late final` singleton, use cases as `late final`, controller as a factory method.

9. **Route** → `core/router/app_router.dart`  
   Add a constant to `AppRoutes`, add a `GoRoute` to `appRouter`.

---

## Riverpod Migration Path

The architecture is designed so that migrating to Riverpod requires touching **only the DI and controller layers** — no screens, no use cases, no entities change.

**Step 1**: Add `flutter_riverpod` and `riverpod_annotation` to `pubspec.yaml`.

**Step 2**: Create a `providers.dart` per feature, replacing `ServiceLocator`:

```dart
// features/goals/presentation/providers/goal_providers.dart

final goalRepositoryProvider = Provider<GoalRepository>(
  (_) => GoalRepositoryImpl(),
);

final getTodaysGoalsProvider = Provider(
  (ref) => GetTodaysGoalsUseCase(ref.read(goalRepositoryProvider)),
);

final dashboardControllerProvider =
    AsyncNotifierProvider<DashboardController, DashboardData>(
  DashboardController.new,
);
```

**Step 3**: Convert each `ChangeNotifier` controller to `AsyncNotifier<XData>`:

```dart
// Before (ChangeNotifier):
class DashboardController extends ChangeNotifier { ... }

// After (AsyncNotifier):
class DashboardController extends AsyncNotifier<DashboardData> {
  @override
  Future<DashboardData> build() async => _load();
}
```

**Step 4**: Update screens to use `ref.watch` instead of `addListener`:

```dart
// Before:
_controller = ServiceLocator.instance.dashboardController()
  ..addListener(_rebuild);

// After:
final data = ref.watch(dashboardControllerProvider);
```

Screens, use cases, entities, and repositories require **zero changes**.

---

## Design Tokens

No hard-coded values anywhere in widget files. Always use tokens from `app_theme.dart`:

| Token | Use for | Example |
|-------|---------|---------|
| `AppColors.primary` | Brand blue | `Color(0xFF2563EB)` |
| `AppColors.accent` | Success green | `Color(0xFF10B981)` |
| `AppColors.textSecondary` | Muted text | `Color(0xFF64748B)` |
| `AppColors.border` | Dividers, card borders | `Color(0xFFE2E8F0)` |
| `AppSpacing.md` | Standard padding/gap | `16.0` |
| `AppSpacing.screenPadding` | Screen horizontal padding | `EdgeInsets.symmetric(h: 20, v: 16)` |
| `AppRadius.md` | Card border radius | `12.0` |
| `AppRadius.full` | Pills, buttons | `100.0` |
| `AppTypography.headlineMedium` | Section titles | `18px w600` |
| `AppTypography.bodySmall` | Captions, labels | `12px textSecondary` |
| `AppTypography.labelSmall` | ALL CAPS section headers | `10px w500 letterSpacing 1.2` |

---

## Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.0        # uncomment when adding state management
  go_router: ^13.0.0              # navigation — already in use
  dio: ^5.4.0                     # uncomment for HTTP
  hive_flutter: ^1.1.0            # uncomment for local storage
  flutter_secure_storage: ^9.0.0  # uncomment for token storage
  uuid: ^4.3.0                    # uncomment for ID generation
  intl: ^0.19.0                   # uncomment for date formatting

dev_dependencies:
  build_runner: ^2.4.0            # uncomment for code generation
  riverpod_generator: ^2.3.0      # uncomment with riverpod
```