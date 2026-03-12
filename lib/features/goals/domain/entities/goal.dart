/// Pure domain entity — zero Flutter imports, zero JSON logic.
/// This is the contract between domain and presentation.
class Goal {
  final String id;
  final String title;
  final String description;
  final GoalCategory category;
  final GoalPriority priority;
  final bool isCompleted;
  final DateTime? dueDate;
  final String? scheduledTime; // e.g. "06:00 PM"
  final DateTime createdAt;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.dueDate,
    this.scheduledTime,
  });

  bool get isDue =>
      dueDate != null && dueDate!.isBefore(DateTime.now()) && !isCompleted;

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    GoalCategory? category,
    GoalPriority? priority,
    bool? isCompleted,
    DateTime? dueDate,
    String? scheduledTime,
    DateTime? createdAt,
  }) =>
      Goal(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        priority: priority ?? this.priority,
        isCompleted: isCompleted ?? this.isCompleted,
        dueDate: dueDate ?? this.dueDate,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Goal && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

enum GoalCategory {
  health('Health', 'health'),
  work('Work', 'work'),
  fitness('Fitness', 'fitness'),
  learning('Learning', 'learning'),
  personal('Personal', 'personal'),
  finance('Finance', 'finance');

  final String label;
  final String value;
  const GoalCategory(this.label, this.value);
}

enum GoalPriority {
  low('Low'),
  medium('Medium'),
  high('Priority');

  final String label;
  const GoalPriority(this.label);
}// Pure Dart, zero Flutter imports
