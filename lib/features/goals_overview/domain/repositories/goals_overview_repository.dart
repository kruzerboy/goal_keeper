import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';

import '../../../../core/error/result.dart';

abstract interface class GoalsOverviewRepository {
  AsyncResult<List<GoalItem>> getGoalsByTimeframe(GoalTimeframe timeframe);
  AsyncResult<GoalItem> updateProgress(String id, double progress);
}