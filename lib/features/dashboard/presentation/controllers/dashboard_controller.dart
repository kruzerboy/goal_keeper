import 'package:flutter/foundation.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';
import 'package:goal_keeper_app/core/utils/use_case.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal.dart';
import 'package:goal_keeper_app/features/goals/domain/usecases/goal_usecases.dart';

/// Dashboard data model — what the screen needs to render.
final class DashboardData {
  final List<Goal> todaysGoals;
  final int completedCount;
  final int totalCount;
  final double goalScore;
  final int weeklyCompleted;
  final int weeklyTotal;
  final String dailyWisdom;

  const DashboardData({
    required this.todaysGoals,
    required this.completedCount,
    required this.totalCount,
    required this.goalScore,
    required this.weeklyCompleted,
    required this.weeklyTotal,
    required this.dailyWisdom,
  });
}

/// Controller owns ALL business logic for DashboardScreen.
/// The screen only calls methods and renders state — zero logic in widgets.
///
/// When Riverpod is added: convert to `AsyncNotifier<DashboardData>`.
final class DashboardController extends ChangeNotifier {
  final GetTodaysGoalsUseCase _getTodaysGoals;
  final ToggleGoalCompletionUseCase _toggleGoal;

  DashboardController({
    required GetTodaysGoalsUseCase getTodaysGoals,
    required ToggleGoalCompletionUseCase toggleGoal,
  })  : _getTodaysGoals = getTodaysGoals,
        _toggleGoal = toggleGoal;

  ScreenState<DashboardData> _state = const ScreenInitial();
  ScreenState<DashboardData> get state => _state;

  /// Emitted when a toggle action is in-flight (for optimistic UI).
  final Set<String> _pendingToggles = {};
  bool isPendingToggle(String id) => _pendingToggles.contains(id);

  Future<void> load() async {
    _state = const ScreenLoading();
    notifyListeners();

    final result = await _getTodaysGoals(const NoParams());

    result.when(
      failure: (f) {
        _state = ScreenError(f.message);
        notifyListeners();
      },
      success: (goals) {
        _state = ScreenLoaded(_buildDashboardData(goals));
        notifyListeners();
      },
    );
  }

  Future<void> toggleGoal(String id) async {
    // Optimistic update: flip locally before API resolves.
    final current = _state;
    if (current is! ScreenLoaded<DashboardData>) return;

    _pendingToggles.add(id);
    final optimistic = _optimisticallyToggle(current.data, id);
    _state = ScreenLoaded(optimistic);
    notifyListeners();

    final result = await _toggleGoal(id);

    result.when(
      failure: (f) {
        // Revert on failure.
        _state = current;
        _pendingToggles.remove(id);
        notifyListeners();
      },
      success: (updatedGoal) {
        _pendingToggles.remove(id);
        // Re-derive state from truth.
        final goals = optimistic.todaysGoals
            .map((g) => g.id == id ? updatedGoal : g)
            .toList();
        _state = ScreenLoaded(_buildDashboardData(goals));
        notifyListeners();
      },
    );
  }

  Future<void> refresh() => load();

  // ─── Private helpers ──────────────────────────────────────────────────────

  DashboardData _buildDashboardData(List<Goal> goals) {
    final completed = goals.where((g) => g.isCompleted).length;
    return DashboardData(
      todaysGoals: goals,
      completedCount: completed,
      totalCount: goals.length,
      goalScore: goals.isEmpty ? 0 : completed / goals.length,
      weeklyCompleted: 12,
      weeklyTotal: 16,
      dailyWisdom:
          '"Focus on the step in front of you, not the whole staircase."',
    );
  }

  DashboardData _optimisticallyToggle(DashboardData data, String id) {
    final goals = data.todaysGoals
        .map((g) => g.id == id ? g.copyWith(isCompleted: !g.isCompleted) : g)
        .toList();
    return _buildDashboardData(goals);
  }
} // ChangeNotifier → AsyncNotifier (Riverpod)

