import 'package:goal_keeper_app/features/goals_overview/domain/repositories/goals_overview_repository.dart';

import '../../../../core/error/result.dart';
import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';


final class GoalsOverviewRepositoryImpl implements GoalsOverviewRepository {
  static final _seed = [
    const GoalItem(
      id: 'g1',
      title: 'Read 20 pages',
      status: GoalStatus.inProgress,
      timeframe: GoalTimeframe.daily,
      progress: 0.6,
      dueLabel: 'Due tomorrow',
    ),
    const GoalItem(
      id: 'g2',
      title: 'Gym Session',
      status: GoalStatus.toDo,
      timeframe: GoalTimeframe.daily,
      progress: 0.0,
      dueLabel: 'Due tonight',
    ),
    const GoalItem(
      id: 'g3',
      title: 'Meditation 10min',
      status: GoalStatus.inProgress,
      timeframe: GoalTimeframe.daily,
      progress: 0.9,
      dueLabel: 'Due in 2 hrs',
    ),
    const GoalItem(
      id: 'g4',
      title: 'Weekly Review',
      status: GoalStatus.toDo,
      timeframe: GoalTimeframe.weekly,
      progress: 0.2,
      dueLabel: 'Due Sunday',
    ),
    const GoalItem(
      id: 'g5',
      title: 'Learn Flutter',
      status: GoalStatus.inProgress,
      timeframe: GoalTimeframe.monthly,
      progress: 0.45,
      dueLabel: 'Due end of month',
    ),
  ];

  @override
  AsyncResult<List<GoalItem>> getGoalsByTimeframe(GoalTimeframe tf) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final filtered = _seed.where((g) => g.timeframe == tf).toList();
    return success(filtered.isNotEmpty ? filtered : _seed.take(3).toList());
  }

  @override
  AsyncResult<GoalItem> updateProgress(String id, double progress) async {
    final goal = _seed.firstWhere((g) => g.id == id);
    final updated = goal.copyWith(progress: progress);
    return success(updated);
  }
}