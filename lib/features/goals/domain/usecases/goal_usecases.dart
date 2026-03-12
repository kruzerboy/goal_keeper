import '../../../../core/error/result.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/goal.dart';
import '../repositories/goal_repository.dart';

// ─── Get today's goals ──────────────────────────────────────────────────────

final class GetTodaysGoalsUseCase implements UseCase<List<Goal>, NoParams> {
  final GoalRepository _repository;
  const GetTodaysGoalsUseCase(this._repository);

  @override
  AsyncResult<List<Goal>> call(NoParams params) =>
      _repository.getTodaysGoals();
}

// ─── Get all goals ──────────────────────────────────────────────────────────

final class GetGoalsUseCase implements UseCase<List<Goal>, NoParams> {
  final GoalRepository _repository;
  const GetGoalsUseCase(this._repository);

  @override
  AsyncResult<List<Goal>> call(NoParams params) => _repository.getGoals();
}

// ─── Toggle completion ──────────────────────────────────────────────────────

final class ToggleGoalCompletionUseCase implements UseCase<Goal, String> {
  final GoalRepository _repository;
  const ToggleGoalCompletionUseCase(this._repository);

  @override
  AsyncResult<Goal> call(String id) => _repository.toggleGoalCompletion(id);
}

// ─── Create goal ────────────────────────────────────────────────────────────

final class CreateGoalUseCase implements UseCase<Goal, CreateGoalParams> {
  final GoalRepository _repository;
  const CreateGoalUseCase(this._repository);

  @override
  AsyncResult<Goal> call(CreateGoalParams params) =>
      _repository.createGoal(params.goal);
}

final class CreateGoalParams {
  final Goal goal;
  const CreateGoalParams(this.goal);
}

// ─── Delete goal ────────────────────────────────────────────────────────────

final class DeleteGoalUseCase implements UseCase<void, String> {
  final GoalRepository _repository;
  const DeleteGoalUseCase(this._repository);

  @override
  AsyncResult<void> call(String id) => _repository.deleteGoal(id);
}