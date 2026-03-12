// DI graph, swap implementations here
/// Manual dependency injection — the single place where the dependency
/// graph is wired together.
///
/// When Riverpod is added, replace [ServiceLocator] with a providers file:
///   final goalRepositoryProvider = Provider<GoalRepository>((_) => GoalRepositoryImpl());
///   final getTodaysGoalsProvider = Provider((ref) => GetTodaysGoalsUseCase(ref.read(goalRepositoryProvider)));
///
/// Until then, controllers are created via [ServiceLocator.dashboardController].
/// This ensures:
/// - All controllers are constructed the same way in tests and in production.
/// - Swapping implementations (fake → real) happens in ONE place.
library;

import 'package:goal_keeper_app/features/add_goal/presentation/controllers/add_goal_controller.dart';
import 'package:goal_keeper_app/features/analytics/presentation/controllers/analytics_controller.dart';
import 'package:goal_keeper_app/features/goals/data/repositories/goal_repository_impl.dart';
import 'package:goal_keeper_app/features/goals/domain/repositories/goal_repository.dart';
import 'package:goal_keeper_app/features/goals/domain/usecases/goal_usecases.dart';
import 'package:goal_keeper_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:goal_keeper_app/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:goal_keeper_app/features/settings/presentation/controllers/reminder_settings_controller.dart';


final class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  // ─── Repositories ──────────────────────────────────────────────────────
  // Swap GoalRepositoryImpl with a real one (e.g. FirebaseGoalRepositoryImpl)
  // by changing ONE line here.

  late final GoalRepository goalRepository = GoalRepositoryImpl();

  // ─── Use Cases ─────────────────────────────────────────────────────────

  late final getTodaysGoalsUseCase = GetTodaysGoalsUseCase(goalRepository);
  late final getGoalsUseCase = GetGoalsUseCase(goalRepository);
  late final toggleGoalUseCase = ToggleGoalCompletionUseCase(goalRepository);
  late final createGoalUseCase = CreateGoalUseCase(goalRepository);
  late final deleteGoalUseCase = DeleteGoalUseCase(goalRepository);

  // ─── Controllers ───────────────────────────────────────────────────────
  // Controllers are NOT singletons — create fresh on each screen mount.
  // Call .dispose() in screen's dispose().

  DashboardController dashboardController() => DashboardController(
        getTodaysGoals: getTodaysGoalsUseCase,
        toggleGoal: toggleGoalUseCase,
      );

  AuthController authController() => AuthController();

  AddGoalController addGoalController() => AddGoalController();

  AnalyticsController analyticsController() => AnalyticsController();

  ReminderSettingsController reminderSettingsController() => ReminderSettingsController();
}