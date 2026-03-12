/// Extended goal entity with progress tracking
final class GoalItem {
  final String id;
  final String title;
  final GoalStatus status;
  final GoalTimeframe timeframe;
  final double progress; // 0.0 – 1.0
  final String dueLabel; // "Due tomorrow", "Due tonight", etc.
  final String? imageAsset;

  const GoalItem({
    required this.id,
    required this.title,
    required this.status,
    required this.timeframe,
    required this.progress,
    required this.dueLabel,
    this.imageAsset,
  });

  GoalItem copyWith({double? progress, GoalStatus? status}) => GoalItem(
        id: id,
        title: title,
        status: status ?? this.status,
        timeframe: timeframe,
        progress: progress ?? this.progress,
        dueLabel: dueLabel,
        imageAsset: imageAsset,
      );
}

enum GoalStatus {
  inProgress('IN PROGRESS'),
  toDo('TO DO'),
  completed('COMPLETED');

  final String label;
  const GoalStatus(this.label);
}

enum GoalTimeframe { daily, weekly, monthly, yearly, life }

enum PriorityLevel { low, medium, high }