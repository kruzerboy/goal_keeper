import '../../domain/entities/goal.dart';

/// Data Transfer Object — lives only in the data layer.
/// Knows about JSON, fromFirestore, toMap, etc.
/// The domain entity [Goal] knows nothing about serialization.
final class GoalModel extends Goal {
  const GoalModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.priority,
    required super.isCompleted,
    required super.createdAt,
    super.dueDate,
    super.scheduledTime,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) => GoalModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        category: GoalCategory.values.firstWhere(
          (c) => c.value == json['category'],
          orElse: () => GoalCategory.personal,
        ),
        priority: GoalPriority.values.firstWhere(
          (p) => p.name == json['priority'],
          orElse: () => GoalPriority.medium,
        ),
        isCompleted: json['isCompleted'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json['dueDate'] as String)
            : null,
        scheduledTime: json['scheduledTime'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.value,
        'priority': priority.name,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
        if (scheduledTime != null) 'scheduledTime': scheduledTime,
      };

  /// Convert domain entity → model (for sending to API/DB).
  factory GoalModel.fromEntity(Goal goal) => GoalModel(
        id: goal.id,
        title: goal.title,
        description: goal.description,
        category: goal.category,
        priority: goal.priority,
        isCompleted: goal.isCompleted,
        createdAt: goal.createdAt,
        dueDate: goal.dueDate,
        scheduledTime: goal.scheduledTime,
      );
}