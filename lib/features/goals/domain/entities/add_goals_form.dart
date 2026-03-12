import 'package:goal_keeper_app/features/goals/domain/entities/goal_item.dart';


final class AddGoalForm {
  final String name;
  final String? category;
  final PriorityLevel priority;
  final DateTime? deadline;

  const AddGoalForm({
    this.name = '',
    this.category,
    this.priority = PriorityLevel.medium,
    this.deadline,
  });

  bool get isValid => name.trim().isNotEmpty;

  AddGoalForm copyWith({
    String? name,
    String? category,
    PriorityLevel? priority,
    DateTime? deadline,
  }) =>
      AddGoalForm(
        name: name ?? this.name,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        deadline: deadline ?? this.deadline,
      );
}