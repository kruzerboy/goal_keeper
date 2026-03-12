import 'package:flutter/foundation.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';
import 'package:goal_keeper_app/features/goals_overview/domain/repositories/goals_overview_repository.dart';

final class GoalsOverviewData {
  final List<GoalItem> goals;
  final GoalTimeframe activeTab;

  const GoalsOverviewData({
    required this.goals,
    required this.activeTab,
  });
}

final class GoalsOverviewController extends ChangeNotifier {
  final GoalsOverviewRepository _getGoals;

  GoalsOverviewController({required GoalsOverviewRepository getGoals})
      : _getGoals = getGoals;

  ScreenState<GoalsOverviewData> _state = const ScreenInitial();
  ScreenState<GoalsOverviewData> get state => _state;

  GoalTimeframe _activeTab = GoalTimeframe.daily;
  GoalTimeframe get activeTab => _activeTab;

  Future<void> load() async {
    _state = const ScreenLoading();
    notifyListeners();
    await _fetchForTab(_activeTab);
  }

  Future<void> switchTab(GoalTimeframe tab) async {
    _activeTab = tab;
    _state = const ScreenLoading();
    notifyListeners();
    await _fetchForTab(tab);
  }

  Future<void> _fetchForTab(GoalTimeframe tab) async {
    final result = await _getGoals.getGoalsByTimeframe(tab);
    result.when(
      failure: (f) {
        _state = ScreenError(f.message);
        notifyListeners();
      },
      success: (goals) {
        _state = ScreenLoaded(GoalsOverviewData(goals: goals, activeTab: tab));
        notifyListeners();
      },
    );
  }

  Future<void> refresh() => load();
}