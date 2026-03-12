import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../models/goal_model.dart';

/// Concrete implementation — swap datasource (REST, Firestore, SQLite)
/// without touching domain or presentation layers.
/// Currently uses in-memory fake data; replace with real datasource calls.
final class GoalRepositoryImpl implements GoalRepository {
  // Replace with: final GoalRemoteDataSource _remote;
  //               final GoalLocalDataSource _local;

  // In-memory seed data for UI development
  final List<GoalModel> _goals = [
    GoalModel(
      id: '1',
      title: 'Drink 2L Water',
      description: 'Stay hydrated throughout the day',
      category: GoalCategory.health,
      priority: GoalPriority.medium,
      isCompleted: true,
      createdAt: DateTime.now(),
    ),
    GoalModel(
      id: '2',
      title: 'Complete UI Design',
      description: 'Finish dashboard and goal detail screens',
      category: GoalCategory.work,
      priority: GoalPriority.high,
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
    GoalModel(
      id: '3',
      title: '30 min Yoga',
      description: 'Morning yoga session',
      category: GoalCategory.fitness,
      priority: GoalPriority.medium,
      isCompleted: false,
      scheduledTime: '06:00 PM',
      createdAt: DateTime.now(),
    ),
    GoalModel(
      id: '4',
      title: 'Read 20 pages',
      description: 'Current book: Atomic Habits',
      category: GoalCategory.learning,
      priority: GoalPriority.low,
      isCompleted: false,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  AsyncResult<List<Goal>> getGoals() async {
    await Future.delayed(const Duration(milliseconds: 400)); // simulate latency
    return success(List<Goal>.from(_goals));
  }

  @override
  AsyncResult<List<Goal>> getTodaysGoals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final today = _goals.take(3).toList();
    return success(List<Goal>.from(today));
  }

  @override
  AsyncResult<Goal> getGoalById(String id) async {
    final goal = _goals.where((g) => g.id == id).firstOrNull;
    if (goal == null) return failure(const NotFoundFailure('Goal not found.'));
    return success(goal);
  }

  @override
  AsyncResult<Goal> createGoal(Goal goal) async {
    final model = GoalModel.fromEntity(goal);
    _goals.add(model);
    return success(model);
  }

  @override
  AsyncResult<Goal> updateGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index == -1) return failure(const NotFoundFailure());
    final updated = GoalModel.fromEntity(goal);
    _goals[index] = updated;
    return success(updated);
  }

  @override
  AsyncResult<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    return success(null);
  }

  @override
  AsyncResult<Goal> toggleGoalCompletion(String id) async {
    final index = _goals.indexWhere((g) => g.id == id);
    if (index == -1) return failure(const NotFoundFailure());
    final toggled = GoalModel.fromEntity(
      _goals[index].copyWith(isCompleted: !_goals[index].isCompleted),
    );
    _goals[index] = toggled;
    return success(toggled);
  }

  @override
  Stream<List<Goal>> watchTodaysGoals() async* {
    yield List<Goal>.from(_goals.take(3));
  }
}