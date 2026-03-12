import '../../../../core/error/result.dart';
import '../entities/goal.dart';

/// Abstract contract — the domain layer depends on this,
/// NOT on any concrete implementation (data layer).
/// Swap Firestore → REST → SQLite without touching a single use case.
abstract interface class GoalRepository {
  /// Fetch all goals for the current user.
  AsyncResult<List<Goal>> getGoals();

  /// Fetch only today's goals.
  AsyncResult<List<Goal>> getTodaysGoals();

  /// Fetch a single goal by ID.
  AsyncResult<Goal> getGoalById(String id);

  /// Persist a new goal.
  AsyncResult<Goal> createGoal(Goal goal);

  /// Update an existing goal.
  AsyncResult<Goal> updateGoal(Goal goal);

  /// Soft-delete a goal.
  AsyncResult<void> deleteGoal(String id);

  /// Toggle completion status.
  AsyncResult<Goal> toggleGoalCompletion(String id);

  /// Stream for real-time updates (e.g. Firestore).
  Stream<List<Goal>> watchTodaysGoals();
}